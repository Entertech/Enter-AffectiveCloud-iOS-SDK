# Enter-AffectiveCloud-iOS-SDK

## Contents

- [Enter-AffectiveCloud-iOS-SDK](#enter-affectivecloud-ios-sdk)
  - [Contents](#contents)
  - [What is Enter Affective Cloud](#what-is-enter-affective-cloud)
  - [Demo](#demo)
  - [Manual](#manual)
  - [Installation](#installation)
    - [Requirements](#requirements)
    - [Cocoapods](#cocoapods)

## What is Enter Affective Cloud

Enter Affective Cloud is a cloud algorithm platform that can perform advanced affective data analysis based on the user's brainwave data and heart rate data. It can give affective values including relaxation, concentration, pleasure, stress, and excitement (internal test). The details[Official website](https://www.entertech.cn)。

Before starting development, please check our [development documentation](https://docs.affectivecloud.com)，Understand the architecture of the Affective Cloud platform and specific descriptions of the services it can provide, determine the services needed in your application. Then you need to contact the administrator to register the test application.

In order to facilitate your rapid development of the iOS platform, we provide this development SDK. With this SDK, you can integrate the capabilities of the Affective Cloud into your app quickly.

## Demo

[Heart Flow](https://github.com/Entertech/Enter-AffectiveCloud-Demo-iOS.git)This demo application integrates basic Bluetooth functions, Bluetooth device management interface, Affective Cloud SDK, and custom data display controls. A good display of the whole process of brainwave and heart rate data from the hardware collection to the upload of Affective Cloud real-time analysis and finally the generation of analysis reports and data display.

## Manual

- [EnterAffectiveCloud](EnterAffectiveCloud/) Provides an interface to provide brainwave data and heart rate data to the algorithm platform, and can calculate a variety of affective values.
- [EnterAffectiveCloudUI](UI/EnterAffectiveCloudUI/) Various UI modules are provided to display real-time data and report data (optional).

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/6_en.png" width="500">

## Installation

### Requirements
- Xcode 10.2
- Swift 5.0

### Cocoapods

Add this to Podfile。

```
target 'Your Target' do
    pod 'EnterAffectiveCloud'
    #(optional)
    pod 'EnterAffectiveCloudUI'
end
```
Run `pod  install`.
