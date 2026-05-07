# Oh My OpenAgent + OpenCode Repro Setup

This repo captures a reproducible OpenCode setup using:

- `oh-my-openagent` as the OpenCode plugin
- Ollama cloud models for Kimi, GLM, MiniMax, and Qwen Coder
- OpenAI/Codex models for GPT-native roles
- no free `opencode/*` model fallbacks

No credentials are stored in this repo.

## Model Policy

The model map is intentionally Ollama-first for most work:

- Kimi via Ollama: orchestration and writing-heavy roles
- GLM via Ollama: planning, review fallback, deep/general categories
- MiniMax via Ollama: fast utility/search/doc roles
- OpenAI/Codex: GPT-native and high-reasoning roles such as `hephaestus`, `oracle`, `momus`, and `ultrabrain`

## Prerequisites

Install these before copying configs:

```bash
# OpenCode
curl -fsSL https://opencode.ai/install | bash

# Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Optional oh-my-openagent hook dependency
npm install -g @code-yeongyu/comment-checker
npm rebuild -g @code-yeongyu/comment-checker

# GitHub automation support
sudo apt update
sudo apt install -y gh
```

If you do not use Ubuntu/Debian, install `gh` through your platform's package manager.

## Authenticate Providers

Authenticate Ollama cloud:

```bash
ollama signin
```

Authenticate OpenAI/Codex inside OpenCode:

```bash
opencode auth login
```

Choose the OpenAI provider and complete OAuth. Confirm with:

```bash
opencode auth list
opencode models | grep -E 'openai|ollama'
```

Authenticate GitHub CLI if you want GitHub automation:

```bash
gh auth login
```

## Install Configs

From this repo:

```bash
./scripts/install-configs.sh
```

The script writes:

- `~/.config/opencode/opencode.json`
- `~/.config/opencode/oh-my-openagent.json`
- `~/.ollama/config.json`

Existing files are backed up with a timestamp suffix before replacement.

## Verify

Run:

```bash
./scripts/verify.sh
```

Expected:

- JSON files parse cleanly
- `opencode models` contains the configured Ollama and OpenAI models
- `npx oh-my-openagent doctor` has no model warnings

If doctor reports `GitHub CLI not authenticated`, run:

```bash
gh auth login
```

## Smoke Tests

Use these to confirm provider routing:

```bash
opencode run -m ollama/kimi-k2.6:cloud 'Reply with exactly: ok'
opencode run -m ollama/glm-5.1:cloud 'Reply with exactly: ok'
opencode run -m ollama/minimax-m2.7:cloud 'Reply with exactly: ok'
opencode run -m openai/gpt-5.5 'Reply with exactly: ok'
```

## Launch

Start OpenCode normally:

```bash
opencode
```

Because `oh-my-openagent@latest` is listed in `opencode.json`, it loads when OpenCode starts.

Use `ultrawork` or `ulw` in a prompt to trigger oh-my-openagent orchestration behavior.

## Notes

- This setup assumes subscriptions/access for Ollama cloud and OpenAI/Codex.
- This setup deliberately avoids free `opencode/*` model fallbacks.
- Qwen Coder is registered with OpenCode for manual use, but not assigned to oh-my-openagent agents because `oh-my-openagent doctor` previously flagged it as an unknown compatibility fallback.

