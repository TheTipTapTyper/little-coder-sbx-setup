FROM docker/sandbox-templates:shell

USER root
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    build-essential \
    fd-find \
    && ln -s $(which fdfind) /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --break-system-packages tree-sitter-language-pack

# Install Node 22 via NodeSource (cleaner than nvm in Docker)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Clone and install little-coder from source (latest main)
# passing in a unique CACHEBUST value invalidates docker's cache for this and subsequent layers
WORKDIR /home/agent
ARG CACHEBUST=1
RUN git clone --depth 1 https://github.com/itayinbarr/little-coder.git /home/agent/little-coder

WORKDIR /home/agent/little-coder

# npm link needs root to write to /usr/local/bin
RUN npm install && npm link