@REM @echo off
@REM brief: Make symbolic link of file, it will create a dst file link to src: dst -> src. If dst exist, backup it first.
@REM usage: right click and select "Run as administrator"

:ltzlink
set fileName=%1%
set fileDirSrc=%2%
set fileDirDst=%3%

set filePathSrc=%fileDirSrc%%fileName%
set filePathDst=%fileDirDst%%fileName%
set filePathDstBak=%filePathDst%.bak

if not exist %filePathSrc% (
    echo file [%filePathSrc%] not exist, exit
    pause
    goto :eof
)

if exist %filePathDst% (
    echo file [%filePathDst%] exist, backup to [%filePathDstBak%]
    if exist %filePathDstBak% (
        echo file [%filePathDstBak%] exist, delete it
        del /F %filePathDstBak%
    )
    move /Y %filePathDst% %filePathDstBak%
)

echo start to create symbolic link: %filePathDst% -^> %filePathSrc%

mklink %filePathDst% %filePathSrc%

pause
goto :eof