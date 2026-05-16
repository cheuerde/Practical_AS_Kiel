#!/usr/bin/env bash
set -euo pipefail

deck="${1:-lectures/r-intro.qmd}"
port="${PORT:-4200}"
host="${HOST:-127.0.0.1}"
html_path="${deck%.qmd}.html"

if [[ "${deck}" == "-h" || "${deck}" == "--help" ]]; then
  echo "Usage: scripts/preview-slides.sh [deck.qmd]"
  echo
  echo "Environment variables:"
  echo "  PORT=4200"
  echo "  HOST=127.0.0.1"
  exit 0
fi

if command -v quarto >/dev/null 2>&1; then
  quarto_bin="quarto"
elif [[ -x "$HOME/.local/bin/quarto" ]]; then
  quarto_bin="$HOME/.local/bin/quarto"
else
  echo "Quarto was not found. Install Quarto or place it at \$HOME/.local/bin/quarto." >&2
  exit 1
fi

echo "Starting slide preview for ${deck}"
echo "Open http://${host}:${port}/${html_path}"

"$quarto_bin" preview "$deck" --host "$host" --port "$port" --no-browser
