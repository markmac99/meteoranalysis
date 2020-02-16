#include <Constants.au3>

;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Mark McIntyre
;
; Script Function:
;   Opens SDRSharp, clicks Start button
;

; Run app
Run("C:\Program Files (x86)\SDRSharp\SDRSharp.exe")

; Wait for app to become active.
WinWaitActive("SDR#")
Sleep(30000)
ControlClick("SDR#","","[NAME:playStopButton]","left",1)

; Finished!
