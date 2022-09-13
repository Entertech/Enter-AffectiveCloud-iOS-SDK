# Affective Cloud Standard UI

- [Affective Cloud Standard UI](#affective-cloud-standard-ui)
  - [Demo](#demo)
  - [Real-time Data UI](#real-time-data-ui)
    - [How To Use](#how-to-use)
    - [How To Use](#how-to-use-1)
    - [Horizontal Zoom Report](#horizontal-zoom-report)
  - [Affective Cloud UI API](#affective-cloud-ui-api)

To facilitate user access, we provide a standard template for data display UI, which is divided into real-time data UI and report data UI.

## Demo

The Demo of the UI library contains the following components:

- [1.Real-time data presentation Demo](../EnterRealtimeUIDemo/)
- [2.Report data presentation Demo](../EnterReportUIDemo/)

[Heart Flow App](https://github.com/Entertech/Enter-AffectiveCloud-Demo-iOS.git) This demo application integrates basic Bluetooth functions, Bluetooth device management interface, affective cloud SDK, and custom data display controls, showing how the brain wave and heart rate data are collected from hardware and uploaded to affective cloud real-time analysis.

## Real-time Data UI

Take the heart rate as an example to show how to access the real-time UI.

### How To Use

```swift
let hrView = RealtimeHeartRateView()
// set property
hrView.bgColor = UIColor(red: 1, green: 229.0/255.0, blue: 231.0/255.0, alpha: 1)
hrView.mainColor = UIColor(red: 1, green: 72.0/255.0, blue: 82.0/255.0, alpha: 1)
self.view.addSubview(hrView)
hrView.snp.makeConstraints {
  $0.left.right.equalTo(16)
  $0.hight.equalTo(123) 
}

// start observe
hrView.observe()
```
<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/HeartRate2.png" width="300">

### How To Use

```swift

let attentionReportView = AttentionReportView()
self.view.addSubview(attentionReportView)
attentionReportView.snp.makeConstraints {
  $0.left.right.equalTo(16)
  $0.hight.equalTo(298)
}
// average
attentionReportView.avgValue = 78
// max
attentionReportView.maxValue = 99
// min
attentionReportView.minValue = 6
// report data array
attentionReportView.setDataFromModel(attention: intArray)

```

the function `setDataFromModel` has two parameters

| Parameter      | Type     | Description                       |
| --------- | -------- | -------------------------- |
| attention | [Int] | The attention array             |
| timestamp | Int      | Service start time  |

With timestamp:

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/Attention2.png" width="300">

### Horizontal Zoom Report

Click the zoom in button in the upper right corner to get a horizontal report.

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/IMG_C67F3DC6DCDB-1.jpeg" width="600">

## Affective Cloud UI API

- Look over: [Affective Cloud UI Document](../../APIDocuments/AffectiveCloudUI_EN.md)
