# BatePonto.app

A Cocoa version for the Bate Ponto rails app


## Assets

### Icon

I used an icon of a Clock from the Internet to represent
the clock that will be "punched". It shows up in the system
menu bar. I used ImageMagick to make an extra inverted icon
that shows up when the menu bar item is clicked.

```console
convert \( Clock.png -alpha extract \) -background white -alpha shape ClockInverted.png
```

### Punch image


I don't have money and/or the skills necessary to use
Illustrator or any other vector software, so I gave [QBlocks](http://www.nlinea.com) a try and it's really sweet! My first icon ever! It's versioned in the project in case someone wants to change
the punch image.

## App Preferences

Guide [here](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/UserDefaults/AccessingPreferenceValues/AccessingPreferenceValues.html)

[Alternatively](https://developer.apple.com/library/mac/documentation/security/conceptual/cryptoservices/KeyManagementAPIs/KeyManagementAPIs.html)
