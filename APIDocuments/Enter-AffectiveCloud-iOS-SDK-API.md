# Enter Affective Cloud SDK API Instructions

- [Enter Affective Cloud SDK API Instructions](#enter-affective-cloud-sdk-api-instructions)
  - [The Structure Of Affective Cloud](#the-structure-of-affective-cloud)
    - [Brief Introduction](#brief-introduction)
    - [Relationship Between Modules](#relationship-between-modules)
    - [Relationship Between Biological Data And Affective Data](#relationship-between-biological-data-and-affective-data)
  - [Affective Cloud Session（open, restore, close）](#affective-cloud-sessionopen-restore-close)
    - [Functions Description](#functions-description)
    - [Example](#example)
    - [Session Function Parameters](#session-function-parameters)
  - [Biological Data Analysis Service](#biological-data-analysis-service)
    - [Biological Data Analysis Functions Description](#biological-data-analysis-functions-description)
    - [Biological Data Service Demo Code](#biological-data-service-demo-code)
    - [Biodata Serivce Parameters](#biodata-serivce-parameters)
  - [Affective Data Analysis Services](#affective-data-analysis-services)
    - [Affective Data Analysis Functions Description](#affective-data-analysis-functions-description)
    - [Affective Data Serivice Demo Code](#affective-data-serivice-demo-code)
    - [Affective data Service Parameters](#affective-data-service-parameters)
    - [Delegate(AffectiveCloudResponseDelegate)](#delegateaffectivecloudresponsedelegate)

We will start from the following two aspects: `The Structure Of Affective Cloud` and `API Instructions`.

## The Structure Of Affective Cloud

We divide Affective Cloud into three parts of services. The first service is connection-related `Session`. The second service is Affective Cloud analysis of raw data `Biological Data`. And the third analysis of `Affective Data`。

### Brief Introduction

1. The Affective Cloud is divided into three modules: affective cloud session service (open, restore and close), basic biological data analysis service (bioData) and affective data service (AffectiveCloud service).
2. The biological data and affective data services will be available after the session is opened.
3. The corresponding affective data will receive after init biological service (.eeg and .hr).
4. The data of the affective cloud must be obtained through the agent.

### Relationship Between Modules

![](media/15644764106226/15656655529982.jpg)

### Relationship Between Biological Data And Affective Data

<table>
  <tr>
    <th>Biological Data Analysis Service </th>
    <th>Affective Service</th>
    <th>Description</th>
  </tr>
  <tr>
    <td rowspan = "2">Heart Rate（.hr）</td>
    <td>pressure</td>
    <td>pressure level (0-100)</td>
  </tr>
  <tr>
    <td>arousal</td>
    <td>arousal leve (0-100)</td>
  </tr>
  <tr>
    <td rowspan="3">EEG（.eeg）</td>
    <td>attention</td>
    <td>attention level (0-100)</td>
  </tr>
  <tr>
    <td>relaxation</td>
    <td>relaxation level (0-100)</td>
  </tr>
  <tr>
    <td>pleasure</td>
    <td>pleasure level (0-100)</td>
  </tr>
</table>

## Affective Cloud Session（open, restore, close）
After connecting to the websocket, session is created, and data is exchanged with the affective cloud computing platform in the session. Session (session) supports create, restore and close operations.

```swift
init(websocketURL: URL)
var affectiveCloudDelegate: AffectiveCloudResponseDelegate?
func createAndAuthenticateSession(appKey: String, appSecret: String, userID: String)
func restoreSession()
func closeSession()
```

### Functions Description

* `init(websocketURL: URL)` initialize Affective Cloud, After calling this method, Affective Cloud will establish a websocket connection. [Connection Address](https://docs.affectivecloud.com/🎙接口协议/1.%20综述.html#正式)。
* `affectiveCloudDelegate` The business layer obtains the returned data of the Affective Cloud through the delegate. More: [Affective Data](#jump6)。
* `createAndAuthenticateSession(...)` Create a session(session). This method must be called before using other services.
* `restoreSession()` This method restores the previous session connection after the Affective Cloud interruption (interruption caused by the network or other reasons). If the Affective Cloud is interrupted for more than 10 minutes, the session will be destroyed, and calling this method will be invalid. More: [Session Restore](https://docs.affectivecloud.com/🎙接口协议/3.%20会话协议.html#session-restore)。
* `closeSession()` After calling this method, the session will be closed, all open services will be closed, and the Affective Cloud connection will be disconnected.

### Example

```swift
import EnterAffectiveCloud

// init
func setup() {
    client = AffectiveCloudClient(wss: YOUR_WSS_URL)
    self.client.delegate = self //implement the delegate
}

// create session
func websocketState(client: AffectiveCloudClient, state: CSState) {
    ...
    if state == .connected {
        self.client.createAndAuthenticateSession(appKey: YourAppKey,
                                      appSecret: YourAppSecret,
                                      userID: YourUserID)
    }
}

...

// restore session
func restoreAction(_ sender: UIButton) {
    ...
    self.client.restoreSession()
}

// closeSession
func closeAction(_ sernder: UIButton) {
    ...
    self.client.closeSession()
}
```

### Session Function Parameters

|Parameter|Type|Description|
|:--:|:--:|:--:|
| websocketURL | String | Affective Cloud url |

|参数|类型|说明|
|:--:|:--:|:--:|
| appKey | String | App Key, request from administrator |
| appSecret | String | App Secret, request from administrator|
| userID | String | Your app ID(email, phone number, etc.)，it's unique。More: [userID](https://docs.affectivecloud.com/🎙接口协议/3.%20会话协议.html#userID) |

## Biological Data Analysis Service

Basic analysis service of biological data (EEG, HR, etc.). This part of the data is the data basis for affective data services. It is necessary to initialize and upload biological data before performing affective computing services.

```swift
func initBiodataServices(serivices: BiodataTypeOptions, uploadCycle: UInt = 3)
func appendBiodata(eegData: Data)
func appendBiodata(hrData: Data)
func subscribeBiodataServices(serivices: BiodataParameterOptions)
func unsubscribeBiodataServices(serivices: BiodataParameterOptions)
func getBiodataReport(services: BiodataTypeOptions)
```

### Biological Data Analysis Functions Description

* `initBiodataServices(serivices: BiodataTypeOptions, uploadCycle: UInt)`  depend on `Multiple parameters` [BiodataTypeOptions](#jump1) Used to initialize basic biological data analysis services, There are two biological data `EEG`和`Heart Rate`. And this method is also the basis for all Affective Cloud services (**MUST CALL THIS FUNCTION**)。`uploadCycle`: you need to read the [Enter Affective Cloud Documents](https://docs.affectivecloud.com/%F0%9F%8E%99%E6%8E%A5%E5%8F%A3%E5%8D%8F%E8%AE%AE/3.%20%E4%BC%9A%E8%AF%9D%E5%8D%8F%E8%AE%AE.html).
* `appendBiodata(eegData: Data)` This method adds the EEG data collected by hardware to the affective cloud, which is then analyzed by the algorithm in the emotion cloud and returns the corresponding EEG service data. `EnterBioModuleBLE` has EEG data callback。
* `appendBiodata(hrData: Data)` This method adds the heart rate data collected by the hardware to the emotion cloud, which is then analyzed by the algorithm in the emotion cloud and returns the corresponding heart rate service data. `EnterBioModuleBLE` has heart rate data callback。
* `subscribeBiodataServices(serivices: BiodataParameterOptions)` Parameter [BiodataParameterOptions](#jump2) request Affective Cloud to obtain basic biological data analysis services in real time, and obtain the desired data analysis services by subscription. After subscibing, there's callback from `AffectiveCloudResponseDelegate`
* `unsubscribeBiodataServices(serivices: BiodataParameterOptions)`  [BiodataParameterOptions](#jump2) Unsubscribe services
* `getBiodataReport(services: BiodataTypeOptions)`  [BiodataTypeOptions](#jump1) Request biological data with parameters

### Biological Data Service Demo Code

```swift
import EnterAffectiveCloud

// Biological Data Analysis Service init
func startBiodataServices() {
    self.client.initBiodataServices(services: [.EEG, .HeartRate]) 
    self.client.subscribeBiodataServices(services: [.eeg, .hr]) 
    ...
}

//  eeg data from Bluetooth hardware 
func eegData() {
    ...
    self.client.appendBiodata(eegData: data)
}

// heart rate from Bluetooth hardware
func hrData() {
    ...
    self.client.appendBiodata(hrData: data)
}

// unsubscribe biodata
func unsubscribeBiodataServices() {
    self.client.unsubscribeBiodataServices(services: [.eeg, .hr])
    ...
}

// get report
func getBiodataReport() {
    // generate report
    self.client.getBiodataReport(services: [.EEG, .HeartRate])
}
```

### Biodata Serivce Parameters

**<span id="jump1">Biological Data Type (BiodataTypeOptions)</span>**

|Parameter|Description|
|:--:|:--:|
| EEG | init EEG service |
| HeartRate | init heart rate service |

**<span id="jump2">Basic Biological Data Analysis Service (BiodataParameterOptions)</span>**

|Parameter|Description|
|:--:|:--:|
| eeg | subscribe EEG service |
| hr | subscribe heart rate service |

## Affective Data Analysis Services

According to the uploaded biological data, we can analyze different emotional data, and each emotional data corresponds to [Affective Data Services](#jump3)。

```swift
func startAffectiveDataServices(services: AffectiveDataServiceOptions)
func subscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)
func unsubscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)
func getAffectiveDataReport(services: AffectiveDataServiceOptions)
func finishAffectiveDataServices(services: AffectiveDataServiceOptions)
```

### Affective Data Analysis Functions Description

* `startAffectiveDataServices(services: AffectiveDataServiceOptions)` Parameter [AffectiveDataServiceOptions](#jump3) start affective data service.
* `getAffectiveDataReport(services: AffectiveDataServiceOptions)` Parameter [AffectiveDataServiceOptions](#jump3) get affective data report.
* `subscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)` Parameter [AffectiveDataSubscribeOptions](#jump4) subscribe affective data. after subscribing you can get data from `AffectiveCloudResponseDelegate` callback.
* `unsubscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)` Parameter [AffectiveDataSubscribeOptions](#jump4) unsubscribe affective data.
* `finishAffectiveDataServices(services: AffectiveDataServiceOptions)` Parameter[AffectiveDataServiceOptions](#jump3) close affective data service.

### Affective Data Serivice Demo Code

```swift
    // start affecive data service and subscribe
    func startEmotionServices() {
        self.client.startAffectiveDataServices(services: [.attention, .relaxation, .pleasure, .pressure])
        self.client.subscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
    }
    
    // get report and finish
    func finish() {
        ...
        self.client.getAffectiveDataReport(services: [.relaxation, .attention, .pressure, .pleasure])
        self.client.unsubscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
        self.client.finishAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
        ...
    }
```

### Affective data Service Parameters

**<span id="jump3">Affective Data Service（AffectiveDataServiceOptions）</span>**

|Parameter|Description|
|:--:|:--:|
| attention | attention service （by EEG）|
| relaxation | relaxation service （by EEG）|
| pleasure | pleasure service （by EEG）|
| pressure | pressure service （by heart rate）|
| arousal | arousal service （by heart rate）|
| sleep | check sleep (In development) |

**<span id="jump4">Affective Data Subscription（AffectiveDataSubscribeOptions）</span>**

| Cloud Service | Data Type) | Type | value | Description |
| :---: | :---: | :---: | :---: | :---: |
| attention | attention | float | [0, 100] | Attention value, higher value means higher attention |
| relaxation | relaxation | float | [0, 100] | Relaxation value, the higher the value, the higher the relaxation |
| pressure | pressure | float | [0, 100] | Pressure level value, the higher the value, the higher the pressure level |
| pleasure | pleasure | float | [0, 100] | Pleasure value, the higher the value, the higher the emotional pleasure |
| arousal | arousal | float | [0, 100] | Activation value, the higher the value, the higher the emotional activation |
| sleep | sleep_degree | float | [0, 100] | In development |
| | sleep_state | int | {0, 1} | 1 is in sleep (In development) |

### Delegate(AffectiveCloudResponseDelegate)

`AffectiveCloudResponseDelegate` Used to get data from delegate. There are four types of methods:

* session: Session service callback
* biodata: Biological data service callback
* affectiveData: Affective data service callback
* error: Error call back

```swift
// session
func sessionCreateAndAuthenticate(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func sessionRestore(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func sessionClose(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)

// bioData
func biodataServicesInit(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func biodataServicesSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func biodataServicesUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func biodataServicesUpload(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func biodataServicesReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)

// affectiveData
func affectiveDataStart(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func affectiveDataSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func affectiveDataUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func affectiveDataReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
func affectiveDataFinish(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)

// error
func error(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel?, error: AffectiveCloudResponseError, message: String?)
func error(client: AffectiveCloudClient, request: AffectiveCloudRequestJSONModel?, error: AffectiveCloudRequestError, message: String?)
```