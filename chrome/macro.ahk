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

; ================================================

Run "Chrome"
WinWait "Chrome"
WinMaximize

; Wait for chrome to load
WaitForSiteLoad()

; Go into extensions tab
SearchInBar("Chrome://extensions")

; Activate developer mode (it probably isn't on)
MouseMove 1899, 112
Sleep waitSpeed
if (PixelSearch(&Px, &Py, 1899, 112, 1899, 112, Format("0x{:X}", themesDict.Get("Dark").Get(2))) == 0 && 
    PixelSearch(&Px, &Py, 1899, 112, 1899, 112, Format("0x{:X}", themesDict.Get("Light").Get(2))) == 0) {
  MouseClick "left", 1899, 112
  Sleep waitSpeed
}

; Go to extensions store and download tampermonkey
SearchInBar("https://chromewebstore.google.com/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo")
Sleep longestWaitSpeed

; Add tampermonkey to extensions
MouseClick "left", 1410, 250
Sleep waitSpeed

; Click on the 'add extension' button when possible
MouseMove 280, 240
Sleep waitSpeed
while (PixelSearch(&Px, &Py, 280, 240, 280, 240, Format("0x{:X}", themesDict.Get("Dark").Get(3))) == 0 && 
       PixelSearch(&Px, &Py, 280, 240, 280, 240, Format("0x{:X}", themesDict.Get("Light").Get(3))) == 0) {
  Sleep waitSpeed
}
MouseClick "left", 280, 240
Sleep longWaitSpeed

; Wait for the extension popup to appear and close it
while PixelSearch(&Px, &Py, 47, 36, 47, 36, 0x000) == 0 {
  Sleep waitSpeed
}
MouseClick "left", 360, 35
Sleep waitSpeed

; Wait for the startup extension site to load
Sleep waitTimeSpeed
while PixelSearch(&Px, &Py, 1000, 115, 1000, 115, 0x00485B) == 0 {
  Sleep waitSpeed
}

; Allow the extension to run in incognito mode
SearchInBar("chrome://extensions/?id=dhdgffkkebhmkfjojejmpbldmpobfkfo")
MouseMove 1259, 976
Sleep waitSpeed
while (PixelSearch(&Px, &Py, 1259, 976, 1259, 976, Format("0x{:X}", themesDict.Get("Dark").Get(2))) == 0 && 
       PixelSearch(&Px, &Py, 1259, 976, 1259, 976, Format("0x{:X}", themesDict.Get("Light").Get(2))) == 0) {
  MouseClick "left", 1259, 976
  Sleep waitSpeed
}

; Go into Tampermonkey utils tab
SearchInBar("chrome-extension://dhdgffkkebhmkfjojejmpbldmpobfkfo/options.html#nav=utils")

; Paste and install the script link 
MouseClick "left", 375, 675
TypeIt("https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/main.js")
Sleep waitSpeed
MouseClick "left", 650, 675
Sleep longestWaitSpeed
MouseClick "left", 195, 335
Sleep waitSpeed

; Configure settings for the script
MouseClick "left", 1510, 160
Sleep waitSpeed
MouseClick "left", 170, 250
Sleep waitSpeed
MouseClick "left", 170, 250
Sleep waitSpeed
MouseClick "left", 550, 500
Sleep waitSpeed
MouseClick "Left", 555, 570
Sleep waitSpeed

; Allow trust in all domains
SearchInBar("http://www.google.com")
Sleep longWaitSpeed
MouseClick "left", 280, 700
Sleep longWaitSpeed
MouseClick "left", 1049, 266
Sleep longestWaitSpeed

; Close the tabs
Send "^w"
Sleep waitSpeed
Send "^w"
