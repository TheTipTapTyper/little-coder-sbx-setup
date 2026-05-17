# Little Coder Inside Docker Sandbox

This repo is a setup that allows you to run the [little-coder](https://github.com/itayinbarr/little-coder) AI agent inside a [Docker Sandbox](https://docs.docker.com/ai/sandboxes/).

Little Coder is a Claude Code-inspired CLI coding agent that talks to a local LLM via an OpenAI-compatible API (e.g. `llama-server`). The sandbox gives it a clean, reproducible environment with all the tools it needs.

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/) installed and running
- [Docker Sandbox CLI](https://docs.docker.com/ai/sandboxes/) (`sbx`) installed
- A local LLM server running on port 8080 (e.g. [llama.cpp](https://github.com/ggerganov/llama.cpp) with `llama-server`)

## Quick Start

1. **Start your local LLM server** on the host, listening on port 8080:

   ```bash
   llama-server --model your-model.gguf --host 0.0.0.0 --port 8080
   ```

2. **Navigate to your project directory** (the code you want the agent to work on).

3. **Launch the sandbox** from this repo:

   ```bash
   ./sbx-little-coder.sh
   ```

   This creates a Docker Sandbox in the current directory using the custom little-coder kit. The agent starts automatically and connects to your local LLM.

## How It Works

```
┌──────────────────────────────────────────────────┐
│  Host Machine                                    │
│  ┌──────────────────┐                            │
│  │  llama-server    │  port 8080                 │
│  │  (local LLM)     │                            │
│  └────────┬─────────┘                            │
│           │                                      │
│  ┌────────▼──────────────────────────────────┐   │
│  │  Docker Sandbox                           │   │
│  │  ┌────────────────────────────────────┐   │   │
│  │  │  little-coder agent                │   │   │
│  │  │  (Python, git, npm, fd, curl)      │   │   │
│  │  └────────────────────────────────────    │   │
│  └───────────────────────────────────────────┘   │
└──────────────────────────────────────────────────┘
```

The sandbox is configured via `little-coder-kit/spec.yml`:

- **Network**: Access to `host.docker.internal:8080` (your LLM) and GitHub
- **Environment**: `LLAMACPP_BASE_URL` points to the local LLM
- **Entrypoint**: Runs `little-coder --model llamacpp/qwen3.6-35b-a3b`
- **Persistence**: State is preserved across sessions

## Project Structure

```
.
├── Dockerfile              # Builds the sandbox image
├── docker-build-push.sh    # Build & push the image to Docker Hub
├── sbx-little-coder.sh     # Launch a sandbox in the current directory
├── little-coder-kit/
│   └── spec.yml            # Sandbox kit configuration
└── README.md
```

## Updating the Sandbox Image

To update the Docker image (e.g. after changes to the `Dockerfile`):

```bash
./docker-build-push.sh
```

For an existing sandbox to pick up the new image, delete and recreate it:

```bash
sbx ls                    # list sandboxes
sbx rm <sandbox-name>     # remove the old one
./sbx-little-coder.sh     # create a new sandbox (pulls the updated image)
```

## Customizing

### Changing the LLM Model

Edit `little-coder-kit/spec.yml` and update the entrypoint:

```yaml
entrypoint:
  run: ["little-coder", "--model", "llamacpp/your-model-name"]
```

### Adding Tools

Edit the `Dockerfile` to install additional packages:

```dockerfile
RUN apt-get update && apt-get install -y \
    your-package \
    && rm -rf /var/lib/apt/lists/*
```

### Changing the LLM Port

If your LLM server runs on a different port, update both:

1. `little-coder-kit/spec.yml` → `network.allowedDomains`
2. `little-coder-kit/spec.yml` → `environment.variables.LLAMACPP_BASE_URL`
