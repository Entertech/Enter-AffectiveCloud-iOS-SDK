# Enter-AffectiveCloud-iOS-SDK

# 目录

* [目录](#目录)
* [SDK 说明](#SDK-说明)
  * [结构说明](#结构说明)
  * [安装集成](#安装集成)
    * [Cocoapods](#Cocoapods)
* [情感云 SDK API 使用说明](#情感云-SDK-API-使用说明)
    * [情感云结构](#情感云结构)
        * [使用需知](#使用需知)
        * [模块的逻辑关系](#模块的逻辑关系)
        * [生物数据与情感数据的对应关系](#生物数据与情感数据的对应关系)
    * [情感云 session（开启、关闭和代理）](#情感云-session (开启、关闭和代理))
        * [方法说明](#方法说明)
        * [示例代码](#示例代码)
        * [参数说明](#参数说明)
    * [基础生物数据分析服务](#基础生物数据分析服务)
        * [方法说明](#方法说明)
        * [示例代码](#示例代码)
        * [参数说明](#参数说明)
    * [高级情绪情感数据分析服务 ](#请求情感数据服务-(Affective-服务))
        * [方法说明](#方法说明)
        * [示例代码](#示例代码)
        * [参数说明](#参数说明)
    * [获取情感云数据代理(AffectiveCloudResponseDelegate)](#获取情感云数据代理(AffectiveCloudResponseDelegate))
  
# SDK 说明

回车情感云可以根据用户的脑波数据和心率数据来进行高级情绪情感数据分析的一个云算法平台，同时能给出包括：放松度、注意力、愉悦值，压力值、激动度（内测）在内的多种情绪情感值。详情请查看[官网](https://www.entertech.cn)。

在开始开发前，请先查看回车情感云的[开发文档](https://docs.affectivecloud.com)，了解情感云平台的架构和所能提供的服务具体说明，确定好你的应用中所需要的服务。你还需要联系管理员注册好测试应用，然后再进行开发。

为了方便你进行 iOS 平台的快速开发，我们提供了情感云快速开发 SDK，通过本 SDK 你可以快速地将情感云的能力集成到你的 app 中。

## 结构说明

业务层只需要实例化 `AffectiveCloudClient` 类就可以请求情感云数据，通过代理 `AffectiveCloudResponseDelegate` 来获取情感云分析后的结果。具体 `AffectiveCloudClient` 方法的功能介绍请看 [情感云 SDK API 使用说明](#情感云 SDK-API 使用说明)

![](media/15644764106226/15659273084519.jpg)


## 安装集成
### Cocoapods

添加下面内容到你的 Podfile。

~~~ruby
# 指定 pod 仓库源
source 'git@github.com:EnterTech/PodSpecs.git'

target 'Your Target' do
    pod 'EnterAffectiveCloud', '~> 1.0.0'
end
~~~

运行 `pod  install` 安装命令.

# 情感云 SDK API 使用说明

我们将会从下面`情感云结构`和 `API 说明`两个方面展开。

## 情感云结构

从服务的角度，我们将情感云分为三类服务，第一种服务是与连接相关的 `session 服务`，第二种服务是情感云分析原始数据的`基础生物数据分析服务`和第三种情感云分析情感数据的`情感数据服务`。

### 使用需知

1. 情感云分为三大模块：情感云 session 服务（开启、恢复和关闭）、基础生物数据分析服务（bioData）和情感数据服务 （AffectiveCloud 服务）
2. 必须开启会话（session）后，才会有生物数据处理和情感数据处理服务。
3. 必须开启对应的生物数据处理服务（.eeg 和 .hr）才会有情感云情感数据；而且不同的生物数据对应不同的情感数据。
4. 获取情感云的返回数据必须通过 delegate 来获取。

### 模块的逻辑关系

![](media/15644764106226/15656655529982.jpg)

### 生物数据与情感数据的对应关系

<table>
  <tr>
    <th>基础生物数据分析服务</th>
    <th>情感数据服务</th>
    <th>说明</th>
  </tr>
  <tr>
    <td rowspan = "2">心率数据服务（.hr）</td>
    <td>pressure</td>
    <td>压力值：表示您的压力水平</td>
  </tr>
  <tr>
    <td>arousal</td>
    <td>激活度：表示您的激动水平</td>
  </tr>
  <tr>
    <td rowspan="3">脑电数据服务（.eeg）</td>
    <td>attention</td>
    <td>专注度：表示您的专注水平</td>
  </tr>
  <tr>
    <td>relaxation</td>
    <td>放松度：表示您的放松水平</td>
  </tr>
  <tr>
    <td>pleasure</td>
    <td>愉悦度：表示您的愉悦水平</td>
  </tr>
</table>

## 情感云 session（开启、关闭和代理）
连接 websocket 之后，然后创建会话（session），在会话中与情感云计算平台进行数据交互。会话（session）支持创建、恢复和关闭操作。

```swift
init(websocketURL: URL)
var affectiveCloudDelegate: AffectiveCloudResponseDelegate?
func createAndAuthenticateSession(appKey: String, appSecret: String, userID: String, timestamp: String)
func restoreSession()
func closeSession()
```

### 方法说明

* `init(websocketURL: URL)` 初始化情感云，在调用这个方法后，会情感云建立 websocket 连接，[链接地址](https://docs.affectivecloud.com/🎙接口协议/1.%20综述.html#正式)。 
* `affectiveCloudDelegate` 业务层通过这个代理获取情感云的返回数据，详情请参见[获取情感云数据](#jump6)。
* `createAndAuthenticateSession(...)` 创建一个会话（session），并且进行认证。在使用其他服务前必须使用调用这个方法。
* `restoreSession()` 这个方法在情感云中断（网络或者其他原因导致的中断）后恢复之前的 session 连接。如果情感云中断时间超过 10 min, 会话将会被销毁，调用该方法无效将无效，详见[会话保留](https://docs.affectivecloud.com/🎙接口协议/3.%20会话协议.html#session-restore)。
* `closeSession()` 调用这个方法后会关闭会话，所有已开启的服务将会被关闭，并且会断开情感云连接。

### 示例代码

~~~swift
import EnterAffectiveCloud

// 初始化情感云
func setup() {
    client = AffectiveCloudClient(wss: YOUR_WSS_URL)
    self.client.delegate = self //implement the delegate
}

// 在 AffectiveCloudResponseDelegate 代理方法 websocketState(...) 中开启情感云
func websocketState(client: AffectiveCloudClient, state: CSState) {
    ...
    if state == .connected {
        self.client.createAndAuthenticateSession(appKey: YourAppKey,
                                      appSecret: YourAppSecret,
                                      userID: YouruserID,
                                      timestamp: currentTimestamp)
    }
}

...

// restore 操作
func restoreAction(_ sender: UIButton) {
    ...
    self.client.restoreSession()
}

// 结束服务，关闭会话，在所有服务结束后需要调用 closeSession
func closeAction(_ sernder: UIButton) {
    ...
    self.client.closeSession()
}
~~~

### 参数说明

|参数|类型|说明|
|:--:|:--:|:--:|
| websocketURL | String | 情感云服务器链接 |

|参数|类型|说明|
|:--:|:--:|:--:|
| appKey | String | 由我们后台生成的：App Key |
| appSecret | String | 由我们后台生成的：App Secret|
| userID | String | 你 app 当前用户的 id，详见[userID](https://docs.affectivecloud.com/🎙接口协议/3.%20会话协议.html#userID) |
| timestamp | String | 当前的 unix 时间戳 |


## 基础生物数据分析服务

生物数据（EEG、HR等）的基础分析服务。此部分数据为情感计算服务的数据基础。需要先初始化并上传生物数据，才能进行情感计算服务。

```
func initBiodataServices(serivices: BiodataTypeOptions)
func appendBiodata(eegData: [UInt8])
func appendBiodata(hrData: [UInt8])
func subscribeBiodataServices(serivices: BiodataParameterOptions)
func unsubscribeBiodataServices(serivices: BiodataParameterOptions)
func getBiodataReport(services: BiodataTypeOptions)
```

### 方法说明

* `initBiodataServices(serivices: BiodataTypeOptions)`  这个方法根据`多选参数`  [BiodataTypeOptions](#jump1) 用来初始化基础生物数据分析服务，目前有两种生物数据：`脑电数据`和`心率数据`。同时这个方法也是后面所有服务的基础(**必须调用这个才有后面的服务**)。
* `appendBiodata(eegData: Data)` 这个方法向情感云添加硬件采集到的脑电数据，然后再由情感云中的算法分析，并返回相应的脑电服务数据。可以在 `EnterBioModuleBLE` 的脑电数据回调中直接调用。
* `appendBiodata(hrData: Data)` 这个方法向情感云添加硬件采集到的心率数据，然后再由情感云中的算法分析，并返回相应的心率服务数据。可以在 `EnterBioModuleBLE` 的脑电数据回调中直接调用。
* `subscribeBiodataServices(serivices: BiodataParameterOptions)` 这个方法根据`多选参数`  [BiodataParameterOptions](#jump2) 请求情感云实时获取基础生物数据分析服务，以订阅的方式获取想要的数据分析服务。订阅后根据代理`AffectiveCloudResponseDelegate` 获取服务数据。
* `unsubscribeBiodataServices(serivices: BiodataParameterOptions)` 这个方法根据`多选参数`  [BiodataParameterOptions](#jump2) 取消订阅对应的数据。
* `getBiodataReport(services: BiodataTypeOptions)` 这个方法根据`多选参数`  [BiodataTypeOptions](#jump1)向情感云请求获取生物数据类型报表。

### 示例代码

~~~ swift
import EnterAffectiveCloud

// 开始基础生物数据分析
func startBiodataServices() {
    self.client.initBiodataServices(services: [.EEG, .HeartRate]) #初始化服务
    self.client.subscribeBiodataServices(services: [.eeg_all, .hr_all]) #订阅服务
    ...
}

// 原始脑电数据：硬件监听方法
func eegData() {
    ...
    self.client.appendBiodata(eegData: data)
}

// 心率数据： 硬件监听方法
func hrData() {
    ...
    self.client.appendBiodata(hrData: data)
}

// 取消订阅服务数据
func unsubscribeBiodataServices() {
    self.client.unsubscribeBiodataServices(services: [.eeg_all, .hr_all])
    ...
}

// 获取报告
func getBiodataReport() {
    // generate report
    self.client.getBiodataReport(services: [.EEG, .HeartRate])
}
~~~

### 参数说明

**<span id="jump1">生物数据类型（BiodataTypeOptions）</span>**

|名称|说明|
|:--:|:--:|
| EEG | 脑波数据 |
| HeartRate | 心率数据 |

**<span id="jump2">基础生物数据分析服务（BiodataParameterOptions）</span>**

|名称|说明|
|:--:|:--:|
| eeg_wave_left | 脑电波：左通道脑波数据 |
| eeg_wave_right | 脑电波：右通道脑波数据 |
| eeg_alpha | 脑电波频段能量：α 波 |
| eeg_beta | 脑电波频段能量：β 波 |
| eeg_theta | 脑电波频段能量：θ 波 |
| eeg_delta | 脑电波频段能量：δ 波 |
| eeg_gamma | 脑电波频段能量：γ 波 |
| eeg_quality | 脑电波数据质量 |
| hr_value | 心率 |
| hr_variability | 心率变异性 |
| eeg_all | 所有脑波数据服务（包含上面所有 `eeg_` 开头的服务）|
| hr_all | 所有心率数据服务 （包含上面所有 `hr_` 开头的服务）|

## 高级情绪情感数据分析服务 

根据上传的生物数据，我们可以分析出不同的情感数据，每种情感数据对应 [情感数据服务](#jump3)。

```
func startAffectiveDataServices(services: AffectiveDataServiceOptions)
func subscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)
func unsubscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)
func getAffectiveDataReport(services: AffectiveDataServiceOptions)
func finishAffectiveDataServices(services: AffectiveDataServiceOptions)
```

### 方法说明

* `startAffectiveDataServices(services: AffectiveDataServiceOptions)` 这个方法根据`多选参数` [AffectiveDataServiceOptions](#jump3) 开启情感分析服务，是获取实时分析数据和获取报表数据的基础。
* `getAffectiveDataReport(services: AffectiveDataServiceOptions)` 这个方法根据`多选参数` [AffectiveDataServiceOptions](#jump3) 向情感云请求情感数据的报表。
* `subscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)` 这个方法根据`多选参数` [AffectiveDataSubscribeOptions](#jump4) 向情感云获取对应的`实时情感数据服务`，以订阅的方式获取数据。订阅后根据代理 `AffectiveCloudResponseDelegate` 获取服务数据。
* `unsubscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)` 这个方法根据`多选参数` [AffectiveDataSubscribeOptions](#jump4) 向情感云取消订阅情感数据服务。取消订阅后`情感云`停止返回实时数据。
* `finishAffectiveDataServices(services: AffectiveDataServiceOptions)`这个方法根据`多选参数` [AffectiveDataServiceOptions](#jump3) 关闭情感服务。

### 示例代码 

~~~ swift
    // 开启情感数据服务
    func startEmotionServices() {
        self.client.startAffectiveDataServices(services: [.attention, .relaxation, .pleasure, .pressure])
        self.client.subscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
    }
    
    // 结束体验
    func finish() {
        ...
        self.client.getAffectiveDataReport(services: [.relaxation, .attention, .pressure, .pleasure])
        self.client.unsubscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
        self.client.finishAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
        ...
    }
~~~

### 参数说明

**<span id="jump3">情感数据服务（AffectiveDataServiceOptions）</span>**

|名称|说明|
|:--:|:--:|
| attention | 专注度服务 （依赖脑波数据）|
| relaxation | 放松度服务 （依赖脑波数据）|
| pleasure | 愉悦度服务 （依赖脑波数据）|
| pressure | 压力水平服务 （依赖心率数据）|
| arousal | 激活度服务 （依赖心率数据）|
| sleep | 睡眠检测和判断服务 |

**<span id="jump4">情感数据订阅服务（AffectiveDataSubscribeOptions）</span>**

| 服务类型(cloud_service) | 数据类型(data_type) | 类型 | 取值范围 | 说明 |
| :---: | :---: | :---: | :---: | :---: |
| attention | attention | float | [0, 100] | 注意力值，数值越高代表注意力越高 |
| relaxation | relaxation | float | [0, 100] | 放松度值，数值越高代表放松度越高 |
| pressure | pressure | float | [0, 100] | 压力水平值，数值越高代表压力水平越高 |
| pleasure | pleasure | float | [0, 100] | 愉悦度值，数值越高代表情绪愉悦度越高 |
| arousal | arousal | float | [0, 100] | 激活度值，数值越高代表情绪激活度越高 |
| sleep | sleep_degree | float | [0, 100] | 睡眠程度，数值越小代表睡得越深 |
| | sleep_state | int | {0, 1} | 睡眠状态，0 表示未入睡，1 表示已入睡 |

### <span id = "jump6">获取情感云数据代理(AffectiveCloudResponseDelegate)<span>

`AffectiveCloudResponseDelegate` 用来获取情感云返回数据代理。里面包含四类方法： 

* session 会话相关代理方法
* biodata 生物数据
* affectiveData 情感数据
* error 错误处理

~~~swift
// session
func createAndAuthenticateSession(response: affectiveCloudResponseJSONModel)
func restoreSession(response: affectiveCloudResponseJSONModel)
func closeSession(response: affectiveCloudResponseJSONModel)

// bioData
func initBiodataServices(response: affectiveCloudResponseJSONModel)
func subscribeBiodataServices(response: affectiveCloudResponseJSONModel)
func unsubscribeBiodataServices(response: affectiveCloudResponseJSONModel)
func appendBiodata(response: affectiveCloudResponseJSONModel)
func getBiodataReport(response: affectiveCloudResponseJSONModel)

// affectiveData
func startAffectiveDataServices(response: affectiveCloudResponseJSONModel)
func subscribeAffectiveDataServices(response: affectiveCloudResponseJSONModel)
func unsubscribeAffectiveDataServices(response: affectiveCloudResponseJSONModel)
func getAffectiveDataReport(response: affectiveCloudResponseJSONModel)
func finishAffectiveDataServices(response: affectiveCloudResponseJSONModel)

// error
func error(response: affectiveCloudResponseJSONModel?, error: affectiveCloudResponseError, message: String?)
func error(request: affectiveCloudRequestJSONModel?, error: affectiveCloudRequestError, message: String?)
~~~
