#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#UseHook On ; Keyboard hook
#SingleInstance force ; Force single running instance
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
SetTitleMatchMode RegEx ; Regex title finding

; Exclusions
GroupAdd, Exlude_class, ahk_class TfOrders
GroupAdd, Exlude_class, ahk_class TfSpotlight

; Main
;#If WinActive("ahk_exe FlashpointCampaigns.exe")
;#If WinActive("ahk_exe FlashpointCampaigns.exe") and WinActive("ahk_class TfMain") 
#If WinActive("ahk_exe FlashpointCampaigns.exe")
and WinActive("ahk_class ^Tf.*")
and !WinActive("ahk_group Exlude_class")

; Suspend: Pause
Pause::Suspend

; WASD keys scroll + context nav
w::Send {Up}{Numpad8}
a::Send {Left}{Numpad4}
s::Send {Down}{Numpad2}
d::Send {Right}{Numpad6}

; Arrow keys scroll + context nav
Up::Send {Up}{Numpad8}
Left::Send {Left}{Numpad4}
Down::Send {Down}{Numpad2}
Right::Send {Right}{Numpad6}

; Hotkey remapping
Space::Send {Enter}	; Space - Enter
Tab::Send ^n		; Tab - Next Unit
+Tab::Send ^b		; Shift+Tab - Previous Unit
c::Send {Numpad5}	; C - Center on current hex
q::Send {F4}		; Q - Unit Dashboard
e::Send {F6}		; E - Subunit Inspector
|::Send {F7}		; | - Log
+s::Send ^k		; Shift+S - SOP Manager
r::Send ^r		; R - Rotate Stack
f::Send ^l		; F - Line-Of-Sight
g::Send ^o		; G - Spottable From
h::Send ^p		; H - SOP Ranges
t::Send ^y		; T - Enemies Spotted
y::Send ^d		; Y - Range Rings
v::Send ^u		; V - Hide Units
; e::Send {Click,right}	; Right-click

; Zoom controls
z::Send {WheelUp}	; Zoom In
x::Send {WheelDown}	; Zoom Out

#If ; End main

; Spotlight navigation
#If WinActive("ahk_class TfSpotlight")
w::Send {Up}
a::Send {Left}
s::Send {Down}
d::Send {Right}
#If ; End

; UNIT DASHBOARD
;#If WinActive("ahk_class TfUnitDashboardNew")
;q::Send {F4}	; Q - Close Unit Dashboard
;Esc::Send {F4}	; Esc - Close Unit Dashboard
;#If ; End

; SUBUNIT INSPECTOR
;#If WinActive("ahk_class TfSubunitInspector2")
;e::Send {F6}	; E - Close SubUnit Inspector
;Esc::Send {F6}	; Esc - Close SubUnit Inspector
;#If ; End

; SOP MANAGER
;#If WinActive("ahk_class TfSOPInspector")
;+s::Send ^k		; Shift+S - Close SOP Manager
;Esc::Send ^k	; Esc - Close SOP Manager
;#If ; End
