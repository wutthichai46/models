<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [int8_accuracy.sh](int8_accuracy.sh) | Tests accuracy using the COCO dataset in the TF Records format. |
| [int8_inference.sh](int8_inference.sh) | Run inference using synthetic data and outputs performance metrics. |
| [icx_realtime_inference.sh](icx_realtime_inference.sh) | Realtime inference script for ICX that uses numactl to run multiple instances using 4 cores per instance. |
| [icx_throughput_inference.sh](icx_throughput_inference.sh) | Throughput inference script for ICX that uses numactl to run multiple instances using the cores on each socket per instance. |
| [int8_accuracy.sh](int8_accuracy.sh) | Tests accuracy using the COCO dataset in the TF Records format with an input size of 300x300. |
| [int8_inference.sh](int8_inference.sh) | Run inference using synthetic data with an input size of 300x300 and outputs performance metrics. |
| [multi_instance_batch_inference_1200.sh](multi_instance_batch_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with an input size of 1200x1200 and one instance per socket. Waits for all instances to complete, then prints a summarized throughput value. |
| [multi_instance_online_inference_1200.sh](multi_instance_online_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with an input size of 1200x1200 and four cores per instance. Waits for all instances to complete, then prints a summarized throughput value. |

These quickstart scripts can be run in different environments:
* [Bare Metal](#bare-metal)
* [Docker](#docker)
