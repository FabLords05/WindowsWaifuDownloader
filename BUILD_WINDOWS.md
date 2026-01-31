# Building a Windows EXE and Installer (Wizard)

This guide shows two typical approaches to ship your app as a Windows EXE and create an installer wizard.

Important: building Windows installers is best done on a Windows system (native or VM). Cross-building on Linux is possible (Wine, NSIS via Wine, etc.) but not always reliable.

## Option A — PyInstaller + Inno Setup (recommended)

1. Prepare a Windows build environment (Windows machine or VM). Install Python and the project requirements.
2. From project root create a virtualenv and install dependencies:
   - python -m venv venv
   - venv\Scripts\activate (Windows)
   - pip install -r requirements.txt
   - pip install pyinstaller
3. Copy or ensure you have an icon at `data/icons/app.ico` (or update path in `build/pyinstaller_build.sh`).
4. Run the build script on Windows (edit separators if necessary):
   - On Windows: `pyinstaller --onefile --noconfirm --windowed --name "WindowsWaifuDownloader" --add-data "..\data;data" --icon="..\data\icons\app.ico" src\gui_windows.py`
   - Or run `build/pyinstaller_build.sh` after adjusting line endings and environment.
5. Result: `dist/WindowsWaifuDownloader.exe`.
6. Install Inno Setup (https://jrsoftware.org/isinfo.php) and open `build/installer.iss`. Modify fields (AppName, AppVersion). Compile with Inno Setup (press Compile) to produce `WindowsWaifuInstaller.exe` (installer with wizard UI).

## Option B — pynsist (bundles a Python runtime + simpler installer)

- `pynsist` builds an installer that includes a private Python runtime, often simpler for apps that use Python (no need to compile to a single EXE). Read: https://pynsist.readthedocs.io/

## Automation / Notes
- `build/pyinstaller_build.sh` is a helper that tries to pick the right --add-data separator; still prefer running on Windows for correctness.
- `build/installer.iss` is an Inno Setup script for a standard installer wizard (shortcut creation, desktop icon option, post-install run checkbox).
- If you need a cross-build on Linux, you can try using Wine to run Inno Setup's ISCC.exe, and run PyInstaller under Wine as well. This is advanced and may need adjustments.

## Quick Checklist ✅
- [ ] Confirm entry point: `src/gui_windows.py` is the script you want packaged.
- [ ] Confirm resources are included (icons, data files).
- [ ] Build EXE with PyInstaller, test on Windows.
- [ ] Compile Inno Setup script to make the installer wizard.

If you'd like, I can:
- Add a `Makefile` or `build` scripts tuned to your project files, or
- Create a `pynsist` config example.

Tell me which path you prefer and whether you have access to a Windows build environment or want me to add more automation here. 
