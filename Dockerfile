FROM docker/sandbox-templates:shell

# Install system deps as root
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
    && rm -rf /var/lib/apt/lists/*

# Switch to agent user for user-level installs
USER agent

# Clone and install little-coder into the agent's home
WORKDIR /home/agent
RUN git clone https://github.com/itayinbarr/little-coder.git /home/agent/little-coder

WORKDIR /home/agent/little-coder
RUN npm install && npm link

# Make sure ~/.local/bin is on PATH
ENV PATH="/home/agent/.local/bin:${PATH}"