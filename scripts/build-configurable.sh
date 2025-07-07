#!/bin/bash

# Exit immediately if any command fails
set -e

# Print the current R version (useful for logging and debugging)
echo "📦 R version:"
Rscript -e 'R.version.string'

# Function to link the correct Bookdown YAML config file
# Arguments:
#   $1 - The config filename to use (e.g., _bookdown-viz.yml)
link_bookdown_config() {
  local config="$1"
  echo "🔧 Using config: $config"

  # Create or update a symbolic link named _bookdown.yml pointing to the desired config
  cp -f "$config" _bookdown.yml
}

# -------------------------------
# VIZ GitBook
# -------------------------------
if [[ "$1" == "viz-gitbook" ]]; then
  echo "📘 Building Visualization GitBook..."
  cp -f index-viz-gitbook.Rmd index.Rmd
  link_bookdown_config _bookdown-viz.yml
  mkdir -p viz-gitbook
  Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::gitbook", output_dir = "docs")'
  rm index.Rmd
  echo "✅ Visualization GitBook complete → /docs"

# -------------------------------
# Visualization PDF
# -------------------------------
elif [[ "$1" == "viz-pdf" ]]; then
  echo "📘 Building Visualization PDF..."
  cp -f index-viz-pdf.Rmd index.Rmd
  link_bookdown_config _bookdown-viz.yml
  mkdir -p viz-pdf
  Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::pdf_book", output_dir = "viz-pdf")'
  rm index.Rmd
  echo "✅ Visualization PDF complete → /viz-pdf"

# -------------------------------
# Help / fallback
# -------------------------------
else
  echo "❌ Unknown build option: $1"
  echo "Usage: $0 {viz-gitbook|viz-pdf}"
  exit 1
fi
