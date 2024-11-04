#Requires AutoHotkey v2.0
#Include utils.ahk

; ================================================

SetDefaultMouseSpeed 3
SendMode "Event"

themesDict := Map()
themesDict.Set("Dark", [0x505050, 0x2155aa, 0x363636])
themesDict.Set("Light", [0xf2f2f2, 0xc9d8f0, 0xf2f2f2])

waitSpeed := 100
longWaitSpeed := waitSpeed * 2.5
longestWaitSpeed := waitSpeed * 5
waitTimeSpeed := waitSpeed * 20

buttonsPath := A_WorkingDir . "\assets\chrome\buttons\"
togglesPath := A_WorkingDir . "\assets\chrome\toggles\"

; ================================================

Run "Chrome"
WinWait "Chrome"
WinMaximize

; Wait for chrome to load
WaitForSiteLoad()

; Go into extensions tab
SearchInBar("Chrome://extensions")

; Activate developer mode (it probably isn't on)
WinGetPos &windowX, &windowY, &windowWidth, &windowHeight
if ImageSearch(&Px, &Py, windowWidth - 100, 0, windowWidth, windowHeight, togglesPath . "dark-toggle-off.png") ||
   ImageSearch(&Px, &Py, windowWidth - 100, 0, windowWidth, windowHeight, togglesPath . "light-toggle-off.png") {
    ClickOnCenterImage([togglesPath . "dark-toggle.png", togglesPath . "light-toggle.png"], 26, 16)
}
Sleep 100

; Go to extensions store and download tampermonkey
SearchInBar("https://chromewebstore.google.com/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo")
Sleep longestWaitSpeed

; Add tampermonkey to extensions
ClickOnCenterImage([buttonsPath . "english-add-extension.png", buttonsPath . "polish-add-extension.png"], 150, 40)
Sleep waitSpeed

; Click on the 'add extension' button when possible
ClickOnCenterImage([buttonsPath . "english-light-confirm-extension.png", 
                    buttonsPath . "polish-light-confirm-extension.png",
                    buttonsPath . "english-dark-confirm-extension.png",
                    buttonsPath . "polish-dark-confirm-extension.png"], 117, 38)
Sleep longWaitSpeed

; Wait for the extension popup to appear and close it
ClickOnCenterImage([buttonsPath . "light-extension-popup-close.png", buttonsPath . "dark-extension-popup-close.png"], 14)
Sleep waitSpeed

; Wait for the startup extension site to load
Sleep waitTimeSpeed
while PixelSearch(&Px, &Py, 1000, 115, 1000, 115, 0x00485B) == 0 {
  Sleep waitSpeed
}

; Allow the extension to run in incognito mode
SearchInBar("chrome://extensions/?id=dhdgffkkebhmkfjojejmpbldmpobfkfo")
; MouseMove 1259, 976
; Sleep waitSpeed
; while (PixelSearch(&Px, &Py, 1259, 976, 1259, 976, Format("0x{:X}", themesDict.Get("Dark").Get(2))) == 0 && 
;        PixelSearch(&Px, &Py, 1259, 976, 1259, 976, Format("0x{:X}", themesDict.Get("Light").Get(2))) == 0) {
;   MouseClick "left", 1259, 976
;   Sleep waitSpeed
; }
Send "{Tab}"
Send "{Tab}"
Send "{Tab}"
Send "{Tab}"
Send "{Tab}"
Send "{Tab}"
Send "{Tab}"
Send "{Enter}"


; Go into Tampermonkey utils tab
SearchInBar("chrome-extension://dhdgffkkebhmkfjojejmpbldmpobfkfo/options.html#nav=utils")

; Paste and install the script link 
FindCenterOfImage([buttonsPath . "english-install-userscript.png", buttonsPath . "polish-install-userscript.png"], 70, 27)
tempX := centerImageMap.Get("X")
tempY := centerImageMap.Get("Y")

MouseClick "left", tempX - 100, tempY
TypeIt("https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/main.js")
Sleep waitSpeed

MouseClick "left", tempX, tempY
Sleep 1000

; Confirm the installation
Send "{Enter}"
Sleep 100

; Configure settings for the script
ClickOnCenterImage([buttonsPath . "english-userscripts.png", buttonsPath . "polish-userscripts.png"], 160, 25)
Sleep 100

ClickOnCenterImage([buttonsPath . "main.png"], 34, 14)
MouseClick "left"

FindCenterOfImage([buttonsPath . "english-launch-in.png", buttonsPath . "polish-launch-in.png"], 75, 14)
tempX := centerImageMap.Get("X")
tempY := centerImageMap.Get("Y")
defaultLoc := [tempX - Integer(75 / 2), tempY - Integer(14 / 2)]

if ImageSearch(&Px, &Py, defaultLoc[1], defaultLoc[2] - 10, defaultLoc[1] + 700, defaultLoc[2] + 30, buttonsPath . "dropdown.png") {
  MouseClick "left", Px + Integer(14 / 2), Py + Integer(11 / 2)
}

ClickOnCenterImage([buttonsPath . "dark-all-tabs.png", buttonsPath . "light-all-tabs.png"], 47, 14)

; Allow trust in all domains
SearchInBar("http://www.google.com")
Sleep 200

ClickOnCenterImage([buttonsPath . "polish-allow-trust.png", buttonsPath . "english-allow-trust.png"], 270, 30)
Sleep 200
Send "{Enter}"
Sleep 100

; Close the tabs
Send "^w"
Sleep 100
Send "^w"
Sleep 100
Send "^w"
Sleep 100
Send "^w"
Sleep 100
Send "^w"
Sleep 100
Send "^w"
