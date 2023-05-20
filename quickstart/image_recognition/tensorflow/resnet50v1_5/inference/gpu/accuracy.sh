#!/usr/bin/env bash
#
# Copyright (c) 2022 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

MODEL_DIR=${MODEL_DIR-$PWD}

echo 'MODEL_DIR='$MODEL_DIR
echo 'PRECISION='$PRECISION
echo 'OUTPUT_DIR='$OUTPUT_DIR
echo 'DATASET_DIR='$DATASET_DIR

export TF_NUM_INTEROP_THREADS=1
export DATA_NUM_INTER_THREADS=1

# Create an array of input directories that are expected and then verify that they exist
declare -A input_envs
input_envs[PRECISION]=${PRECISION}
input_envs[OUTPUT_DIR]=${OUTPUT_DIR}
input_envs[DATASET_DIR]=${DATASET_DIR}
input_envs[GPU_TYPE]=${GPU_TYPE}

for i in "${!input_envs[@]}"; do
  var_name=$i
  env_param=${input_envs[$i]}
 
  if [[ -z $env_param ]]; then
    echo "The required environment variable $var_name is not set" >&2
    exit 1
  fi
done

# Create the output directory in case it doesn't already exist
mkdir -p ${OUTPUT_DIR}

if [ ! -d "${DATASET_DIR}" ]; then
  echo "The DATASET_DIR '${DATASET_DIR}' does not exist"
  exit 1
fi

# Check for GPU type
if [[ $GPU_TYPE == "flex_series" ]]; then
  export OverrideDefaultFP64Settings=1 
  export IGC_EnableDPEmulation=1 
  if [[ $PRECISION == "int8" ]]; then
    WARMUP="-- warmup_steps=5 steps=25"
    if [[ ! -f "${FROZEN_GRAPH}" ]]; then
      pretrained_model=/workspace/tf-flex-series-resnet50v1-5-inference/pretrained_models/resnet50v1_5-frozen_graph-${PRECISION}-gpu.pb
    else
      pretrained_model=${FROZEN_GRAPH}
    fi
  else 
    echo "FLEX SERIES GPU SUPPORTS ONLY INT8 PRECISION"
    exit 1
  fi
  
  # If batch size env is not mentioned, then the workload will run with the default batch size.
  if [ -z "${BATCH_SIZE}"]; then
    BATCH_SIZE=32
    echo "Running with default batch size of ${BATCH_SIZE}"
  fi
elif [[ $GPU_TYPE == "max_series" ]]; then
  if [[ $PRECISION == "int8" || $PRECISION == "fp16"  || $PRECISION == "fp32" ]]; then
    WARMUP="-- warmup_steps=5 steps=20 disable-tcmalloc=True"
    if [[ ! -f "${FROZEN_GRAPH}" ]]; then
      pretrained_model=/workspace/tf-max-series-resnet50v1-5-inference/pretrained_models/resnet50v1_5-frozen_graph-${PRECISION}-gpu.pb
    else
      pretrained_model=${FROZEN_GRAPH}
    fi
  else 
    echo "MAX SERIES GPU SUPPORTS ONLY INT8, FP32 AND FP16 PRECISION"
    exit 1
  fi
  
  # If batch size env is not mentioned, then the workload will run with the default batch size.
  if [ -z "${BATCH_SIZE}"]; then
    BATCH_SIZE="1024"
    echo "Running with default batch size of ${BATCH_SIZE}"
  fi
fi

if [[ $PRECISION == "fp16" ]]; then
  export ITEX_AUTO_MIXED_PRECISION=1
  export ITEX_AUTO_MIXED_PRECISION_DATA_TYPE="FLOAT16"
fi

source "${MODEL_DIR}/quickstart/common/utils.sh"
_command python benchmarks/launch_benchmark.py \
         --model-name=resnet50v1_5 \
         --precision=${PRECISION} \
         --mode=inference \
         --framework tensorflow \
         --in-graph ${pretrained_model} \
         --data-location=${DATASET_DIR} \
         --output-dir ${OUTPUT_DIR} \
         --accuracy-only \
         --batch-size=${BATCH_SIZE} \
         --gpu \
         $@
