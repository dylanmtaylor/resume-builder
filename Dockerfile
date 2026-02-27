FROM dhi.io/debian-base:trixie-dev AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/99-no-recommends && \
    echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/99-no-recommends && \
    echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/99-no-translation && \
    echo 'Acquire::Queue-Mode "host";' >> /etc/apt/apt.conf.d/99-parallel

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    texlive-xetex \
    texlive-latex-base \
    texlive-fonts-recommended \
    git \
    curl \
    ca-certificates \
    jq \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ARCH=$(uname -m) && \
    curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

RUN mkdir -p /home/nonroot /tmp/resume /tmp/output && \
    chown -R 65532:65532 /home/nonroot /tmp/resume /tmp/output

FROM dhi.io/debian-base:trixie

COPY --from=build /usr /usr
COPY --from=build /etc/texmf /etc/texmf
COPY --from=build /usr/local/aws-cli /usr/local/aws-cli
COPY --from=build /usr/local/bin/aws /usr/local/bin/aws
COPY --from=build --chown=65532:65532 /home/nonroot /home/nonroot
COPY --from=build --chown=65532:65532 /tmp/resume /tmp/resume
COPY --from=build --chown=65532:65532 /tmp/output /tmp/output
COPY --from=build /var/lib/texmf /var/lib/texmf

WORKDIR /home/nonroot

CMD ["/bin/bash"]
