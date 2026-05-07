#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"

opencode_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
ollama_dir="$HOME/.ollama"

mkdir -p "$opencode_dir" "$ollama_dir"

backup_if_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    cp "$path" "$path.bak.$stamp"
    echo "Backed up $path -> $path.bak.$stamp"
  fi
}

backup_if_exists "$opencode_dir/opencode.json"
backup_if_exists "$opencode_dir/oh-my-openagent.json"
backup_if_exists "$ollama_dir/config.json"

cp "$repo_dir/configs/opencode.json" "$opencode_dir/opencode.json"
cp "$repo_dir/configs/oh-my-openagent.json" "$opencode_dir/oh-my-openagent.json"
cp "$repo_dir/configs/ollama-config.json" "$ollama_dir/config.json"

echo "Installed OpenCode, oh-my-openagent, and Ollama config templates."
echo "Next: authenticate with Ollama and OpenAI, then run scripts/verify.sh"

