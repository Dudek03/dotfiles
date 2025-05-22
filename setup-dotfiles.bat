@echo off
SETLOCAL

echo Tworzenie symlinków do dotfiles

:: Ścieżka do repo dotfiles (dostosuj, jeśli potrzebujesz)
set "DOTFILES=G:\GitHub\dotfiles"

:: Neovim
set "NVIM_TARGET=%LOCALAPPDATA%\nvim"
if exist "%NVIM_TARGET%" (
    echo Usuwanie istniejącego folderu Neovim...
    rmdir /s /q "%NVIM_TARGET%"
)
echo Tworzenie symlinka dla Neovim...
mklink /D "%NVIM_TARGET%" "%DOTFILES%\nvim"

:: VSCode keybindings.json
set "VSCODE_TARGET=%APPDATA%\Code\User\keybindings.json"
if exist "%VSCODE_TARGET%" (
    echo Usuwanie istniejącego keybindings.json...
    del "%VSCODE_TARGET%"
)
echo Tworzenie symlinka dla VSCode keybindings.json...
mklink "%VSCODE_TARGET%" "%DOTFILES%\vsCode\keybindings.json"

echo Gotowe!
pause
