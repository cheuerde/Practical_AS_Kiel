#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SITE_DIR="${SITE_DIR:-_site}"
PDF_DIR="${PDF_DIR:-$SITE_DIR/pdfs}"

labs=(
  "labs/r-intro.qmd"
  "labs/optimization.qmd"
  "labs/maximum-likelihood.qmd"
  "labs/linear-regression.qmd"
  "labs/bayesian-inference.qmd"
  "labs/genomic-prediction.qmd"
  "labs/clustering.qmd"
  "labs/multivariate-clustering.qmd"
)

lectures=(
  "lectures/r-intro.qmd"
  "lectures/optimization.qmd"
  "lectures/maximum-likelihood.qmd"
  "lectures/linear-regression.qmd"
  "lectures/bayesian-inference.qmd"
  "lectures/genomic-prediction.qmd"
  "lectures/clustering.qmd"
  "lectures/multivariate-clustering.qmd"
)

find_chrome() {
  if [[ -n "${CHROME:-}" && -x "${CHROME:-}" ]]; then
    printf '%s\n' "$CHROME"
    return 0
  fi

  for command_name in google-chrome-stable google-chrome chrome chromium chromium-browser; do
    if command -v "$command_name" >/dev/null 2>&1; then
      command -v "$command_name"
      return 0
    fi
  done

  for app_path in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium"; do
    if [[ -x "$app_path" ]]; then
      printf '%s\n' "$app_path"
      return 0
    fi
  done

  return 1
}

rm -rf "$PDF_DIR"
mkdir -p "$PDF_DIR/labs" "$PDF_DIR/lectures"

echo "Rendering lab PDFs with Typst..."
for lab in "${labs[@]}"; do
  quarto render "$lab" --to typst --output-dir "$PDF_DIR"
done

find "$PDF_DIR" -mindepth 1 -maxdepth 1 \
  ! -name labs \
  ! -name lectures \
  -exec rm -rf {} +

chrome="$(find_chrome || true)"

if [[ -z "$chrome" ]]; then
  echo "Chrome or Chromium is required to export RevealJS slides to PDF." >&2
  echo "Set CHROME=/path/to/chrome or install Google Chrome/Chromium." >&2
  exit 1
fi

chrome_log="$(mktemp "${TMPDIR:-/tmp}/practical-kiel-chrome-log.XXXXXX")"
cleanup() {
  rm -f "$chrome_log"
}
trap cleanup EXIT

echo "Printing lecture PDFs with headless Chrome..."
for lecture in "${lectures[@]}"; do
  base_name="$(basename "$lecture" .qmd)"
  html_path="$SITE_DIR/lectures/${base_name}.html"
  pdf_path="$PDF_DIR/lectures/${base_name}.pdf"

  if [[ ! -f "$html_path" ]]; then
    quarto render "$lecture" --to revealjs --output-dir "$SITE_DIR"
  fi

  html_abs="$(cd "$(dirname "$html_path")" && pwd)/$(basename "$html_path")"

  : > "$chrome_log"

  if ! "$chrome" \
    --headless \
    --disable-gpu \
    --no-sandbox \
    --no-pdf-header-footer \
    --allow-file-access-from-files \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf="$pdf_path" \
    "file://${html_abs}?print-pdf" \
    >/dev/null 2>"$chrome_log"; then
    cat "$chrome_log" >&2
    exit 1
  fi

  echo "Wrote $pdf_path"
done

if command -v zip >/dev/null 2>&1; then
  echo "Creating PDF bundles..."
  (
    cd "$PDF_DIR"
    zip -qr advanced-statistics-lab-notes.zip labs
    zip -qr advanced-statistics-lab-slides.zip lectures
    zip -qr advanced-statistics-lab-pdfs.zip labs lectures
  )
fi

echo "PDF exports written to $PDF_DIR"
