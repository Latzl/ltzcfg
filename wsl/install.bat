@echo off

set fileName=.wslconfig
set fileDirSrc=%~dp0
set fileDirDst=%USERPROFILE%\

call ..\common\ltzlink %fileName% %fileDirSrc% %fileDirDst%