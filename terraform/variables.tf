variable "project_id" { description = "你的 GCP 项目 ID" }
variable "region"     { description = "默认区域" }
variable "zone"       { description = "具体可用区 (如 us-west1-c)" }
variable "tpu_name"   { description = "TPU 机器名称" }
variable "accelerator_type" { default = "v5litepod-4" }
variable "runtime_version"  { default = "v2-alpha-tpuv5-lite" }