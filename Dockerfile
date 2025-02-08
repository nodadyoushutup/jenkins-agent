FROM jenkins/inbound-agent:3283.v92c105e0f819-7

# Switch to root to install additional packages
USER root

# Update package lists and install prerequisites
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Add the HashiCorp GPG key and repository so we can install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

# Update package lists and install both Terraform and Ansible
RUN apt-get update && apt-get install -y terraform ansible && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to the default (jenkins) user
USER jenkins
