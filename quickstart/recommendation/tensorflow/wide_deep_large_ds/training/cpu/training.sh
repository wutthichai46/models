#!/usr/bin/env bash
#
# Copyright (c) 2020 Intel Corporation
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

if [ -z "${DATASET_DIR}" ]; then
  echo "The required environment variable DATASET_DIR has not been set"
  exit 1
fi

if [ ! -d "${DATASET_DIR}" ]; then
  echo "The DATASET_DIR '${DATASET_DIR}' does not exist"
  exit 1
fi

# If precision env is not mentioned, then the workload will run with the default precision.
if [ -z "${PRECISION}"]; then
  PRECISION=fp32
  echo "Running with default precision ${PRECISION}"
fi

if [[ $PRECISION != "fp32" ]]; then
  echo "The specified precision '${PRECISION}' is unsupported."
  echo "Supported precision is fp32."
  exit 1
fi

# Define a checkpoint arg, if CHECKPOINT_DIR was provided
CHECKPOINT_ARG=""
if [ ! -z "${CHECKPOINT_DIR}" ]; then
  # If a checkpoint dir was provided, ensure that it exists, then setup the arg
  mkdir -p ${CHECKPOINT_DIR}
  CHECKPOINT_ARG="--checkpoint=${CHECKPOINT_DIR}"
fi

# If batch size env is not mentioned, then the workload will run with the default batch size.
if [ -z "${BATCH_SIZE}"]; then
  BATCH_SIZE="512"
  echo "Running with default batch size of ${BATCH_SIZE}"
fi

# Run wide and deep large dataset training
source "$MODEL_DIR/quickstart/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
   --model-name wide_deep_large_ds \
   --precision ${PRECISION} \
   --mode training  \
   --framework tensorflow \
   --batch-size ${BATCH_SIZE} \
   --data-location $DATASET_DIR \
   $CHECKPOINT_ARG \
   --output-dir $OUTPUT_DIR \
   $@

