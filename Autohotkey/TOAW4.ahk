#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#UseHook On ; Keyboard hook
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#If WinActive("ahk_class The Operational Art of War") and WinActive("ahk_exe Opart 4.exe")

; Suspend: Pause
Pause::Suspend

;WASD keys
w::Up
a::Left
s::Down
d::Right

; Other remappings
+w:: ; Shift+W - Weather Report
  Send w
  Return
+a:: ;Shift+A - Air Unit Report
  Send a
  Return
^a:: ;Ctrl+A - Air Briefing
  Send +a
  Return
+d:: ;Shift+D - Dig In
  Send d
  Return
^d:: ;Ctrl+D - Stack Dig In
  Send {Shift}D
  Return
x:: ;X - Center map on unit
  Send {NumPad5}
  Return
q:: ;Q - Unit Report
  Send u
  Return
+t:: ;Shift+T - Loss Tolerance
  Send l
  Return
^t:: ;Ctrl+T - Stack Loss Tolerance
  Send {Shift}L
  Return
o:: ;Ctrl+O - Theater Options
  Send {Shift}T
  Return
u:: ;U - OOB Units
  Send o
  Return
Tab:: ;Tab - Next Unit
  Send {+}
  Return
+Tab:: ;Shift+Tab - Previous unit
  Send {-}
  Return
^e:: ;Ctrl+E - End Turn
  Send e
  Return
Space:: ;Space - Plan Attack
  Send p
  Return
v:: ;V - Toggle view units, hold down needs check for Space
  Send {Space down}
  KeyWait, v
  Send {Space up}
  Return
e:: ;E - Enter
  Send {Enter}
  Return
~b:: ; Find Place override
  Suspend, On
  input,_,v,{esc}{enter}
  Suspend, Off
  Return
r:: ;Right Click
  Click, right
  Return
+r:: ;Shift+R; Refresh current unit
  Send r
  Return
^s:: ;Ctrl+S; Save game
  Send !f,+a
  Return
F4:: ; ScrollLock override
  Send {ScrollLock}
  Return
F5:: ; Quick Save
  Send {F9}
  Return

#IfWinActive
