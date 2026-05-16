FROM ubuntu:26.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    build-essential curl ca-certificates fd-find fzf git htop iputils-ping nano ncdu ripgrep sudo tar unzip wget zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

RUN mkdir -p /home/ubuntu/.local /home/ubuntu/.cache /home/ubuntu/workspace \
    && chown -R ubuntu:ubuntu /home/ubuntu/.local /home/ubuntu/.cache /home/ubuntu/workspace

USER ubuntu
WORKDIR /home/ubuntu/workspace

RUN curl -fsSL https://opencode.ai/install | bash
