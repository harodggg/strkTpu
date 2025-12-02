provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# 定义 TPU VM 资源
resource "google_tpu_v2_vm" "tpu_instance" {
  provider = google-beta
  name     = var.tpu_name
  zone     = var.zone

  # 硬件配置 (v5e-4)
  accelerator_type = var.accelerator_type

  # 软件版本 (v5e 专用镜像)
  runtime_version = var.runtime_version

  tags = ["tpu-firewall-access"]

  # 抢占式配置 (省钱关键)
  scheduling_config {
    preemptible = true
  }

  # 网络配置 (默认)
  network_config {
    enable_external_ips = true
  }

  metadata = {

    enable-oslogin = "FALSE"

    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"

    # 2. 核心魔法：启动脚本
    # 这里的脚本会以 ROOT 身份在开机时运行
    startup-script = <<-EOT
      #! /bin/bash
      
      # --- A. 设置日志 (重要：方便你排查安装卡在哪了) ---
      exec > /var/log/startup_script.log 2>&1
      set -x
      echo "=== 开始自动初始化环境 ==="

      # --- B. 安装基础工具 ---
      apt-get update
      apt-get install -y git python3-pip python3-venv

      # --- C. 准备工作目录 ---
      # 我们把东西放在 /root 目录下 (因为你上一条指令说要用 root 登录)
      # 如果你是用 ubuntu 用户登录，建议改为 /home/ubuntu
      WORK_DIR="/root/workspace"
      mkdir -p $WORK_DIR
      cd $WORK_DIR


      apt install -y ipython3
      # --- D. 自动拉取代码 ---
      echo "正在克隆代码..."
      # 替换成你的仓库地址
      git clone https://github.com/harodggg/strkTpu.git
      
      # --- E. 安装 JAX (最耗时步骤) ---
      echo "正在安装 JAX TPU 版本..."
      # 注意：在较新的 Ubuntu 上，直接 pip install 可能会报错，增加 --break-system-packages
      pip3 install --upgrade "jax[tpu]" \
        -f https://storage.googleapis.com/jax-releases/libtpu_releases.html 

      # --- F. 安装项目依赖 (如果有 requirements.txt) ---
      if [ -f "$WORK_DIR/strkTpu/requirements.txt" ]; then
          pip3 install -r "$WORK_DIR/strkTpu/requirements.txt" --break-system-packages
      fi

      echo "=== 环境初始化完成！ ==="
      # 创建一个标记文件，告诉你什么时候装完了
      touch /root/INSTALL_FINISHED
      echo "=== 开始配置 Root 登录 ==="
      
      # A. 修改 /etc/ssh/sshd_config
      # 很多 GCP 镜像默认是 "PermitRootLogin no"
      # 我们把它改成 "prohibit-password" (允许密钥，禁止密码)
      # 下面两行分别处理“被注释”和“未被注释”的情况
       sed -i 's/^#PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
       sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
      
      # B. 确保 Authorized Keys 权限正确
      # GCP 的守护进程有时会自动生成这个文件，我们确保权限不被篡改
      if [ -d /root/.ssh ]; then
        chmod 700 /root/.ssh
        if [ -f /root/.ssh/authorized_keys ]; then
            chmod 600 /root/.ssh/authorized_keys
        fi
      fi
      
      # C. 重启 SSH 服务使配置生效
      service ssh restart
      
      echo "=== Root 登录配置完成 ==="



    EOT
  }
}

# 输出 SSH 连接命令 (方便你直接复制)
output "ssh_command" {
  value = "gcloud compute tpus tpu-vm ssh ${google_tpu_v2_vm.tpu_instance.name} --zone=${google_tpu_v2_vm.tpu_instance.zone} --ssh-key-file=~/.ssh/id_rsa --ssh-flag='-l root'"
}
# gcloud compute tpus tpu-vm ssh my-tpu-v5-worker --zone=asia-east1-b
