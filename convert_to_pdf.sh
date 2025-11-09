#!/bin/bash

# Convert All Markdown Files to PDF
# Usage: ./convert_to_pdf.sh

set -e

echo "🔄 Starting Markdown to PDF conversion..."
echo ""

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "❌ Error: pandoc is not installed"
    echo ""
    echo "Install pandoc:"
    echo "  macOS:   brew install pandoc basictex"
    echo "  Ubuntu:  sudo apt install pandoc texlive-latex-base texlive-fonts-recommended"
    echo "  Windows: Download from https://pandoc.org/installing.html"
    echo ""
    exit 1
fi

# Create output directory
OUTPUT_DIR="pdf_output"
mkdir -p "$OUTPUT_DIR"

echo "📁 Output directory: $OUTPUT_DIR"
echo ""

# Counter
count=0

# Function to convert a single file
convert_file() {
    local input_file="$1"
    local relative_path="${input_file#./}"
    local output_file="$OUTPUT_DIR/${relative_path%.md}.pdf"
    local output_dir=$(dirname "$output_file")

    # Create subdirectory structure
    mkdir -p "$output_dir"

    echo "  Converting: $relative_path"

    # Convert with nice formatting
    pandoc "$input_file" \
        --toc \
        --toc-depth=3 \
        --pdf-engine=xelatex \
        -V geometry:margin=1in \
        -V fontsize=11pt \
        -V documentclass=article \
        --highlight-style=tango \
        -o "$output_file" \
        2>/dev/null

    if [ $? -eq 0 ]; then
        echo "    ✅ Success: $output_file"
        ((count++))
    else
        echo "    ❌ Failed: $relative_path"
    fi
    echo ""
}

# Find and convert all markdown files
echo "🔍 Finding markdown files..."
echo ""

while IFS= read -r -d '' file; do
    convert_file "$file"
done < <(find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" -print0)

# Summary
echo "=================================="
echo "✅ Conversion Complete!"
echo "=================================="
echo ""
echo "📊 Statistics:"
echo "  Total files converted: $count"
echo "  Output directory: $OUTPUT_DIR/"
echo ""
echo "📖 Open PDFs with:"
echo "  open $OUTPUT_DIR/README.pdf"
echo "  or browse: $OUTPUT_DIR/"
echo ""

# Create an index file
cat > "$OUTPUT_DIR/INDEX.txt" << EOF
PDF Conversion Index
Generated: $(date)
Total Files: $count

Files converted:
EOF

find "$OUTPUT_DIR" -name "*.pdf" | sort >> "$OUTPUT_DIR/INDEX.txt"

echo "📄 Index file created: $OUTPUT_DIR/INDEX.txt"
echo ""
echo "🎉 All done! Happy reading!"
