#!/bin/zsh
# Round-2: re-render the 28 chapter decks only (other outputs unchanged this round).
cd "/Users/oliverliou/pCloud Drive/!-git/teach/stat" || exit 1
export PATH="/usr/local/bin:/opt/homebrew/bin:/Library/Frameworks/R.framework/Resources/bin:$PATH"
command -v quarto >/dev/null || PATH="$PATH:/Applications/RStudio.app/Contents/Resources/app/quarto/bin"
{
  echo "=== chapter re-render started: $(date) ==="
  quarto render 'ch*/ch*.qmd' || echo "!! render reported errors"
  echo "=== finished: $(date) ==="
} 2>&1 | tee render-log.txt
