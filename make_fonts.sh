#!/usr/bin/env bash
# 在本機跑一次：下載源雲明體 → 收集課程網頁所有字元 → 子集化成 woff2
# 需求:python3。用法: bash make_fonts.sh
set -euo pipefail
cd "$(dirname "$0")"

VER=v2.100
ZIP=GenWanMin2TW-otf.zip
URL=https://github.com/ButTaiwan/genwan-font/releases/download/$VER/$ZIP

mkdir -p fonts .fonts-tmp
cd .fonts-tmp

# 1. 下載完整字型（SIL OFL 1.1 開源授權）
if [ ! -f "$ZIP" ]; then
  echo "Downloading GenWanMin ($VER)..."
  curl -L -o "$ZIP" "$URL"
fi
unzip -o -q "$ZIP"

# 2. 安裝 fonttools
python3 -m pip install --quiet --user fonttools brotli 2>/dev/null || \
python3 -m pip install --quiet --break-system-packages fonttools brotli

# 3. 收集所有 .qmd 與已渲染 .html 的字元
python3 - <<'EOF'
import pathlib
chars = set()
root = pathlib.Path('..')
for pat in ('*.qmd', '*.html', 'sylla/*.qmd', 'stat1-ps/*.qmd', 'stat2-ps/*.qmd'):
    for f in root.glob(pat):
        try:
            chars.update(f.read_text(encoding='utf-8', errors='ignore'))
        except Exception:
            pass
# 基本 ASCII + 常用標點保底
chars.update(chr(c) for c in range(0x20, 0x7F))
chars.update('，。、；：「」『』（）！？─…·—〈〉《》％')
text = ''.join(sorted(c for c in chars if ord(c) >= 0x20))
pathlib.Path('charset.txt').write_text(text, encoding='utf-8')
print(f'collected {len(text)} unique chars')
EOF

# 4. 子集化三個字重 → ../fonts/
for w in R M SB; do
  src=$(ls GenWanMin2TW-${w}.otf 2>/dev/null || ls */GenWanMin2TW-${w}.otf | head -1)
  python3 -m fontTools.subset "$src" \
    --text-file=charset.txt \
    --flavor=woff2 \
    --layout-features='*' \
    --output-file="../fonts/GenWanMin2TW-${w}-sub.woff2"
  echo "fonts/GenWanMin2TW-${w}-sub.woff2 done"
done

echo "完成。之後若新增頁面有新字，重跑本腳本即可。"
