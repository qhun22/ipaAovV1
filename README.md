# Camera Research Panel - AOV

## Overview

Research project for studying camera controls and runtime behavior in Arena of Valor.

## Features

- Camera zoom control from 10 to 80
- Free camera toggle
- No fog toggle
- Reset camera controls

## Technology

- Objective-C
- UIKit
- iOS 13.0 or later
- iPhone and iPad support

## Project structure

```text
ios_app/CameraResearch/
|-- CameraResearch.xcodeproj/
|-- Classes/
|   |-- CameraPanel.h/m
|   `-- MemoryManager.h/m
|-- AppDelegate.h/m
|-- LaunchScreen.storyboard
|-- main.m
`-- Info.plist
```

## Build

The Codemagic workflow builds the app directly for `iphoneos` with code signing
disabled. It places the app in a `Payload` directory and creates both
`CameraResearch.ipa` and `CameraResearch.tipa` for TrollStore workflows.

No Apple Developer account, team ID, provisioning profile, or
`ExportOptions.plist` is required. The resulting package is intended for
installation through TrollStore.

## Author

- GitHub: [@qhun22](https://github.com/qhun22)

## License

For academic research only.
