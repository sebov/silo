FROM ubuntu:26.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    build-essential curl ca-certificates fd-find fzf git htop iputils-ping locales nano ncdu ripgrep sudo tar unzip wget zip zstd \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# btm
# nvitop
# zoxide
# eza
# yazi
# mise
# zellij

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

RUN mkdir -p /home/ubuntu/.local /home/ubuntu/.cache /home/ubuntu/workspace \
    && chown -R ubuntu:ubuntu /home/ubuntu/.local /home/ubuntu/.cache /home/ubuntu/workspace

USER ubuntu
WORKDIR /home/ubuntu/workspace

RUN curl https://mise.run | sh
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN curl -fsSL https://opencode.ai/install | bash

# additional setup for uv and mise
RUN $HOME/.local/bin/uv python install 3.12 \
    && $HOME/.local/bin/mise use node@24 usage --global \
    && echo 'source <(uv generate-shell-completion bash)' >> ~/.bashrc \
    && echo 'source <(uvx --generate-shell-completion bash)' >> ~/.bashrc \
    && echo 'source <(mise activate bash --shims)' >> ~/.bashrc \
    && echo 'source <(mise completion bash --include-bash-completion-lib)' >> ~/.bashrc

CMD ["/bin/bash"]
