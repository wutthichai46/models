<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| `inference.sh` | Runs inference (batch-size=1) to compute latency for the specified precision (int8, fp32, or bfloat16). |
| `inference_realtime_multi_instance.sh` | Runs multi instance realtime inference (batch-size=1) to compute latency using 4 cores per instance for the specified precision (int8, fp32, or bfloat16). |
| `inference_throughput_multi_instance.sh` | Runs multi instance batch inference with batch-size=448 for precisions (int8, fp32, bfloat16) to get throughput using 1 instance per socket. |
| `accuracy.sh` | Measures the inference accuracy for the specified precision (int8, fp32, or bfloat16). |
