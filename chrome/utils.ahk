#Requires AutoHotkey v2.0

; ================================================

themesDict := Map()
themesDict.Set("Dark", [0x505050, 0x2155aa, 0x363636])
themesDict.Set("Light", [0xf2f2f2, 0xc9d8f0, 0xf2f2f2])

; ================================================

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
  
/**
 * Types text into the active window.
 * 
 * @param {String} text - The text to type.
 */
TypeIt(text) {
  Loop Parse text {
    Send "{raw}" . A_LoopField
  }
}
  
/**
 * Waits for the site to load. Returns after the site has loaded.
 */
WaitForSiteLoad() {
  FindCenterOfImage([A_WorkingDir . "\assets\buttons\light-reload.png", A_WorkingDir . "\assets\buttons\dark-reload.png"], 34)
  tempX := centerImageMap.Get("X")
  tempY := centerImageMap.Get("Y")

  MouseMove tempX, tempY
  Sleep 100
  
  while (PixelSearch(&Px, &Py, tempX, tempY, tempX, tempY, Format("0x{:X}", themesDict.Get("Dark").Get(1))) == 0 && 
         PixelSearch(&Px, &Py, tempX, tempY, tempX, tempY, Format("0x{:X}", themesDict.Get("Light").Get(1))) == 0) {
    Sleep 100
  }
  
  return
}
  
/**
 * Searches for a link in the address bar.
 * 
 * @param {String} link - The link to search for.
 */
SearchInBar(link) {
  Send "^t"
  Sleep 100

  TypeIt(link)
  Sleep 100
  Send "{Enter}"

  WaitForSiteLoad()
}
