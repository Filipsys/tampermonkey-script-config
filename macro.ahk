#Requires AutoHotkey v2.0

; ================================================

SetDefaultMouseSpeed 3
SendMode "Event"

themesDict := Map()
themesDict.Set("Dark", [0x505050, 0x2155aa, 0x363636])
themesDict.Set("Light", [0xf2f2f2, 0xc9d8f0, 0xf2f2f2])


TypeIt(text) {
  Loop Parse text {
    Send "{raw}" . A_LoopField
  }
}

WaitForSiteLoad() {
  MouseMove 103, 70
  Sleep 100

  while (PixelSearch(&Px, &Py, 103, 70, 103, 70, Format("0x{:X}", themesDict.Get("Dark").Get(1))) == 0 && 
         PixelSearch(&Px, &Py, 103, 70, 103, 70, Format("0x{:X}", themesDict.Get("Light").Get(1))) == 0) {
    Sleep 100
  }

  return
}

SearchInBar(link) {
  MouseMove 950, 70
  Sleep 100
  MouseClick "left"
  Sleep 100

  TypeIt(link)
  Sleep 100
  Send "{Enter}"

  WaitForSiteLoad()
}

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
Sleep 100
if (PixelSearch(&Px, &Py, 1899, 112, 1899, 112, Format("0x{:X}", themesDict.Get("Dark").Get(2))) == 0 && 
    PixelSearch(&Px, &Py, 1899, 112, 1899, 112, Format("0x{:X}", themesDict.Get("Light").Get(2))) == 0) {
  MouseClick "left", 1899, 112
  Sleep 100
}

; Go to extensions store and download tampermonkey
SearchInBar("https://chromewebstore.google.com/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo")

; Add tampermonkey to extensions
MouseClick "left", 1410, 250
Sleep 100

; Click on the 'add extension' button when possible
MouseMove 280, 240
Sleep 100
while (PixelSearch(&Px, &Py, 280, 240, 280, 240, Format("0x{:X}", themesDict.Get("Dark").Get(3))) == 0 && 
       PixelSearch(&Px, &Py, 280, 240, 280, 240, Format("0x{:X}", themesDict.Get("Light").Get(3))) == 0) {
  Sleep 100
}
MouseClick "left", 280, 240
Sleep 200

; Wait for the extension popup to appear and close it
while PixelSearch(&Px, &Py, 47, 36, 47, 36, 0x000) == 0 {
  Sleep 100
}
MouseClick "left", 360, 35
Sleep 100

; Wait for the startup extension site to load
Sleep 1000
while PixelSearch(&Px, &Py, 1000, 115, 1000, 115, 0x00485B) == 0 {
  Sleep 100
}
; Send "^w"

; Allow the extension to run in incognito mode
SearchInBar("chrome://extensions/?id=dhdgffkkebhmkfjojejmpbldmpobfkfo")
MouseMove 1259, 976
Sleep 100
while (PixelSearch(&Px, &Py, 1259, 976, 1259, 976, Format("0x{:X}", themesDict.Get("Dark").Get(2))) == 0 && 
       PixelSearch(&Px, &Py, 1259, 976, 1259, 976, Format("0x{:X}", themesDict.Get("Light").Get(2))) == 0) {
  MouseClick "left", 1259, 976
  Sleep 100
}

; Go into Tampermonkey utils tab
SearchInBar("chrome-extension://dhdgffkkebhmkfjojejmpbldmpobfkfo/options.html#nav=utils")

; Paste and install the script link 
MouseClick "left", 375, 675
TypeIt("https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/main.js")
Sleep 100
MouseClick "left", 650, 675
Sleep 300
MouseClick "left", 195, 335
Sleep 100

; Configure settings for the script
MouseClick "left", 1510, 160
Sleep 100
MouseClick "left", 170, 250
Sleep 100
MouseClick "left", 170, 250
Sleep 100
MouseClick "left", 550, 500
Sleep 100
MouseClick "Left", 555, 570
Sleep 100

; Allow trust in all domains
SearchInBar("http://www.google.com")
Sleep 300
MouseClick "left", 280, 700
Sleep 300
MouseClick "left", 1049, 266
Sleep 500

; Close the tabs
Send "^w"
Sleep 100
Send "^w"
