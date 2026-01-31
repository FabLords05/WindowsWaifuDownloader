#!/usr/bin/env bash
set -euo pipefail

# Build a Windows executable using PyInstaller.
# Run this from the project root: ./build/pyinstaller_build.sh

APP_NAME="WaifuDownloader"
SRC_PATH="src/gui_windows.py"
ICON_PNG="data/icons/moe.nyarchlinux.waifudownloader.png"
ICON_ICO="data/icons/moe.nyarchlinux.waifudownloader.ico"
OUTPUT_DIR="dist"

echo "Creating output dir ${OUTPUT_DIR}..."
mkdir -p "${OUTPUT_DIR}"

# Prepare icon: prefer an .ico if present; if only a PNG exists, try to convert it to .ico using Pillow.
ICON_PATH=""
if [[ -f "${ICON_ICO}" ]]; then
  ICON_PATH="${ICON_ICO}"
elif [[ -f "${ICON_PNG}" ]]; then
  echo "Found PNG icon at ${ICON_PNG}. Attempting to convert to .ico (requires Pillow)..."
  if python -c "import PIL" >/dev/null 2>&1; then
    python - <<'PY'
from PIL import Image
png = "data/icons/moe.nyarchlinux.waifudownloader.png"
ico = "data/icons/moe.nyarchlinux.waifudownloader.ico"
img = Image.open(png)
# Save a 256x256 ICO which works well for installers and shortcuts
img.save(ico, format='ICO', sizes=[(256,256)])
print('OK')
PY
    if [[ -f "${ICON_ICO}" ]]; then
      ICON_PATH="${ICON_ICO}"
      echo "Converted PNG to ICO: ${ICON_ICO}"
    else
      echo "Warning: PNG conversion did not produce an ICO file; proceeding without custom icon." >&2
    fi
  else
    echo "Pillow is not installed. Install it with: pip install pillow" >&2
    echo "Continuing without custom icon." >&2
  fi
else
  echo "No icon found at ${ICON_PNG} or ${ICON_ICO}; continuing without custom icon."
fi

# Build without bundling the whole data directory (not needed per project requirements). Output goes to project root dist/.
echo "Running PyInstaller..."
PYI_CMD=(pyinstaller --onefile --noconfirm --windowed --name "${APP_NAME}" --distpath "${OUTPUT_DIR}")
if [[ -n "${ICON_PATH}" ]]; then
  PYI_CMD+=(--icon "${ICON_PATH}")
fi
PYI_CMD+=("${SRC_PATH}")

echo "Command: ${PYI_CMD[@]}"
"${PYI_CMD[@]}"

if [[ -f "${OUTPUT_DIR}/${APP_NAME}.exe" ]]; then
  echo "Success: ${OUTPUT_DIR}/${APP_NAME}.exe"
else
  echo "Warning: ${OUTPUT_DIR}/${APP_NAME}.exe not found. Check PyInstaller output for errors." >&2
  exit 1
fi
