FROM jenkins/inbound-agent:3283.v92c105e0f819-7

# Switch to root to install additional packages
USER root

# Update package lists and install prerequisites, including Python and pip.
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    jq \
    python3 \
    python3-pip \
    bat \
    bridge-utils \
    btop \
    cpu-checker \
    dnsutils \
    duf \
    ethtool \
    fd-find \
    gh \
    git \
    htop \
    ifupdown \
    iotop \
    iperf3 \
    iptables \
    libvirt-clients \
    libvirt-daemon-system \
    lshw \
    lsof \
    make \
    default-mysql-client \
    nano \
    net-tools \
    netcat-openbsd \
    neovim \
    nfs-common \
    nmap \
    open-iscsi \
    parted \
    postgresql-client \
    python3-venv \
    qemu-guest-agent \
    qemu-kvm \
    qemu-system \
    qemu-system-x86 \
    ripgrep \
    rsync \
    screen \
    smartmontools \
    strace \
    tcpdump \
    tmux \
    traceroute \
    tree \
    ufw \
    unzip \
    util-linux \
    vim \
    virtinst \
    wget \
    whois \
    xorriso \
    zip

# Install boto3 and botocore via pip, overriding system restrictions.
RUN pip3 install --break-system-packages boto3 botocore

# Add the HashiCorp GPG key and repository (Terraform + Packer come from here)
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

# Install Terraform, Packer, and Ansible
RUN apt-get update && apt-get install -y \
    terraform \
    packer \
    ansible && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install MinIO Client
RUN curl -sSL https://dl.min.io/client/mc/release/linux-amd64/mc -o mc && \
    chmod +x mc && mv mc /usr/local/bin/

# Switch back to the default (jenkins) user
USER jenkins
