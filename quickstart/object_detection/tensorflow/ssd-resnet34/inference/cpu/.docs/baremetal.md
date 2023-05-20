<!--- 50. AI Kit -->
## Run the model

Setup your environment using the instructions below, depending on if you are
using [AI Kit](/docs/general/tensorflow/AIKit.md):

<table>
  <tr>
    <th>Setup using AI Kit on Linux</th>
    <th>Setup without AI Kit on Linux</th>
    <th>Setup without AI Kit on Windows</th>
  </tr>
  <tr>
    <td>
      <p>To run using AI Kit on Linux you will need:</p>
      <ul>
        <li>build-essential
        <li>git
        <li>libgl1-mesa-glx
        <li>libglib2.0-0
        <li>numactl
        <li>python3-dev
        <li>wget
        <li>Cython
        <li>contextlib2
        <li>horovod==0.24.3
        <li>jupyter
        <li>lxml
        <li>matplotlib
        <li>numpy>=1.17.4
        <li>opencv-python
        <li>pillow>=9.3.0
        <li>pycocotools
        <li>tensorflow-addons==0.18.0
        <li>Activate the tensorflow 2.5.0 conda environment
        <pre>conda activate tensorflow</pre>
      </ul>
    </td>
    <td>
      <p>To run without AI Kit on Linux you will need:</p>
      <ul>
        <li>Python 3
        <li>build-essential
        <li>git
        <li>libgl1-mesa-glx
        <li>libglib2.0-0
        <li>numactl
        <li>python3-dev
        <li>wget
        <li><a href="https://pypi.org/project/intel-tensorflow/">intel-tensorflow>=2.5.0</a>
        <li>Cython
        <li>contextlib2
        <li>horovod==0.24.3
        <li>jupyter
        <li>lxml
        <li>matplotlib
        <li>opencv-python
        <li>pillow>=9.3.0
        <li>pycocotools
        <li>tensorflow-addons==0.18.0
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
    <td>
      <p>To run without AI Kit on Windows you will need:</p>
      <ul>
        <li><a href="/docs/general/Windows.md">Intel Model Zoo on Windows Systems prerequisites</a>
        <li>build-essential
        <li>Cython
        <li>contextlib2
        <li>jupyter
        <li>lxml
        <li>matplotlib
        <li>opencv-python
        <li>pillow>=9.3.0
        <li>pycocotools
        <li>tensorflow-addons==0.18.0
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
  </tr>
</table>

The [TensorFlow models](https://github.com/tensorflow/models) and
[benchmarks](https://github.com/tensorflow/benchmarks) repos are used by
SSD-ResNet34 inference. Clone those at the git SHAs specified
below and set the `TF_MODELS_DIR` environment variable to point to the
directory where the models repo was cloned.

```
git clone --single-branch https://github.com/tensorflow/models.git tf_models
git clone --single-branch https://github.com/tensorflow/benchmarks.git ssd-resnet-benchmarks
cd tf_models
export TF_MODELS_DIR=$(pwd)
git checkout f505cecde2d8ebf6fe15f40fb8bc350b2b1ed5dc
cd ../ssd-resnet-benchmarks
git checkout 509b9d288937216ca7069f31cfb22aaa7db6a4a7
cd ..
```

Download the SSD-ResNet34 pretrained model for either the 300x300 or 1200x1200
input size, depending on which [quickstart script](#quick-start-scripts) you are
going to run. Set the `PRETRAINED_MODEL` environment variable for the path to the
pretrained model that you'll be using.
If you run on Windows, please use a browser to download the pretrained model using the link below.
For Linux, run:
```
# SSD-ResNet34 FP32 and BFloat16 300x300 Pretrained model
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/ssd_resnet34_fp32_bs1_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/ssd_resnet34_fp32_bs1_pretrained_model.pb

# SSD-ResNet34 FP32 and BFloat16 1200x1200 Pretrained model
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/ssd_resnet34_fp32_1200x1200_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/ssd_resnet34_fp32_1200x1200_pretrained_model.pb

# SSD-ResNet34 Int8 300x300 Pretrained model
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/ssd_resnet34_int8_bs1_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/ssd_resnet34_int8_bs1_pretrained_model.pb

# SSD-ResNet34 Int8 1200x1200 Pretrained model
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/ssd_resnet34_int8_1200x1200_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/ssd_resnet34_int8_1200x1200_pretrained_model.pb
```

Set the environment variables and run quickstart script on either Linux or Windows systems. If the accuracy test is being run, then set the `DATASET_DIR` to point to the folder where the COCO dataset
`validation-00000-of-00001` file is located. See the list of quickstart scripts for details on the different options.

### Run on Linux
```
# cd to your model zoo directory
cd models

# set environment variables
export DATASET_DIR=<directory with the validation-*-of-* files (for accuracy testing only)>
export TF_MODELS_DIR=<path to the TensorFlow Models repo>
export PRECISION=<set the precision to "int8" or "fp32" or "bfloat16">
export PRETRAINED_MODEL=<path to the 300x300 or 1200x1200 pretrained model pb file>
export OUTPUT_DIR=<path to the directory where log files will be written>
# For a custom batch size, set env var `BATCH_SIZE` or it will run with a default value.
export BATCH_SIZE=<customized batch size value>

./quickstart/object_detection/tensorflow/ssd-resnet34/inference/cpu/<script name>.sh
```

### Run on Windows
Using `cmd.exe`,  run:
```
# cd to your model zoo directory
cd models

set PRETRAINED_MODEL=<path to the 300x300 or 1200x1200 pretrained model pb file>
set DATASET_DIR=<directory with the validation-*-of-* files (for accuracy testing only)>
set PRECISION=<set the precision to "int8" or "fp32">
set OUTPUT_DIR=<directory where log files will be written>
set TF_MODELS_DIR=<path to the TensorFlow Models repo>
# For a custom batch size, set env var `BATCH_SIZE` or it will run with a default value.
set BATCH_SIZE=<customized batch size value>

bash quickstart\object_detection\tensorflow\ssd-resnet34\inference\cpu\<script name>.sh
```
> Note: You may use `cygpath` to convert the Windows paths to Unix paths before setting the environment variables. 
As an example, if the dataset location on Windows is `D:\user\coco_dataset`, convert the Windows path to Unix as shown:
> ```
> cygpath D:\user\coco_dataset
> /d/user/coco_dataset
>```
>Then, set the `DATASET_DIR` environment variable `set DATASET_DIR=/d/user/coco_dataset`.
