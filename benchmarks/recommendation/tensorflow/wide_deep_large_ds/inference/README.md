<!--- 0. Title -->
# Wide and Deep using a large dataset inference

<!-- 10. Description -->
## Description

This document has instructions for running Wide and Deep using a large dataset inference using
Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

Follow [instructions](https://github.com/IntelAI/models/tree/master/datasets/large_kaggle_advertising_challenge/README.md)
to download and preprocess the Large Kaggle Display Advertising Challenge Dataset.

Then, set the `DATASET_DIR` to point to this directory when running Wide and Deep using a large dataset:
```
export DATASET_DIR=/home/<user>/dataset/eval_preprocessed_eval.tfrecords
```

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`online_inference.sh`](/quickstart/recommendation/tensorflow/wide_deep_large_ds/inference/cpu/online_inference.sh) | Runs online inference (`batch_size=1`). The `NUM_OMP_THREADS` environment variable and the hyperparameters `num-intra-threads`, `num-inter-threads` can be tuned for best performance. If `NUM_OMP_THREADS` is not set, it will default to `1`. |
| [`accuracy.sh`](/quickstart/recommendation/tensorflow/wide_deep_large_ds/inference/cpu/accuracy.sh) | Measures the model accuracy (`batch_size=1000`). |

<!--- 50. AI Kit -->
## Run the model

Setup your environment using the instructions below, depending on if you are
using [AI Kit](/docs/general/tensorflow/AIKit.md):

<table>
  <tr>
    <th>Setup using AI Kit</th>
    <th>Setup without AI Kit</th>
  </tr>
  <tr>
    <td>
      <p>AI Kit does not currently support wide and deep large ds</p>
    </td>
    <td>
      <p>To run without AI Kit you will need:</p>
      <ul>
        <li>Python 3.7 or newer
        <li><a href="https://pypi.org/project/intel-tensorflow">intel-tensorflow>=2.5.0</a>
        <li>numactl
        <li>git
        <li>wget
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
  </tr>
</table>

After completing the setup, download the pretrained model frozen graph
and save the path to the PRETRAINED_MODEL envionment variable.
```
# FP32 Pretrained Model
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/wide_deep_fp32_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/wide_deep_fp32_pretrained_model.pb

# Int8 Pretrained Model
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/wide_deep_int8_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/wide_deep_int8_pretrained_model.pb
```

Set the environment variables and run quickstart script. See the list of quickstart scripts for details on the different options.

```
# cd to your model zoo directory
cd models

export DATASET_DIR=<path to TF records file>
export PRECISION=<set the precision to "int8" or "fp32">
export OUTPUT_DIR=<path to the directory where log files will be written>
export PRETRAINED_MODEL=<path to the frozen graph>
# For a custom batch size, set env var `BATCH_SIZE` or it will run with a default value.
export BATCH_SIZE=<customized batch size value>

# Run inference with an accuracy check
./quickstart/recommendation/tensorflow/wide_deep_large_ds/inference/cpu/accuracy.sh

# Run online inference and set NUM_OMP_THREADS
export NUM_OMP_THREADS=1
./quickstart/recommendation/tensorflow/wide_deep_large_ds/inference/cpu/online_inference.sh \
--num-intra-threads 1 --num-inter-threads 1
```

<!--- 90. Resource Links-->
## Additional Resources

* To run more advanced use cases, see the instructions for the available precisions [FP32](fp32/Advanced.md) [Int8](int8/Advanced.md) [<bfloat16 precision>](<bfloat16 advanced readme link>) for calling the `launch_benchmark.py` script directly.
* To run the model using docker, please see the [Intel® Developer Catalog](http://software.intel.com/containers)
  workload container:<br />
  [https://software.intel.com/content/www/us/en/develop/articles/containers/wide-deep-large-dataset-fp32-inference-tensorflow-container.html](https://software.intel.com/content/www/us/en/develop/articles/containers/wide-deep-large-dataset-fp32-inference-tensorflow-container.html).
