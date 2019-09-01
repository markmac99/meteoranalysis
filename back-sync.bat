@echo off
if "%1"=="" goto dontdoit
robocopy /MIR /fft /dst /xn /Z /W:1 /R:1 C:\Users\Mark\Videos\Astro\MeteorCam\2019\%1 \\thelinux\meteorcam\2019\%1
goto done
:dontdoit
echo Usage back-sync.bat yearmonth eg back-sync 201807
:done

