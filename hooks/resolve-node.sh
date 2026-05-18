#!/usr/bin/env bash
# Sourced by hook scripts to put node on PATH when the hook subprocess
# doesn't inherit an interactive shell environment.

if command -v node &>/dev/null; then
  return 0
fi

_add_node_bin() {
  [[ -x "$1" ]] && export PATH="$(dirname "$1"):$PATH" && return 0
  return 1
}

# volta
if [[ -n "${VOLTA_HOME:-}" ]] && _add_node_bin "$VOLTA_HOME/bin/node"; then
  return 0
fi
if _add_node_bin "$HOME/.volta/bin/node"; then
  return 0
fi

# nvm
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh" --no-use 2>/dev/null
  command -v node &>/dev/null && return 0
fi

# fnm — pick highest installed version
for _fnm_root in "$HOME/.local/share/fnm" "$HOME/Library/Application Support/fnm"; do
  if [[ -d "$_fnm_root/node-versions" ]]; then
    _node=$(find "$_fnm_root/node-versions" -name node -path "*/bin/node" 2>/dev/null | sort -V | tail -1)
    _add_node_bin "$_node" && return 0
  fi
done

# asdf
if _add_node_bin "$HOME/.asdf/shims/node"; then
  return 0
fi

# n (default prefix)
if _add_node_bin "/usr/local/bin/node"; then
  return 0
fi

# Homebrew (Apple Silicon and Intel)
for _brew_node in "/opt/homebrew/bin/node" "/usr/local/opt/node/bin/node"; do
  _add_node_bin "$_brew_node" && return 0
done

# System fallback
_add_node_bin "/usr/bin/node"
