; AutoHotkey v2 script for Flashpoint Campaigns
#Warn ; Enable warnings to assist with detecting common errors.
#UseHook true ; Keyboard hook
#SingleInstance force ; Force single running instance
SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
; SetTitleMatchMode("RegEx") ; Regex title finding

; Exclusions
GroupAdd("Exlude_class", "ahk_class TfOrders")
GroupAdd("Exlude_class", "ahk_class TfSpotlight")

; Main
;#HotIf WinActive("ahk_exe FlashpointCampaigns.exe") and WinActive("ahk_class TfMain")
#HotIf WinActive("ahk_exe FlashpointCampaigns.exe")
; and WinActive("ahk_class ^Tf.*")
and !WinActive("ahk_group Exlude_class")
and !WinExist("ahk_class #32768") ; Standard Windows context/menu class

; Pause - Suspend
Pause::Suspend()

; WASD keys scroll + context nav
w::Send("{Up}{Numpad8}")
a::Send("{Left}{Numpad4}")
s::Send("{Down}{Numpad2}")
d::Send("{Right}{Numpad6}")

; Arrow keys scroll + context nav
Up::Send("{Up}{Numpad8}")
Left::Send("{Left}{Numpad4}")
Down::Send("{Down}{Numpad2}")
Right::Send("{Right}{Numpad6}")

; Hotkey remapping
Space::Send("{Enter}") ; Space - Enter
Tab::Send("^n") ; Tab - Next Unit
+Tab::Send("^b") ; Shift+Tab - Previous Unit
c::Send("{Numpad5}") ; C - Center on current hex
q::Send("{F4}") ; Q - Unit Dashboard
e::Send("{F6}") ; E - Subunit Inspector
|::Send("{F7}") ; | - Log
+s::Send("^k") ; Shift+S - SOP Manager
r::Send("^r") ; R - Rotate Stack
f::Send("^l") ; F - Line Of Sight
g::Send("^o") ; G - Spottable From
h::Send("^p") ; H - SOP Ranges
t::Send("^y") ; T - Enemies Spotted
y::Send("^d") ; Y - Range Rings
v::Send("^u") ; V - Hide Units

; Mouse click handling
+e::Send("{Click,right}")
AppsKey::Send("{Shift Down}{Click,right}{Shift Up}")
RButton::Send("{Shift Down}{Click,right}{Shift Up}") 

; Ctrl+Shift+S - Save game
^+s::Send("{Alt Down},g,a,p,{Alt Up}")

; Zoom controls
z::Send("{WheelUp}")	; Zoom In
x::Send("{WheelDown}")	; Zoom Out

#HotIf ; End main

; Spotlight navigation
#HotIf WinActive("ahk_class TfSpotlight")
w::Send("{Up}")
a::Send("{Left}")
s::Send("{Down}")
d::Send("{Right}")
#HotIf ; End

; Handle RMB click if menu already showing
#HotIf WinExist("ahk_class #32768")
RButton::Send("{Shift Down}{Click,right}{Shift Up}") 
#HotIf ; End

; Unit Dashboard
;#HotIf WinActive("ahk_class TfUnitDashboardNew")
;q::Send("{F4}")	; Q - Close Unit Dashboard
;Esc::Send("{F4}")	; Esc - Close Unit Dashboard
;#HotIf ; End

; Subunit Inspector
;#HotIf WinActive("ahk_class TfSubunitInspector2")
;e::Send("{F6}")	; E - Close SubUnit Inspector
;Esc::Send("{F6}")	; Esc - Close SubUnit Inspector
;#HotIf ; End

; SOP Manager
;#HotIf WinActive("ahk_class TfSOPInspector")
;+s::Send("^k")		; Shift+S - Close SOP Manager
;Esc::Send("^k")	; Esc - Close SOP Manager
;#HotIf ; End
