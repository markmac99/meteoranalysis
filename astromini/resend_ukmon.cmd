@echo off
if "%1%"=="" goto usage
md c:\temp\xmljpg
move d:\meteorcam2\%1\%1%2\%1%2%3\*p.jpg c:\temp\xmljpg
move d:\meteorcam2\%1\%1%2\%1%2%3\*.xml c:\temp\xmljpg
move c:\temp\xmljpg\*.* d:\meteorcam2\%1\%1%2\%1%2%3
goto done
:usage
echo usage: refresh-live yyyy mm dd
:done
