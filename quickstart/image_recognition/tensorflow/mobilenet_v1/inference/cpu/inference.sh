#!/usr/bin/env bash
#
# Copyright (c) 2021 Intel Corporation
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

if [ -z "${OUTPUT_DIR}" ]; then
  echo "The required environment variable OUTPUT_DIR has not been set"
  exit 1
fi

# Create the output directory in case it doesn't already exist
mkdir -p ${OUTPUT_DIR}

if [ -z "${PRECISION}" ]; then
  echo "The required environment variable PRECISION has not been set"
  echo "Please set PRECISION to fp32, int8, or bfloat16."
  exit 1
fi

if [[ $PRECISION != "fp32" ]] && [[ $PRECISION != "int8" ]] && [[ $PRECISION != "bfloat16" ]]; then
  echo "The specified precision '${PRECISION}' is unsupported."
  echo "Supported precisions are: fp32, bfloat16, and int8"
  exit 1
fi

# Use synthetic data (no --data-location arg) if no DATASET_DIR is set
dataset_arg="--data-location=${DATASET_DIR}"
if [ -z "${DATASET_DIR}" ]; then
  echo "Using synthetic data, since the DATASET_DIR environment variable is not set."
  dataset_arg=""
elif [ ! -d "${DATASET_DIR}" ]; then
  echo "The DATASET_DIR '${DATASET_DIR}' does not exist"
  exit 1
fi

if [ -z "${PRETRAINED_MODEL}" ]; then
    if [[ $PRECISION == "int8" ]]; then
        PRETRAINED_MODEL="${MODEL_DIR}/pretrained_model/mobilenet_v1_int8_pretrained_model.pb"
    elif [[ $PRECISION == "bfloat16" ]]; then
        PRETRAINED_MODEL="${MODEL_DIR}/pretrained_model/mobilenet_v1_bfloat16_pretrained_model.pb"
    elif [[ $PRECISION == "fp32" ]]; then
        PRETRAINED_MODEL="${MODEL_DIR}/pretrained_model/mobilenet_v1_fp32_pretrained_model.pb"
    else
        echo "The specified precision '${PRECISION}' is unsupported."
        echo "Supported precisions are: fp32, bfloat16, and int8"
        exit 1
    fi
    if [[ ! -f "${PRETRAINED_MODEL}" ]]; then
    echo "The pretrained model could not be found. Please set the PRETRAINED_MODEL env var to point to the frozen graph file."
    exit 1
    fi
elif [[ ! -f "${PRETRAINED_MODEL}" ]]; then
  echo "The file specified by the PRETRAINED_MODEL environment variable (${PRETRAINED_MODEL}) does not exist."
  exit 1
fi

if [ $PRECISION == "bfloat16" ]; then
  export TF_AUTO_MIXED_PRECISION_GRAPH_REWRITE_INFERLIST_REMOVE="BiasAdd"
  export TF_AUTO_MIXED_PRECISION_GRAPH_REWRITE_DENYLIST_REMOVE="Softmax"
  export TF_AUTO_MIXED_PRECISION_GRAPH_REWRITE_ALLOWLIST_ADD="BiasAdd|Softmax"
fi

# If batch size env is not mentioned, then the workload will run with the default batch size.
if [ -z "${BATCH_SIZE}"]; then
  BATCH_SIZE="1"
  echo "Running with default batch size of ${BATCH_SIZE}"
fi

MODE="inference"
CORES_PER_INSTANCE="4"

source "${MODEL_DIR}/quickstart/common/utils.sh"
_ht_status_spr
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
  --model-name=mobilenet_v1 \
  --precision ${PRECISION} \
  --mode=${MODE} \
  --framework tensorflow \
  --in-graph ${PRETRAINED_MODEL} \
  ${dataset_arg} \
  --output-dir ${OUTPUT_DIR} \
  --batch-size ${BATCH_SIZE} \
  $@ \
  -- input_height=224 input_width=224 warmup_steps=500 steps=1000 \
  input_layer='input' output_layer='MobilenetV1/Predictions/Reshape_1'

