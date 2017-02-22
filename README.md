# SYFlatButton

[![Build Status](https://travis-ci.org/Sunnyyoung/SYFlatButton.svg?branch=master)](https://travis-ci.org/Sunnyyoung/SYFlatButton)
![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg)
![Platform info](https://img.shields.io/badge/platform-macOS-lightgrey.svg)

## Description

A customized `NSButton` with modern flat style like bootstrap.

## Screenshot

![](https://raw.githubusercontent.com/Sunnyyoung/SYFlatButton/master/Screenshot/Screenshot.png)

## Installation

### Requirement

macOS 10.9 and above.

### Cocoapods

1. Add `pod 'SYFlatButton'` to your podfile
2. Run `pod install`

### Manual

Dragging `SYFlatButton.h` and `SYFlatButton.m` to your project.

## Usage

### Interface Builder

1. Create a `NSButton`
2. Set its `Button Style` to `Square` in order to change the button's height
3. Set its `Button Class` to `SYFlatButton`
4. Config the styles from the inspector

![](https://raw.githubusercontent.com/Sunnyyoung/SYFlatButton/master/Screenshot/InterfaceBuilder.png)

### Programmatically

See more customizable style from `SYFlatButton.h`

```objc
SYFlatButton *button = [[SYFlatButton alloc] initWithFrame:CGRectMake(20.0, 20.0, 60.0, 30.0)];
button.title = @"Code";
button.momentary = YES;
button.cornerRadius = 4.0;
button.backgroundNormalColor = [NSColor blueColor];
button.backgroundHighlightColor = [NSColor redColor];
[self.view addSubview:button];
```

## Credit

Inspired by [FlatButton](https://github.com/OskarGroth/FlatButton).

## License
The [MIT License](LICENSE).
