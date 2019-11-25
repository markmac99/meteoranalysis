@echo off
rem create colorgramme style image
set condaroot=c:\users\mark\anaconda3
call %condaroot%\scripts\activate.bat
python %cd%\colorgram.py
