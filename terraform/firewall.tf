resource "google_compute_firewall" "allow_tpu_access" {
  provider = google-beta
  name     = "allow-tpu-ingress"
  # 注意：确保这里填的是你 TPU 所在的 VPC 网络名称
  # 如果你没动过网络配置，通常默认就是 "default"
  network = "default"

  # 1. 定义允许的协议和端口
  allow {
    protocol = "tcp"
    ports = [
      "22",   # SSH
      "8888", # Jupyter Notebook
      "6006"  # TensorBoard (可选)
    ]
  }

  # 2. 允许的来源 IP (Source Ranges)
  # "0.0.0.0/0" 表示允许全世界访问 (方便但有风险)
  # 建议改成你自己的公网 IP，例如 ["1.2.3.4/32"]
  source_ranges = ["0.0.0.0/0"]

  # 3. 目标标签 (Target Tags)
  # 这条规则只会应用到带有 "tpu-firewall-access" 标签的机器上
  # 这样做比 "Apply to all" 更安全、更规范
  target_tags = ["tpu-firewall-access"]
}
