# PyTorch Mask R-CNN Training

## Description
This document has instructions for running Mask R-CNN training using Intel® Optimization for PyTorch*.

## Pull Command
```
docker pull intel/image-segmentation:spr-maskrcnn-training
```

<table>
   <thead>
      <tr>
         <th>Script name</th>
         <th>Description</th>
      </tr>
   </thead>
   <tbody>
      <tr>
         <td>training.sh</td>
         <td>Runs training for the specified precision (fp32, avx-fp32, bf16, or bf32).</td>
      </tr>
   </tbody>
</table>

Note: The `avx-fp32` precision runs the same scripts as `fp32`, except that the `DNNL_MAX_CPU_ISA` environment variable is unset. The environment variable is otherwise set to `DNNL_MAX_CPU_ISA=AVX512_CORE_AMX`.

## Datasets
Download the 2017 [COCO dataset](https://cocodataset.org). Export the `DATASET_DIR` environment variable to specify the directory where the dataset will be downloaded. This environment variable will be used again when running quickstart scripts.

```bash
export DATASET_DIR=<directory where the dataset will be saved>

mkdir -p ${DATASET_DIR}/coco
curl -o ${DATASET_DIR}/coco/train2017.zip http://images.cocodataset.org/zips/train2017.zip
unzip ${DATASET_DIR}/coco/train2017.zip -d ${DATASET_DIR}/coco/
curl -o ${DATASET_DIR}/coco/val2017.zip http://images.cocodataset.org/zips/val2017.zip
unzip ${DATASET_DIR}/coco/val2017.zip -d ${DATASET_DIR}/coco/
curl -o ${DATASET_DIR}/coco/annotations_trainval2017.zip http://images.cocodataset.org/annotations/annotations_trainval2017.zip
unzip ${DATASET_DIR}/coco/annotations_trainval2017.zip -d ${DATASET_DIR}/coco/
```

## Docker Run
(Optional) Export related proxy into docker environment.
```bash
export DOCKER_RUN_ENVS="-e ftp_proxy=${ftp_proxy} \
  -e FTP_PROXY=${FTP_PROXY} -e http_proxy=${http_proxy} \
  -e HTTP_PROXY=${HTTP_PROXY} -e https_proxy=${https_proxy} \
  -e HTTPS_PROXY=${HTTPS_PROXY} -e no_proxy=${no_proxy} \
  -e NO_PROXY=${NO_PROXY} -e socks_proxy=${socks_proxy} \
  -e SOCKS_PROXY=${SOCKS_PROXY}"
```

To run Mask R-CNN training, set environment variables to specify the dataset directory, precision to run, and an output directory. 
```bash
# Set the required environment vars
export BATCH_SIZE=<batch size>
export DATASET_DIR=<path to the dataset>
export OUTPUT_DIR=<directory where log files will be written>
export PRECISION=<specify the precision to run (fp32, avx-fp32, bf16, or bf32)>

docker run --rm \
  --env BATCH_SIZE=${BATCH_SIZE} \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -it \
  --shm-size 8G \
  -w /workspace/pytorch-spr-maskrcnn-training \
  intel/image-segmentation:spr-maskrcnn-training \
  /bin/bash quickstart/training.sh ${PRECISION}
```

## Documentation and Sources
#### Get Started​
[Docker* Repository](https://hub.docker.com/r/intel/image-segmentation)

[Main GitHub*](https://github.com/IntelAI/models)

[Release Notes](https://github.com/IntelAI/models/releases)

[Get Started Guide](https://github.com/IntelAI/models/blob/master/quickstart/object_detection/pytorch/maskrcnn/training/cpu/README.md)

#### Code Sources
[Dockerfile](https://github.com/IntelAI/models/tree/master/dockerfiles/pytorch)

[Report Issue](https://community.intel.com/t5/Intel-Optimized-AI-Frameworks/bd-p/optimized-ai-frameworks)

## License Agreement
LEGAL NOTICE: By accessing, downloading or using this software and any required dependent software (the “Software Package”), you agree to the terms and conditions of the software license agreements for the Software Package, which may also include notices, disclaimers, or license terms for third party software included with the Software Package. Please refer to the [license](https://github.com/IntelAI/models/tree/master/third_party) file for additional details.

[View All Containers and Solutions 🡢](https://www.intel.com/content/www/us/en/developer/tools/software-catalog/containers.html?s=Newest)
