#Requires AutoHotkey v2.0
SetDefaultMouseSpeed 6
SendMode "Event"
themesDict := Map()
themesDict.Set("Dark", [0x4b4b54, 0x2155aa, 0x00c7e6])
themesDict.Set("Light", [0xf2f2f2, 0xc9d8f0, 0xf2f2f2])

TypeIt(text) {
    loop parse text {
        Send "{raw}" . A_LoopField
    }
}

WaitForSiteLoad() {
    MouseMove 100, 50
    Sleep 100
    while (PixelSearch(&Px, &Py, 100, 50, 100, 50, Format("0x{:X}", themesDict.Get("Dark").Get(1))) == 0 &&
    PixelSearch(&Px, &Py, 100, 50, 100, 50, Format("0x{:X}", themesDict.Get("Light").Get(1))) == 0) {
        Sleep 100
    }
    return
}

SearchInBar(link) {
    MouseMove 1000, 64
    Sleep 100
    MouseClick "left"
    Sleep 100
    TypeIt(link)
    Sleep 100
    Send "{Enter}"
    WaitForSiteLoad()
}

/**
 * Finds the center of an image. After 20 attempts, the function will throw a TimeoutError.
 * 
 * Parameters:
 * @param {Array} imagePaths - The paths to the images to search for.
 * @param {Integer} imageSizeX - The width of the image to search for.
 * @param {Integer | unset} imageSizeY - The height of the image to search for. If not set, the width will be used.
 * 
 * @returns - Returns a global variable `centerImageMap` that contains the X and Y coordinates of the center of the image.
 */
FindCenterOfImage(imagePaths, imageSizeX, imageSizeY?) {
    Px := Py := 0
    rateLimit := 20
    minFound := 1
    found := 0
  
    if !IsNumber(imageSizeX)
      throw PropertyError("imageSizeX must be a number", -1)
    if IsSet(imageSizeY) && !IsNumber(imageSizeY)
      throw PropertyError("imageSizeY must be a number", -1)
  
    ; Reset mouse position
    SetDefaultMouseSpeed 1
    MouseMove 0, 0
    SetDefaultMouseSpeed 3
  
    CheckForImage() {
      if rateLimit <= 0
        throw TimeoutError("Rate limit exceeded", -1)
  
      Sleep 200
  
      for imagePath in imagePaths {
        WinGetPos &windowX, &windowY, &windowWidth, &windowHeight
  
        if Integer(ImageSearch(&Px, &Py, 0, 0, windowWidth, windowHeight, imagePath)) {
          found++
        }
  
        if found >= minFound {
          global centerImageMap := Map(
            "X", Px + imageSizeX / 2,
            "Y", Py + (IsSet(imageSizeY) ? imageSizeY : imageSizeX) / 2
          )
  
          return
        }
      }
    
      if found == 0 {
        rateLimit--
        CheckForImage()
      }
    }
    
    return CheckForImage()
  }
    
  /**
   * Clicks on the center of an image. After 20 attempts, the function will throw a TimeoutError.
   * 
   * @param {Array} imagePaths - The paths to the images to search for.
   * @param {Integer} imageSizeX - The width of the image to search for.
   * @param {Integer | unset} imageSizeY - The height of the image to search for. If not set, the width will be used.
   */
  ClickOnCenterImage(imagePaths, imageSizeX, imageSizeY?) {
    if !IsNumber(imageSizeX)
      throw PropertyError("imageSizeX must be a number", -1)
    if IsSet(imageSizeY) && !IsNumber(imageSizeY)
      throw PropertyError("imageSizeY must be a number", -1)
  
    if IsSet(imageSizeY)
      FindCenterOfImage(imagePaths, imageSizeX, imageSizeY)
    else
      FindCenterOfImage(imagePaths, imageSizeX)
      
    tempX := centerImageMap.Get("X")
    tempY := centerImageMap.Get("Y")
    
    MouseClick "left", tempX, tempY
  }

Run "Firefox"
WinWait "Mozilla Firefox"
WinMaximize
WaitForSiteLoad()

SearchInBar("https://addons.mozilla.org/firefox/downloads/file/4367975/tampermonkey-5.3.1.xpi")
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\checkbox.png"], 16)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\addExtensionConfirm-PL.png"], 56, 32)
Sleep 5000
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\ok.png"], 40, 32)
Sleep 100
SearchInBar("about:addons")
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\Extensions.png", A_WorkingDir . "\assets\firefox\ExtensionsOn.png"], 121, 24)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\moreOptions.png"], 24)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\extensionOptions-PL.png"], 38, 17)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\utilitiesTM-PL.png"], 99, 25)
Sleep 500
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMScriptInput.png"], 406, 21)
TypeIt("https://raw.githubusercontent.com/Filipsys/tampermonkey-script-config/refs/heads/main/main.js")
Sleep 300
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMInstallButton-PL.png"], 66, 23)
Sleep 300
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMInstallButtonConfirm-PL.png"], 66, 23)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMInstalledScripts-PL.png"], 181, 25)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMMainScript.png"], 45, 20)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMScriptSettings-PL.png"], 105, 25)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMLaunchIn-PL.png"], 115, 22)
Sleep 100
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\TMAllTabs.png"], 110, 25)
Sleep 100
SearchInBar("http://www.google.com")
Sleep 300
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\AllowOnAllDomains.png"], 278, 27)
Sleep 300
ClickOnCenterImage([A_WorkingDir . "\assets\firefox\FinalConfirm.png"], 39, 30)
Sleep 500
Send "^w"
Sleep 100
Send "^w"