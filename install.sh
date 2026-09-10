#!/usr/bin/env bash
# Link omarchy-finder into ~/.local/bin and add the Hyprland hotkey + window rule.
set -euo pipefail
here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
key="${FINDER_KEY:-SUPER + D}"
bindings="$HOME/.config/hypr/bindings.lua"

mkdir -p "$HOME/.local/bin"
ln -sfn "$here/bin/omarchy-finder" "$HOME/.local/bin/omarchy-finder"

if ! grep -q 'omarchy-finder' "$bindings" 2>/dev/null; then
  cat >> "$bindings" <<LUA

-- omarchy-finder: Spotlight-style file/email/web finder (https://github.com/woodcp/omarchy-finder)
o.window("^org\\\\.omarchy\\\\.finder\$", { tag = "+floating-window" })
o.bind("$key", "Finder", "omarchy-finder --launch")
LUA
  echo "Added binding $key to $bindings"
fi
hyprctl reload >/dev/null && hyprctl configerrors
echo "Installed. Press $key."
