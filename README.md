
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

The Codemagic workflow builds an archive and exports `CameraResearch.ipa`.
It also creates `CameraResearch.tipa` as a renamed copy for TrollStore workflows.

Configure signing credentials and a development provisioning profile for:

`com.qhun22.cameraresearch`

## Author

- GitHub: [@qhun22](https://github.com/qhun22)

## License

For academic research only.
