#!/bin/zsh
# Rebuild prompt/stat-system-guide.pdf OUTSIDE pCloud, then copy it in and verify
# the copy actually stuck (pCloud has been silently serving a stale blob).
REPO="/Users/oliverliou/pCloud Drive/!-git/teach/stat"
cd "$REPO" || exit 1
export PATH="/usr/local/bin:/opt/homebrew/bin:/Library/Frameworks/R.framework/Resources/bin:$PATH"
command -v quarto  >/dev/null || PATH="$PATH:/Applications/RStudio.app/Contents/Resources/app/quarto/bin"
command -v Rscript >/dev/null || PATH="$PATH:/Applications/RStudio.app/Contents/Resources/app/bin"
if command -v pandoc >/dev/null; then
  export RSTUDIO_PANDOC="$(dirname "$(command -v pandoc)")"
else
  for d in /Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64 \
           /Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/x86_64 \
           /Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools; do
    [ -x "$d/pandoc" ] && export RSTUDIO_PANDOC="$d" && break
  done
fi

echo "=== BEFORE (file currently in the repo) ==="
md5 -q "$REPO/prompt/stat-system-guide.pdf" 2>/dev/null
strings "$REPO/prompt/stat-system-guide.pdf" 2>/dev/null | grep -m1 CreationDate

echo
echo "=== Building into /tmp (outside pCloud) ==="
rm -rf /tmp/statguide && mkdir -p /tmp/statguide
cp "$REPO/prompt/stat-system-guide.Rmd" /tmp/statguide/ || exit 1
echo "source Rmd mentions bib.bib: $(grep -c 'bib.bib' /tmp/statguide/stat-system-guide.Rmd) time(s)  [expected: 0]"
Rscript -e 'rmarkdown::render("/tmp/statguide/stat-system-guide.Rmd", output_dir="/tmp/statguide")' || { echo "!! build failed"; exit 1; }

echo
echo "=== FRESH BUILD (in /tmp) ==="
md5 -q /tmp/statguide/stat-system-guide.pdf
strings /tmp/statguide/stat-system-guide.pdf | grep -m1 CreationDate

echo
echo "=== Copying into the repo ==="
cp -f /tmp/statguide/stat-system-guide.pdf "$REPO/prompt/stat-system-guide.pdf"
sync; sleep 3
echo "=== AFTER (file in the repo) ==="
md5 -q "$REPO/prompt/stat-system-guide.pdf"
strings "$REPO/prompt/stat-system-guide.pdf" | grep -m1 CreationDate

echo
echo "=== git view ==="
git -C "$REPO" status --short prompt/stat-system-guide.pdf
echo "(if FRESH and AFTER md5 match, the copy stuck; report both lines back)"
