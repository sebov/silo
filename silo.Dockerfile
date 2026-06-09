FROM ubuntu:26.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    build-essential curl ca-certificates fd-find fzf git git-lfs htop iputils-ping locales nano ncdu neovim ripgrep sudo tar tmux unzip wget zip zstd \
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

ENV PATH="/home/ubuntu/.local/share/mise/shims:/home/ubuntu/.local/bin:$PATH"

RUN uv python install 3.12 \
    && mise use node@22 pnpm usage --global \
    && echo 'source <(uv generate-shell-completion bash)' >> ~/.bashrc \
    && echo 'source <(uvx --generate-shell-completion bash)' >> ~/.bashrc \
    && echo 'source <(mise completion bash --include-bash-completion-lib)' >> ~/.bashrc \
    && echo 'source <(opencode completion)' >> ~/.bashrc

ENV PATH="/home/ubuntu/.local/share/pnpm/bin:$PATH"

RUN curl -fsSL https://raw.githubusercontent.com/openchamber/openchamber/main/scripts/install.sh | bash

CMD ["/bin/bash"]
