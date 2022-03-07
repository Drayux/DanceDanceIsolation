; ---------- DDR GAME PAD MAPPING SCRIPT   ----------
; ---------- AUTHOR: Liam (Drayux) Dempsey ----------

; ---------- DESCRIPTION ----------

; This script is is built to map the inputs of a DDR game pad (usually
; registered as a PS2 controller by Windows) to various keyboard and mouse
; inputs.

; Ideally, the game pad follows the button format below:

;   _________________________________________
;  /   SELECT    |             |    START    \
; |--------------|-------------|--------------|
; |     \  /     |     /\      |      __      |
; |      \/      |   / || \    |    /    \    |
; |      /\      |     ||      |   |      |   |
; |     /  \     |     ||      |    \____/    |
; |--------------|-------------|--------------|
; |   /          |             |          \   |
; |  /--------   |             |   --------\  |
; |  \--------   |             |   --------/  |
; |   \          |             |          /   |
; |--------------|-------------|--------------|
; |      /\      |     ||      |    ______    |
; |     /  \     |     ||      |   |      |   |
; |    /    \    |   \ || /    |   |      |   |
; |   /______\   |     \/      |   |______|   |
;  \_____________|_____________|_____________/



; ---------- PERMISSIONS ----------

; Though the original purpose of this script is for mapping to Alien Isolation,
; you are welcome to repurpose the script for other games, at your will.

; You are not permitted to resell, or claim this code as your own.

; ---------- GETTING STARTED ----------

; What makes DDR pad gameplay viable, is the ability to create unique binds
; from combinations of buttons, hence why the script is built around the soft
; game pads.

; First, be sure to configure your game pad. To do this, start the script as-is,
; with the game pad connected to your computer. Press each button one at a time,
; and take note of the code displayed by the GUI on the screen. Take this code
; and replace the indicated value in CONFIGURATION below. ~~Once completed for
; all buttons, you may change the value of INPUT_GUI to false.~~


;#Persistent
#InstallKeybdHook
#InstallMouseHook
; #KeyHistory 32
#SingleInstance, Force
#NoEnv
SendMode Input

