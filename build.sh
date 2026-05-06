#!/bin/zsh

# Script tự động build LaTeX (tương đương TeXstudio build)
# Chạy: chmod +x build.sh && ./build.sh

MAIN="main"
DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DIR"

echo "==== Bắt đầu build: $MAIN.tex ===="

# Lần 1: pdflatex
echo "[1/3] pdflatex lần 1..."
pdflatex -interaction=nonstopmode -synctex=1 "$MAIN.tex"

# Lần 2: pdflatex (để cập nhật references, TOC)
echo "[2/3] pdflatex lần 2..."
pdflatex -interaction=nonstopmode -synctex=1 "$MAIN.tex"

# Lần 3: pdflatex (để ổn định cross-references)
echo "[3/3] pdflatex lần 3..."
pdflatex -interaction=nonstopmode -synctex=1 "$MAIN.tex"

# Kiểm tra PDF có được tạo ra không
if [ -f "$MAIN.pdf" ]; then
  echo ""
  # Kiểm tra có lỗi nghiêm trọng không (không tạo được output)
  ERRORS=$(grep -c "^!" "$MAIN.log" 2>/dev/null || echo 0)
  if [ "$ERRORS" -gt 0 ]; then
    echo "⚠️  Build xong nhưng có $ERRORS lỗi LaTeX. Kiểm tra: $MAIN.log"
  else
    echo "✅ Build thành công!"
  fi
  echo "📄 File output: $DIR/$MAIN.pdf"
  open "$MAIN.pdf"
else
  echo "❌ Build thất bại - không tạo được PDF. Xem log: $MAIN.log"
  exit 1
fi
