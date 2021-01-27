# Enter AffectiiveCloud iOS SDK

- [Enter AffectiiveCloud iOS SDK](#enter-affectiivecloud-ios-sdk)
  - [Demo](#demo)
  - [How To Use](#how-to-use)
    - [How To Instantiate](#how-to-instantiate)
    - [Subscription](#subscription)
    - [Data Upload](#data-upload)
    - [Get Report](#get-report)
    - [Protocol](#protocol)
    - [Affective Cloud Close](#affective-cloud-close)
  - [API Instructions](#api-instructions)

## Demo

[Heart Flow App](https://github.com/Entertech/Enter-AffectiveCloud-Demo-iOS.git) This demo application integrates basic Bluetooth functions, Bluetooth device management interface, Affective Cloud SDK, and custom data display controls. A good display of the whole process of brainwave and heart rate data from the hardware collection to the upload of Affective Cloud real-time analysis and finally the generation of analysis reports and data display.

## How To Use

> Just instantiate the class `AffectiveCloudClient`, then get the result of Affective Cloud analysis by the protocol  `AffectiveCloudResponseDelegate`.

### How To Instantiate

```swift
// AffectiveCloudClient Object
let client = AffectiveCloudClient(websocketURLString: yourURL, appKey: yourAppKey, appSecret: yourSecret, userID: yourLocalID)

```

| 参数               | 类型   | 说明                                  |
| ------------------ | ------ | ------------------------------------- |
| websocketURLString | String | Affective Cloud websocket url           |
| appKey             | String | Affective Cloud app key, contact the administrator    |
| appSecret          | String | Affective Cloud app secret，contact the administrator |
| userID             | String | the identity of your app， reference [id](https://docs.affectivecloud.com/%F0%9F%8E%99%E6%8E%A5%E5%8F%A3%E5%8D%8F%E8%AE%AE/3.%20%E4%BC%9A%E8%AF%9D%E5%8D%8F%E8%AE%AE.html#userID)                    |

### Subscription

```swift
// init biological data, uploadCycle is the upload interval, the unit time is 0.6 seconds, you can check parameters from documents
self.client.initBiodataServices(services: [.EEG, .HeartRate], uploadCycle:3 )

// init affective data
self.client.startAffectiveDataServices(services: [.attention, .relaxation, .pleasure, .pressure])

// subscribe biological data
self.client.subscribeBiodataServices(services: [.eeg, .hr])

// sbuscribe affective data
self.client.subscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
```

### Data Upload

```swift
// eeg data from Bluetooth hardware
func eegData() {
    ...
    self.client.appendBiodata(eegData: data)
}

// heart rate from Bluetooth hardware
func hrData() {
    ...
    self.client.appendBiodata(hrData: data)
}
```

### Get Report

```swift
// 获取生物数据报表
self.client.getBiodataReport(services: [.EEG, .HeartRate])

// 获取情感数据报表
self.client.getAffectiveDataReport(services: [.relaxation, .attention, .pressure, .pleasure])

```

### Protocol

```swift
self.client.affectiveCloudDelegate = self
```

Implement delegate method `AffectiveCloudResponseDelegate`:

```swift
// real-time biological data
func biodataServicesSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
    if response.code != 0 {
        return
    }
        
    if let data = response.dataModel as? CSBiodataProcessJSONModel {
        if let eeg = data.eeg {
        // eeg.waveLeft, eeg.waveRight, eeg.alpha..
        // 在此获取您需要的脑波数据
        }
        if let hr = data.hr {
        // 在此获取您需要的心率数据
        }
    }
}

// biological data report
func biodataServicesReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
    if response.code != 0 {
        return
    }
    if let data = response.dataModel as? CSBiodataReportJsonModel {
        if let hr = data.hr {
          // hr, hrv
        }
        if let eeg = data.eeg {
          // eeg
        }
    }
}

// real-time affective data
func affectiveDataSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
    if response.code != 0 {
        return
    }
        
    if let data = response.dataModel as? CSAffectiveSubscribeProcessJsonModel {
        if let attention = data.attention?.attention {
            print("attention \(attention)")
        }
        if let relaxation = data.relaxation?.relaxation {

        }
        if let pressure = data.pressure?.pressure {

        }
    }
}

// affective data report
func affectiveDataReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)  {
    guard response.code == 0 else {
        return
    }
    if let report = response.dataModel as? CSAffectiveReportJsonModel {
        if let attention = report.attention {
        // array, average
        }
        if let relaxation = report.relaxation {

        }
        if let pressure = report.pressure {
        }
    }
}
```

### Affective Cloud Close

```swift
// close client
self.client.close()

```

## API Instructions

- API documentation ：[Affective Cloud Documentation](../APIDocuments/Enter-AffectiveCloud-iOS-SDK-API.md)