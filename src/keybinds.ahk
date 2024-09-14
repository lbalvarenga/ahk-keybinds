#InstallKeybdHook
#SingleInstance force
#Persistent
#NoTrayIcon
#MaxThreadsPerHotkey, 3

; SetCapsLockState, AlwaysOff

CapsLock::Esc
$Esc::CapsLock

; Autoclicker
LWin & `::
  Toggle := !Toggle
  Loop {
    If (!Toggle)
      Break
    Click
    Sleep 1
  }
Return

; brasiliam

LWin & Enter::
  Run "C:\Users\lal\AppData\Local\Microsoft\WindowsApps\Microsoft.WindowsTerminal_8wekyb3d8bbwe\wt.exe"
Return

LWin & F1::
  WinSet, AlwaysOnTop, , A
Return

LWin & F6::
  Send {Volume_Down}
Return

LWin & F7::
  Send {Volume_Up}
Return

LWin & F8::
  Send {Volume_Mute}
Return

LWin & F9::
  Send {Media_Prev}
Return

LWin & F10::
  Send {Media_Play_Pause}
Return

LWin & F11::
  Send {Media_Next}
Return

LWin & q::
  WinClose, A
Return

~LWin & WheelUp::
  Send {Volume_Up}
Return

~LWin & WheelDown::
  Send {Volume_Down}
Return

; Win Shift a
; Centers window with 4:3 ar
#+a::
  WinGetPos, x, y, w, h, A
  ; MsgBox, %w%:%h%

  SysGet, mon, MonitorWorkArea

  ; TODO: add min() function
  ; TODO: consider taskbar bounds
  h := monBottom - 40 ; 40 is the margin
  w := h * 4 / 3

  x := (monRight / 2) - (w / 2)
  y := (monBottom / 2) - (h / 2)

  WinMove, A,, %x%, %y%, w, h
Return

#+c::
  WinGetPos, x, y, w, h, A
  ; MsgBox, %w%:%h%

  SysGet, mon, MonitorWorkArea

  ; TODO: add min() function
  ; TODO: consider taskbar bounds
  ; h := monBottom - 40 ; 40 is the margin
  ; w := h * 4 / 3

  x := (monRight / 2) - (w / 2)
  y := (monBottom / 2) - (h / 2)

  WinMove, A,, %x%, %y%, w, h
Return

^#h::
  SendInput #^{Left}
Return

; Win Ctrl l
^#l::
  SendInput #^{Right}
Return

; Win Shift h
+#h::
  SendInput #{Left}
Return

+#l::
  SendInput #{Right}
Return

+#k::
  SendInput #!{Up}
Return

+#j::
  SendInput #!{Down}
Return

; Win Alt Shift h
+!#h::
  SendInput #!{Left}
Return

+!#l::
  SendInput #!{Right}
Return

; https://www.reddit.com/r/AutoHotkey/comments/n9ojf4/i_created_a_script_to_support_altdrag_to_move/
LWin & LButton::
  ReplaceSystemCursor("IDC_ARROW", "IDC_CROSS")
  CoordMode, Mouse
  MouseGetPos, origMouseX, origMouseY, winId
  SetTimer, lMouseWatch, 10
return

lMouseWatch:
  if (!GetKeyState("LButton", "P")) {
    ReplaceSystemCursor()
    SetTimer, lMouseWatch, Off
  } else {
    CoordMode, Mouse
    MouseGetPos, mouseX, mouseY
    WinGetPos, winX, winY,,, ahk_id %winId%
    deltaX := mouseX - origMouseX
    deltaY := mouseY - origMouseY
    origMouseX := mouseX
    origMouseY := mouseY
    SetWinDelay, -1
    WinMove, ahk_id %winId%,, winX + deltaX, winY + deltaY
  }
return

LWin & RButton::
  ReplaceSystemCursor("IDC_ARROW", "IDC_SIZENWSE")
  CoordMode, Mouse
  MouseGetPos, origMouseX, origMouseY, winId

  WinGetPos, winX, winY, winW, winH, ahk_id %winId%
  relX := (origMouseX - winX) / winW - .5
  relY := (origMouseY - winY) / winH - .5
  resizeLeft := 2 * relX + Abs(relY) < 0
  resizeTop := 2 * relY + Abs(relX) < 0
  resizeRight := 2 * relX - Abs(relY) > 0
  resizeBottom := 2 * relY - Abs(relX) > 0

  SetTimer, rMouseWatch, 10
return

rMouseWatch:
  if (!GetKeyState("RButton", "P")) {
    SetTimer, rMouseWatch, Off
    ReplaceSystemCursor()
  } else {
    CoordMode, Mouse
    MouseGetPos, mouseX, mouseY
    WinGetPos, winX, winY, winW, winH, ahk_id %winId%
    deltaX := mouseX - origMouseX
    deltaY := mouseY - origMouseY
    origMouseX := mouseX
    origMouseY := mouseY
    SetWinDelay, -1

    newWinX := resizeLeft ? winX + deltaX : winX
    newWinY := resizeTop ? winY + deltaY : winY
    newWinW := winW + winX - newWinX + (resizeRight ? deltaX : 0)
    newWinH := winH + winY - newWinY + (resizeBottom ? deltaY : 0)
    WinMove, ahk_id %winId%,, newWinX, newWinY, newWinW, newWinH
  }
return

ReplaceSystemCursor(old := "", new := "")
{
  static IMAGE_CURSOR := 2, SPI_SETCURSORS := 0x57
    , exitFunc := Func("ReplaceSystemCursor").Bind("", "")
    , setOnExit := false
    , SysCursors := { IDC_APPSTARTING: 32650
      , IDC_ARROW : 32512
      , IDC_CROSS : 32515
      , IDC_HAND : 32649
      , IDC_HELP : 32651
      , IDC_IBEAM : 32513
      , IDC_NO : 32648
      , IDC_SIZEALL : 32646
      , IDC_SIZENESW : 32643
      , IDC_SIZENWSE : 32642
      , IDC_SIZEWE : 32644
      , IDC_SIZENS : 32645
      , IDC_UPARROW : 32516
      , IDC_WAIT : 32514 }
  if !old {
    DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
    OnExit(exitFunc, 0), setOnExit := false
  }
  else {
    hCursor := DllCall("LoadCursor", "Ptr", 0, "UInt", SysCursors[new], "Ptr")
    hCopy := DllCall("CopyImage", "Ptr", hCursor, "UInt", IMAGE_CURSOR, "Int", 0, "Int", 0, "UInt", 0, "Ptr")
    DllCall("SetSystemCursor", "Ptr", hCopy, "UInt", SysCursors[old])
    if !setOnExit
      OnExit(exitFunc), setOnExit := true
  }
}