; ---------- GLOBAL VARIABLES (Because I'm a bad programmer, I know) ----------
buttonQueue := {}

singleBinds := []
singleBindCount := 0

singleBindsModifier := []
singleBindModifierCount := 0

doubleBinds := []
doubleBindCount := 0

doubleBindsModifier := []
doubleBindModifierCount := 0

; ---------- CLASSES ----------
class Bind {
  __New(aInputKey1, aInputKey2, aModifierKey, aOutputKey) {
      this.inputKey1 := aInputKey1
      this.inputKey2 := aInputKey2
      this.modifierKey := aModifierKey
      this.outputKey := aOutputKey
      this.active := false

  }

  sendAction() {
    global buttonQueue
    global GAMEPAD_SELECT
    global GAMEPAD_START
    global GAMEPAD_CROSS
    global GAMEPAD_UP
    global GAMEPAD_CIRCLE
    global GAMEPAD_LEFT
    global GAMEPAD_RIGHT
    global GAMEPAD_TRIANGLE
    global GAMEPAD_DOWN
    global GAMEPAD_SQUARE
    outKey :=  this.outputKey

    ; Inactive, keys not satisfied : ignore
    ; Inactive, keys satisfied : activate
    ; Active, keys not satisfied : inactivate
    ; Active, keys satisfied : keep active

    if (!this.active && buttonQueue[this.inputKey1] && (this.inputKey2 == "" || buttonQueue[this.inputKey2]) && (this.modifierKey == "" || buttonQueue[this.modifierKey])) {
    ;if (!this.active && buttonQueue[this.inputKey1]) {
      Send {%outKey% down}
      GuiControl,, lastPress, %outKey%

      buttonQueue[this.inputKey1] := 0
      buttonQueue[this.inputKey2] := 0

      this.active := true

    } else if (this.active && (!buttonQueue[this.inputKey1] || !(this.inputKey2 == "" || buttonQueue[this.inputKey2]) || !(this.modifierKey == "" || buttonQueue[this.modifierKey]))) {
    ;} else if (this.active && !buttonQueue[this.inputKey1]) {
      Send {%outKey% up}

      this.active := false

    } else if (this.active) {
      buttonQueue[this.inputKey1] := 0
      buttonQueue[this.inputKey2] := 0

    }
  }
}

class MouseBind extends Bind {
  __New(aInputKey1, aInputKey2, aModifierKey, aMouseDir, aMouseSpeed) {
      this.inputKey1 := aInputKey1
      this.inputKey2 := aInputKey2
      this.modifierKey := aModifierKey
      this.mouseDir := aMouseDir  ; 0 - up; 1 - right; 2 - down; 3 - left; 4 - scroll up; 5 - scroll down
      this.mouseSpeed := aMouseSpeed
      this.active := false

  }

  sendAction() {
    global buttonQueue
    global GAMEPAD_SELECT
    global GAMEPAD_START
    global GAMEPAD_CROSS
    global GAMEPAD_UP
    global GAMEPAD_CIRCLE
    global GAMEPAD_LEFT
    global GAMEPAD_RIGHT
    global GAMEPAD_TRIANGLE
    global GAMEPAD_DOWN
    global GAMEPAD_SQUARE
    mDir := this.mouseDir
    mSpeed := this.mouseSpeed

    if (buttonQueue[this.inputKey1] && (this.inputKey2 == "" || buttonQueue[this.inputKey2]) && (this.modifierKey == "" || buttonQueue[this.modifierKey])) {
      switch mDir {
        ; case 0:
        ;   ; UP
        ;   DllCall("mouse_event", uint, 1, int, 0, int, -%mSpeed%, uint, 0, int, 0)
        ;
        ; case 1:
        ;   ; RIGHT
        ;   DllCall("mouse_event", uint, 1, int, %mSpeed%, int, 0, uint, 0, int, 0)
        ;
        ; case 2:
        ;   ; DOWN
        ;   DllCall("mouse_event", uint, 1, int, 0, int, %mSpeed%, uint, 0, int, 0)
        ;
        ; case 3:
        ;   ; LEFT
        ;   DllCall("mouse_event", uint, 1, int, -%mSpeed%, int, 0, uint, 0, int, 0)

        case 0:
          ; UP
          DllCall("mouse_event", uint, 1, int, 0, int, -15, uint, 0, int, 0)
          GuiControl,, lastMouse, Up

        case 1:
          ; RIGHT
          DllCall("mouse_event", uint, 1, int, 25, int, 0, uint, 0, int, 0)
          GuiControl,, lastMouse, Right

        case 2:
          ; DOWN
          DllCall("mouse_event", uint, 1, int, 0, int, 15, uint, 0, int, 0)
          GuiControl,, lastMouse, Down

        case 3:
          ; LEFT
          DllCall("mouse_event", uint, 1, int, -25, int, 0, uint, 0, int, 0)
          GuiControl,, lastMouse, Left

        case 4:
          if (!this.active)
            Send {WheelUp %mSpeed%}
            GuiControl,, lastMouse, WheelDwn

        case 5:
          if (!this.active)
            Send {WheelDown %mSpeed%}
            GuiControl,, lastMouse, WheelUp

      }

      buttonQueue[this.inputKey1] := 0
      buttonQueue[this.inputKey2] := 0

      this.active := true

    } else if (this.active && (!buttonQueue[this.inputKey1] || !(this.inputKey2 == "" || buttonQueue[this.inputKey2]) || !(this.modifierKey == "" || buttonQueue[this.modifierKey]))) {
      this.active := false

    }
  }
}

; ---------- FUNCTIONS ----------
bindSingle(aInputKey, aOutputKey) {
  global singleBinds
  global singleBindCount

  singleBinds[singleBindCount] := new Bind(aInputKey, "", "", aOutputKey)
  singleBindCount := singleBindCount + 1

}

bindSingleMouse(aInputKey, aMouseDir, aMouseSpeed) {
  global singleBinds
  global singleBindCount

  singleBinds[singleBindCount] := new MouseBind(aInputKey, "", "", aMouseDir, aMouseSpeed)
  singleBindCount := singleBindCount + 1

}

bindSingleModifier(aInputKey, aModifierKey, aOutputKey) {
  global singleBindsModifier
  global singleBindModifierCount

  singleBindsModifier[singleBindModifierCount] := new Bind(aInputKey, "", aModifierKey, aOutputKey)
  singleBindModifierCount := singleBindModifierCount + 1

}

bindSingleMouseModifier(aInputKey, aModifierKey, aMouseDir, aMouseSpeed) {
  global singleBindsModifier
  global singleBindModifierCount

  singleBindsModifier[singleBindModifierCount] := new MouseBind(aInputKey, "", aModifierKey, aMouseDir, aMouseSpeed)
  singleBindModifierCount := singleBindModifierCount + 1

}

bindDouble(aInputKey1, aInputKey2, aOutputKey) {
  global doubleBinds
  global doubleBindCount

  doubleBinds[doubleBindCount] := new Bind(aInputKey1, aInputKey2, "", aOutputKey)
  doubleBindCount := doubleBindCount + 1

}

bindDoubleMouse(aInputKey1, aInputKey2, aMouseDir, aMouseSpeed) {
  global doubleBinds
  global doubleBindCount

  doubleBinds[doubleBindCount] := new MouseBind(aInputKey1, aInputKey2, "", aMouseDir, aMouseSpeed)
  doubleBindCount := doubleBindCount + 1

}

bindDoubleModifier(aInputKey1, aInputKey2, aModifierKey, aOutputKey) {
  global doubleBindsModifier
  global doubleBindModifierCount

  doubleBindsModifier[doubleBindModifierCount] := new Bind(aInputKey1, aInputKey2, aModifierKey, aOutputKey)
  doubleBindModifierCount := doubleBindModifierCount + 1

}

bindDoubleMouseModifier(aInputKey1, aInputKey2, aModifierKey, aMouseDir, aMouseSpeed) {
  global doubleBindsModifier
  global doubleBindModifierCount

  doubleBindsModifier[doubleBindModifierCount] := new MouseBind(aInputKey1, aInputKey2, aModifierKey, aMouseDir, aMouseSpeed)
  doubleBindModifierCount := doubleBindModifierCount + 1

}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    MAKE EDITS HERE!!                                                   ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ---------- CONFIGURATION ----------

GAMEPAD_SELECT   := "2Joy9"    ; "Select" button
GAMEPAD_START    := "2Joy10"    ; "Start" button
GAMEPAD_CROSS    := "2Joy7"    ; X (alternatively A) button
GAMEPAD_UP       := "2Joy3"    ; Up button
GAMEPAD_CIRCLE   := "2Joy8"    ; O (alternatively B) button
GAMEPAD_LEFT     := "2Joy1"    ; Left button
GAMEPAD_RIGHT    := "2Joy4"    ; Right button
GAMEPAD_TRIANGLE := "2Joy5"    ; 'Triangle' (alternatively Y) button
GAMEPAD_DOWN     := "2Joy2"    ; Down button
GAMEPAD_SQUARE   := "2Joy6"    ; 'Square' (alternatively X) button

;INPUT_GUI := true           ; Enable GUI to aid configuration of the following

; ---------- BINDS ----------

;;;;; ALIEN ISOLATION ;;;;;
bindSingleMouseModifier(GAMEPAD_RIGHT, GAMEPAD_TRIANGLE, 1, 15)
bindSingleMouseModifier(GAMEPAD_DOWN, GAMEPAD_TRIANGLE, 3, 15)

bindSingle(GAMEPAD_CROSS, "w") ; Walk forward
bindSingle(GAMEPAD_TRIANGLE, "s") ; Walk backward
bindSingleModifier(GAMEPAD_RIGHT, GAMEPAD_SQUARE, "d") ; Strafe right
bindSingleModifier(GAMEPAD_DOWN, GAMEPAD_SQUARE, "a") ; Strafe left

bindSingle(GAMEPAD_SELECT, "LCtrl") ; Sprint
bindSingleModifier(GAMEPAD_TRIANGLE, GAMEPAD_CROSS, "LShift") ; Crouch

bindSingleMouseModifier(GAMEPAD_UP, GAMEPAD_LEFT, 0, 15) ; Look up
bindSingleMouseModifier(GAMEPAD_SQUARE, GAMEPAD_LEFT, 2, 15) ; Look down
bindSingleMouse(GAMEPAD_RIGHT, 1, 25) ; Look right
bindSingleMouse(GAMEPAD_DOWN, 3, 25) ; Look left

bindSingle(GAMEPAD_UP, "RButton") ; Aim
bindSingle(GAMEPAD_CIRCLE, "LButton") ; Attack / Fire
bindSingleModifier(GAMEPAD_SQUARE, GAMEPAD_TRIANGLE, "r") ; Reload / Plant
bindSingle(GAMEPAD_START, "e") ; Use

bindSingleModifier(GAMEPAD_TRIANGLE, GAMEPAD_LEFT, "q") ; Radial menu
bindDouble(GAMEPAD_START, GAMEPAD_SELECT, "Escape") ; Select / Tracker
bindDouble(GAMEPAD_START, GAMEPAD_SQUARE, "Space") ; Pause menu

;;;;; SKYRIM ;;;;;

; Mouse
; bindDoubleMouse(GAMEPAD_LEFT, GAMEPAD_UP, 0, 15) ; Look up
; bindDoubleMouse(GAMEPAD_LEFT, GAMEPAD_DOWN, 2, 15) ; Look down
; bindSingleMouse(GAMEPAD_RIGHT, 1, 25) ; Look right
; bindSingleMouse(GAMEPAD_DOWN, 3, 25) ; Look left

; Movement
; bindSingle(GAMEPAD_CROSS, "w") ; Walk forward
; bindDouble(GAMEPAD_TRIANGLE, GAMEPAD_LEFT, "s") ; Walk backward
; bindSingleModifier(GAMEPAD_RIGHT, GAMEPAD_SQUARE, "d") ; Strafe right
; bindSingleModifier(GAMEPAD_DOWN, GAMEPAD_SQUARE, "a") ; Strafe left

; Advanced Movement
; bindSingle(GAMEPAD_SELECT, "LCtrl") ; Sprint
; bindDouble(GAMEPAD_SELECT, GAMEPAD_TRIANGLE, "LShift") ; Crouch
; bindDoubleModifier(GAMEPAD_TRIANGLE, GAMEPAD_LEFT, GAMEPAD_CROSS, "Space") ; Jump

; Interactions / Combat
; bindSingle(GAMEPAD_SQUARE, "e") ; Use
; bindDouble(GAMEPAD_TRIANGLE, GAMEPAD_CIRCLE, "r") ; Ready / Sheathe
; bindSingle(GAMEPAD_CIRCLE, "LButton") ; Right hand (yeah I know it's LButton)
; bindSingle(GAMEPAD_UP, "RButton") ; Left hand (yeah I know it's RButton)
; bindDouble(GAMEPAD_TRIANGLE, GAMEPAD_SQUARE, "z") ; Shout

; Menus
; bindDouble(GAMEPAD_START, GAMEPAD_TRIANGLE, "Escape") ; System
; bindSingle(GAMEPAD_START, "Tab") ; The "all in one" screen
; bindDouble(GAMEPAD_TRIANGLE, GAMEPAD_UP, "q") ; Favorites
; bindDouble(GAMEPAD_START, GAMEPAD_SQUARE, "t") ; Wait

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;    STOP EDITS HERE!!                                                   ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; ---------- MAIN ----------
; Create GUI
; Gui, Main:New, -Resize +AlwaysOnTop, Input Assistant
Gui, Main:New, -Resize, Input Assistant
Gui, Margin, 20, 20

Gui, Font, s34 w900, Calibri ; Text - LAST PRESS:
Gui, Add, Text,, LAST PRESS:

; Gui, Font, s42 w200, Calibri ; Text - keyCode
; Gui, Add, Text, vlastPress yp+50, No key pressed
Gui, Add, Text, vlastPress xp+240, No input

Gui, Add, Text, xp+800, LAST MOUSE:
Gui, Add, Text, vlastMouse xp+270, No input

Gui, Show, AutoSize          ; Show the GUI

; Main program loop - CODE HERE!
Loop {
  ; UPDATE GUI LAST PRESS (lastPress)
  ; GuiControl,, lastPress, %A_PriorKey%

  ; CHECK PAD BUTTON STATES
  buttonQueue[GAMEPAD_SELECT] := GetKeyState(GAMEPAD_SELECT)
  buttonQueue[GAMEPAD_START] := GetKeyState(GAMEPAD_START)
  buttonQueue[GAMEPAD_CROSS] := GetKeyState(GAMEPAD_CROSS)
  buttonQueue[GAMEPAD_UP] := GetKeyState(GAMEPAD_UP)
  buttonQueue[GAMEPAD_CIRCLE] := GetKeyState(GAMEPAD_CIRCLE)
  buttonQueue[GAMEPAD_LEFT] := GetKeyState(GAMEPAD_LEFT)
  buttonQueue[GAMEPAD_RIGHT] := GetKeyState(GAMEPAD_RIGHT)
  buttonQueue[GAMEPAD_TRIANGLE] := GetKeyState(GAMEPAD_TRIANGLE)
  buttonQueue[GAMEPAD_DOWN] := GetKeyState(GAMEPAD_DOWN)
  buttonQueue[GAMEPAD_SQUARE] := GetKeyState(GAMEPAD_SQUARE)

  ; ACTIVATE DOUBLE BINDS w/ MODIFIER (todo pass button queue by reference)
  For index, keybind in doubleBindsModifier
    keybind.sendAction()

  ; ACTIVATE DOUBLE BINDS (todo pass button queue by reference)
  For index, keybind in doubleBinds
    keybind.sendAction()

  ; ACTIVATE SINGLE BINDS w/ MODIFIER (todo pass button queue by reference)
  For index, keybind in singleBindsModifier
    keybind.sendAction()

  ; ACTIVATE SINGLE BINDS (todo pass button queue by reference)
  For index, keybind in singleBinds
    keybind.sendAction()

  Sleep 5
}

; Called upon window close
MainGuiClose:
ExitApp
