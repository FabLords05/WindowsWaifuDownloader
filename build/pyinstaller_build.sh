#!/usr/bin/env bash
set -euo pipefail

# Build a Windows executable using PyInstaller.
# Recommended: run this on a Windows machine (or in a Windows VM). Cross-building on Linux is possible using Wine
# but not guaranteed. See BUILD_WINDOWS.md for details and alternatives.

APP_NAME="WindowsWaifuDownloader"
SRC_PATH="../src/gui_windows.py"
ICON_PATH="../data/icons/app.ico"  # update if your icon has a different name or path
OUTPUT_DIR="../dist"

echo "Creating output dir ${OUTPUT_DIR}..."
mkdir -p "${OUTPUT_DIR}"

# PyInstaller data separator differs by OS. If running on Windows, use ';' as separator in --add-data.
# On Linux/macOS, use ':'; but the produced executable should be built on Windows for best compatibility.

# Example (run on Windows):
# pyinstaller --onefile --noconfirm --windowed --name "%APP_NAME%" --add-data "..\data;data" --icon="%ICON_PATH%" "%SRC_PATH%"

# Example (run on Unix-like):
# pyinstaller --onefile --noconfirm --windowed --name "${APP_NAME}" --add-data "../data:./data" --icon="${ICON_PATH}" "${SRC_PATH}"

# This script attempts to guess proper --add-data separator for you.
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
  ADDDATA="..\\data;data"
else
  ADDDATA="../data:./data"
fi

echo "Running PyInstaller..."
pyinstaller --onefile --noconfirm --windowed --name "${APP_NAME}" --add-data "${ADDDATA}" --icon="${ICON_PATH}" "${SRC_PATH}"

echo "Move produced exe to ${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"
if [[ -f "dist/${APP_NAME}.exe" ]]; then
  mv "dist/${APP_NAME}.exe" "${OUTPUT_DIR}/"
  echo "Success: ${OUTPUT_DIR}/${APP_NAME}.exe"
else
  echo "Warning: dist/${APP_NAME}.exe not found. Check PyInstaller output for errors." >&2
  exit 1
fi
