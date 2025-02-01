@echo off

set fileName=settings.json
set fileDirSrc=%~dp0
set fileDirDst=%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

call ..\common\ltzlink %fileName% %fileDirSrc% %fileDirDst%