@echo off
for /f %%i in ('wsl.exe wslpath "%1"') do set filepath=%%i
wsl.exe -- zsh -l -c 'source $ASDF_DIR/asdf.sh; nvim_open %filepath% %2 %3'
