<!--- 40. Docker -->
## Docker

The model container includes the scripts and libraries needed to run 
DLRM inference in int8 precision.

To run the accuracy test, you will need
mount a volume and set the `DATASET_DIR` environment variable to point
to the prepped [Terabyte Click Logs Dataset](#dataset). The accuracy
script needs the model weight so you can set the `WEIGHT_PATH` environment
variable to point to the model weight and mount the volume as well. Note that
only to calculate the accuracy you'll need the `WEIGHT_PATH`.

```
export DATASET_DIR=<path to the dataset folder>
export WEIGHT_PATH=<path to model weights>
docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env WEIGHT_PATH=${WEIGHT_PATH} \
  --env BASH_ENV=/root/.bash_profile \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${WEIGHT_PATH}:${WEIGHT_PATH} \
  --privileged --init -t \
  intel/recommendation:pytorch-1.5.0-rc3-icx-a37fb5e8-dlrm-int8 \
  /bin/bash quickstart/inference_accuracy.sh
```

Model weight is not needed for rest of the scripts so you can use them as below.

```
export DATASET_DIR=<path to the dataset folder>
docker run \
  --env BASH_ENV=/root/.bash_profile \
  --env DATASET_DIR=${DATASET_DIR} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --privileged --init -t \
  intel/recommendation:pytorch-1.5.0-rc3-icx-a37fb5e8-dlrm-int8 \
  /bin/bash quickstart/<script name>.sh
```
