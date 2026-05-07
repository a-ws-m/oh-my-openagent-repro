#!/usr/bin/env bash
set -euo pipefail

required_commands=(node npm npx opencode ollama comment-checker)
missing=()

for cmd in "${required_commands[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if ((${#missing[@]})); then
  echo "Missing commands: ${missing[*]}" >&2
  exit 1
fi

node -e '
const fs = require("fs");
const home = process.env.HOME;
for (const file of [
  `${process.env.XDG_CONFIG_HOME || `${home}/.config`}/opencode/opencode.json`,
  `${process.env.XDG_CONFIG_HOME || `${home}/.config`}/opencode/oh-my-openagent.json`,
  `${home}/.ollama/config.json`,
]) {
  JSON.parse(fs.readFileSync(file, "utf8"));
  console.log(`JSON ok: ${file}`);
}
'

echo
echo "OpenCode credentials:"
opencode auth list || true

echo
echo "Configured model availability:"
models="$(opencode models 2>/dev/null || true)"
for model in \
  ollama/kimi-k2.6:cloud \
  ollama/glm-5.1:cloud \
  ollama/minimax-m2.7:cloud \
  ollama/minimax-m2.5:cloud \
  openai/gpt-5.5 \
  openai/gpt-5.3-codex \
  openai/gpt-5.4-mini-fast
do
  if grep -Fxq "$model" <<<"$models"; then
    echo "ok  $model"
  else
    echo "MISS $model"
  fi
done

echo
OMO_SEND_ANONYMOUS_TELEMETRY=0 npx oh-my-openagent doctor

