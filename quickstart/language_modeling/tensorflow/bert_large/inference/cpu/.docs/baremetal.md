<!--- 50. Baremetal -->
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
        <li>numactl
        <li>unzip
        <li>wget
        <li>Activate the `tensorflow` conda environment
        <pre>conda activate tensorflow</pre>
      </ul>
    </td>
    <td>
      <p>To run without AI Kit on Linux you will need:</p>
      <ul>
        <li>Python 3
        <li><a href="https://pypi.org/project/intel-tensorflow/">intel-tensorflow>=2.5.0</a>
        <li>git
        <li>numactl
        <li>unzip
        <li>wget
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
    <td>
      <p>To run without AI Kit on Windows you will need:</p>
      <ul>
        <li><a href="/docs/general/Windows.md">Intel Model Zoo on Windows Systems prerequisites</a>
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
  </tr>
</table>

After your setup is done, download and unzip the pretrained model.
If you run on Windows, please use a browser to download and extract the checkpoint files and pretrained model using the links below.

### Pre-Trained Model

Download the model pretrained frozen graph from the given link based on the precision of your interest. Please set `PRETRAINED_MODEL` to point to the location of the pretrained model file on your local system.

* FP32:
  wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v2_7_0/fp32_bert_squad.pb
  PRETRAINED_MODEL=$(pwd)/fp32_bert_squad.pb

* BFloat16:
  wget https://storage.googleapis.com/intel-optimized-tensorflow/models/2_10_0/optimized_bf16_bert.pb

### Download checkpoints:
```bash
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/bert_large_checkpoints.zip
unzip bert_large_checkpoints.zip
export CHECKPOINT_DIR=$(pwd)/bert_large_checkpoints
```

### Run on Linux

Set environment variables to specify the dataset directory, precision to run, path to pretrained files and an output directory.
```
# Navigate to the models directory
cd models

# Set the required environment vars:
export PRECISION=<specify the precision to run: fp32 and bfloat16>
export DATASET_DIR=<path to the dataset>
export OUTPUT_DIR=<directory where log files will be written>
export PRETRAINED_MODEL=<path to the downloaded pre-trained model>
export CHECKPOINT_DIR=<path to the downloaded checkpoints folder>
# For a custom batch size, set env var `BATCH_SIZE` or it will run with a default value.
export BATCH_SIZE=<customized batch size value>

Run the script:
./quickstart/language_modeling/tensorflow/bert_large/inference/cpu/<script_name.sh>
```

### Run on Windows
The snippet below shows how to run a quickstart script on Windows systems:

> Note: You may use `cygpath` to convert the Windows paths to Unix paths before setting the environment variables. 
As an example, if the dataset location on Windows is `D:\user\wwm_uncased_L-24_H-1024_A-16`, convert the Windows path to Unix as shown:
> ```
> cygpath D:\user\wwm_uncased_L-24_H-1024_A-16
> /d/user/wwm_uncased_L-24_H-1024_A-16
>```
>Then, set the `DATASET_DIR` environment variable `set DATASET_DIR=/d/user/wwm_uncased_L-24_H-1024_A-16`.

```
# cd to your model zoo directory
cd models

# Set the required environment vars: Only fp32 is supported on windows
set PRECISION=fp32
set DATASET_DIR=<path to the dataset being used>
set OUTPUT_DIR=<directory where log files will be saved>
set CHECKPOINT_DIR=<path to the pretrained model checkpoints>
set PRETRAINED_MODEL=<path to the frozen graph>
# For a custom batch size, set env var `BATCH_SIZE` or it will run with a default value.
set BATCH_SIZE=<customized batch size value>

# Run a script for your desired usage:
# Only the following scripts run on windows: `inference.sh`, `accuracy.sh`, or `profile.sh`
bash quickstart\language_modeling\tensorflow\bert_large\inference\cpu\fp32\<script name>.sh
