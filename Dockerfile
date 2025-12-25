FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Speed up apt with parallel downloads and no recommendations
RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/99-no-recommends && \
    echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/99-no-recommends && \
    echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/99-no-translation && \
    echo 'Acquire::Queue-Mode "host";' >> /etc/apt/apt.conf.d/99-parallel

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-font-utils \
    git \
    curl \
    ca-certificates \
    python3-pip \
    python3-venv \
    jq \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN ARCH=$(uname -m) && \
    curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

# Create virtual environment and install OCI CLI for pushing to object storage
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir oci-cli

# Add venv to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Default command
CMD ["/bin/bash"]
