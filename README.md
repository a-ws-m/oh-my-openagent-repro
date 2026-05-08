# Oh My OpenAgent + OpenCode Repro Setup

This repository documents a reproducible OpenCode setup using:

- `oh-my-openagent` as the OpenCode plugin
- Ollama cloud models for Kimi, GLM, MiniMax, and Qwen Coder
- OpenAI/Codex models for GPT-native roles
- no free `opencode/*` model fallbacks

No credentials are stored in this repo.

## What This Repo Covers

This repo is documentation-only. It does not ship install scripts or config files yet, so the setup below is the source of truth for recreating the environment locally.

## Model Policy

The model map is intentionally Ollama-first for most work:

- Kimi via Ollama: orchestration and writing-heavy roles
- GLM via Ollama: planning, review fallback, deep/general categories
- MiniMax via Ollama: fast utility/search/doc roles
- OpenAI/Codex: GPT-native and high-reasoning roles such as `hephaestus`, `oracle`, `momus`, and `ultrabrain`

## Prerequisites

Install these before wiring up config:

```bash
# OpenCode
curl -fsSL https://opencode.ai/install | bash

# Ollama
curl -fsSL https://ollama.com/install.sh | sh

# GitHub automation support
sudo apt update
sudo apt install -y gh
```

If you do not use Ubuntu/Debian, install `gh` through your platform's package manager.

## Install `comment-checker`

The hook dependency for `oh-my-openagent` publishes a CLI binary named `comment-checker`.

Use `pnpm` for the global install:

```bash
pnpm i -g @code-yeongyu/comment-checker
comment-checker --help
```

If the binary does not appear after install, rebuild it in place:

```bash
pnpm rebuild -g @code-yeongyu/comment-checker
```

`npm install -g` may fail on systems where the global prefix is not user-writable. If you prefer `npm`, configure a user-owned global prefix first or run the install with elevated privileges.

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

## Configure OpenCode

Create or update your OpenCode config so it points at:

- the `oh-my-openagent` plugin
- the Ollama models you want routed to Kimi, GLM, MiniMax, and Qwen
- the OpenAI models you want routed to GPT-native roles

The important part for this reproduction is the routing policy:

- do not depend on free `opencode/*` fallback models
- keep OpenAI/Codex reserved for high-reasoning or GPT-native roles
- keep Ollama as the default provider for the agent roles listed above

If you already have local config files from another machine, copy them into:

- `~/.config/opencode/opencode.json`
- `~/.config/opencode/oh-my-openagent.json`
- `~/.ollama/config.json`

## Verify the Setup

Check that the provider auth and model wiring are visible to OpenCode:

```bash
opencode auth list
opencode models
comment-checker --help
gh auth status
```

Expected:

- OpenCode sees both Ollama and OpenAI/Codex providers
- `comment-checker` runs successfully
- GitHub CLI is authenticated if you plan to use GitHub automation

## Smoke Tests

Use these to confirm provider routing:

```bash
opencode run -m ollama/kimi-k2.6:cloud 'Reply with exactly: ok'
opencode run -m ollama/glm-5.1:cloud 'Reply with exactly: ok'
opencode run -m ollama/minimax-m2.7:cloud 'Reply with exactly: ok'
opencode run -m openai/gpt-5.5 'Reply with exactly: ok'
```

If a model name differs in your local OpenCode model list, keep the provider mapping the same and adjust the exact model identifier to match what `opencode models` reports.

## Launch

Start OpenCode normally:

```bash
opencode
```

Once `oh-my-openagent` is enabled in your OpenCode config, it loads when OpenCode starts.

Use `ultrawork` or `ulw` in a prompt to trigger oh-my-openagent orchestration behavior.

## Troubleshooting

- If `npm install -g @code-yeongyu/comment-checker` fails with `EACCES`, use `pnpm i -g @code-yeongyu/comment-checker` or fix your npm global prefix.
- If `comment-checker` is installed but missing its binary, run `pnpm rebuild -g @code-yeongyu/comment-checker`.
- If `gh auth status` fails, run `gh auth login`.
- If `oh-my-openagent doctor` reports missing model support, re-check the provider auth and the model names reported by `opencode models`.

## Notes

- This setup assumes subscriptions/access for Ollama cloud and OpenAI/Codex.
- This setup deliberately avoids free `opencode/*` model fallbacks.
- Qwen Coder is registered with OpenCode for manual use, but not assigned to oh-my-openagent agents because `oh-my-openagent doctor` previously flagged it as an unknown compatibility fallback.
