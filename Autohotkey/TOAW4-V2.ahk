; AutoHotkey v2 script for TOAW4
#Warn ; Enable warnings to assist with detecting common errors.
#UseHook true ; Keyboard hook
#SingleInstance force ; Force single running instance
SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.

; Main
#HotIf WinActive("ahk_class The Operational Art of War")
and WinActive("ahk_exe Opart 4.exe")

; Pause - Suspend
Pause::Suspend()

; WASD keys
w::Up
a::Left
s::Down
d::Right

; Hotkey remapping
Tab::Send("{+}") ; Tab - Next unit
+Tab::Send("{-}") ; Shift+Tab - Previous unit
Space::Send("p") ; Space - Plan attack
F4::Send("{ScrollLock}") ; F4 - Scroll Lock
F5::Send("{F9}") ; Quick save
q::Send("u") ; Q - Unit report
+w::Send("w") ; Shift+W - Weather report
+a::Send("a") ; Shift+A - Air unit report
^a::Send("+a") ; Ctrl+A - Air briefing
+t::Send("l") ; Shift+T - Loss tolerance
^t::Send("{Shift}L") ; Ctrl+T - Stack loss tolerance
+d::Send("d") ; Shift+D - Dig in
^d::Send("{Shift}D") ; Ctrl+D - Stack dig in
x::Send("{NumPad5}") ; X - Center map on unit
o::Send("{Shift}T") ; Ctrl+O - Theater options
u::Send("o") ; U - OOB Units
e::Send("{Enter}") ; E - Enter
^e::Send("e") ; Ctrl+E - End turn
+r::Send("r") ; Shift+R; Refresh current unit
^s::Send("!f,+a") ; Ctrl+S - Save game
r::Click("right") ; R - Right click

; V - Toggle view units, hold down in Combat Planner
v:: {
Send("{Space down}")
KeyWait("v")
Send("{Space up}")
}

; B - Find Place override
~b:: {
Suspend(true)
  ih_ := InputHook("v","{esc}{enter}"), ih_.Start(), ih_.Wait(), _ := ih_.Input
Suspend(false)
}

#HotIf ; End main
