# 情感云 SDK API 使用说明

- [情感云 SDK API 使用说明](#%e6%83%85%e6%84%9f%e4%ba%91-sdk-api-%e4%bd%bf%e7%94%a8%e8%af%b4%e6%98%8e)
  - [情感云结构](#%e6%83%85%e6%84%9f%e4%ba%91%e7%bb%93%e6%9e%84)
    - [使用需知](#%e4%bd%bf%e7%94%a8%e9%9c%80%e7%9f%a5)
    - [模块的逻辑关系](#%e6%a8%a1%e5%9d%97%e7%9a%84%e9%80%bb%e8%be%91%e5%85%b3%e7%b3%bb)
    - [生物数据与情感数据的对应关系](#%e7%94%9f%e7%89%a9%e6%95%b0%e6%8d%ae%e4%b8%8e%e6%83%85%e6%84%9f%e6%95%b0%e6%8d%ae%e7%9a%84%e5%af%b9%e5%ba%94%e5%85%b3%e7%b3%bb)
  - [情感云 session（开启、关闭和代理）](#%e6%83%85%e6%84%9f%e4%ba%91-session%e5%bc%80%e5%90%af%e5%85%b3%e9%97%ad%e5%92%8c%e4%bb%a3%e7%90%86)
    - [方法说明](#%e6%96%b9%e6%b3%95%e8%af%b4%e6%98%8e)
    - [示例代码](#%e7%a4%ba%e4%be%8b%e4%bb%a3%e7%a0%81)
    - [参数说明](#%e5%8f%82%e6%95%b0%e8%af%b4%e6%98%8e)
  - [基础生物数据分析服务](#%e5%9f%ba%e7%a1%80%e7%94%9f%e7%89%a9%e6%95%b0%e6%8d%ae%e5%88%86%e6%9e%90%e6%9c%8d%e5%8a%a1)
    - [方法说明](#%e6%96%b9%e6%b3%95%e8%af%b4%e6%98%8e-1)
    - [示例代码](#%e7%a4%ba%e4%be%8b%e4%bb%a3%e7%a0%81-1)
    - [参数说明](#%e5%8f%82%e6%95%b0%e8%af%b4%e6%98%8e-1)
  - [高级情绪情感数据分析服务](#%e9%ab%98%e7%ba%a7%e6%83%85%e7%bb%aa%e6%83%85%e6%84%9f%e6%95%b0%e6%8d%ae%e5%88%86%e6%9e%90%e6%9c%8d%e5%8a%a1)
    - [方法说明](#%e6%96%b9%e6%b3%95%e8%af%b4%e6%98%8e-2)
    - [示例代码](#%e7%a4%ba%e4%be%8b%e4%bb%a3%e7%a0%81-2)
    - [参数说明](#%e5%8f%82%e6%95%b0%e8%af%b4%e6%98%8e-2)
    - [获取情感云数据代理(AffectiveCloudResponseDelegate)](#%e8%8e%b7%e5%8f%96%e6%83%85%e6%84%9f%e4%ba%91%e6%95%b0%e6%8d%ae%e4%bb%a3%e7%90%86affectivecloudresponsedelegate)

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
func createAndAuthenticateSession(appKey: String, appSecret: String, userID: String)
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
                                      userID: YourUserID)
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
| userID | String | 你 app 当前用户的 id，如手机号、id 号，昵称等，需要保证唯一性。详见[userID](https://docs.affectivecloud.com/🎙接口协议/3.%20会话协议.html#userID) |

## 基础生物数据分析服务

生物数据（EEG、HR等）的基础分析服务。此部分数据为情感计算服务的数据基础。需要先初始化并上传生物数据，才能进行情感计算服务。

```
func initBiodataServices(serivices: BiodataTypeOptions, uploadCycle: UInt = 3)
func appendBiodata(eegData: Data)
func appendBiodata(hrData: Data)
func subscribeBiodataServices(serivices: BiodataParameterOptions)
func unsubscribeBiodataServices(serivices: BiodataParameterOptions)
func getBiodataReport(services: BiodataTypeOptions)
```

### 方法说明

* `initBiodataServices(serivices: BiodataTypeOptions, uploadCycle: UInt)`  这个方法根据`多选参数`  [BiodataTypeOptions](#jump1) 用来初始化基础生物数据分析服务，目前有两种生物数据：`脑电数据`和`心率数据`。同时这个方法也是后面所有服务的基础(**必须调用这个才有后面的服务**)。uploadCycle请参照[生物数据基础分析服务协议](https://docs.affectivecloud.com/%F0%9F%8E%99%E6%8E%A5%E5%8F%A3%E5%8D%8F%E8%AE%AE/3.%20%E4%BC%9A%E8%AF%9D%E5%8D%8F%E8%AE%AE.html)
* `appendBiodata(eegData: Data)` 这个方法向情感云添加硬件采集到的脑电数据，然后再由情感云中的算法分析，并返回相应的脑电服务数据。可以在 `EnterBioModuleBLE` 的脑电数据回调中直接调用。
* `appendBiodata(hrData: Data)` 这个方法向情感云添加硬件采集到的心率数据，然后再由情感云中的算法分析，并返回相应的心率服务数据。可以在 `EnterBioModuleBLE` 的脑电数据回调中直接调用。
* `subscribeBiodataServices(serivices: BiodataParameterOptions)` 这个方法根据`多选参数`  [BiodataParameterOptions](#jump2) 请求情感云实时获取基础生物数据分析服务，以订阅的方式获取想要的数据分析服务。订阅后根据代理`AffectiveCloudResponseDelegate` 获取服务数据。
* `unsubscribeBiodataServices(serivices: BiodataParameterOptions)` 这个方法根据`多选参数`  [BiodataParameterOptions](#jump2) 取消订阅对应的数据。
* `getBiodataReport(services: BiodataTypeOptions)` 这个方法根据`多选参数`  [BiodataTypeOptions](#jump1)向情感云请求获取生物数据类型报表。

### 示例代码

~~~swift
import EnterAffectiveCloud

// 开始基础生物数据分析
func startBiodataServices() {
    self.client.initBiodataServices(services: [.EEG, .HeartRate]) #初始化服务
    self.client.subscribeBiodataServices(services: [.eeg, .hr]) #订阅服务
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
    self.client.unsubscribeBiodataServices(services: [.eeg, .hr])
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

~~~swift
func startAffectiveDataServices(services: AffectiveDataServiceOptions)
func subscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)
func unsubscribeAffectiveDataServices(options: AffectiveDataSubscribeOptions)
func getAffectiveDataReport(services: AffectiveDataServiceOptions)
func finishAffectiveDataServices(services: AffectiveDataServiceOptions)
~~~

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

### 获取情感云数据代理(AffectiveCloudResponseDelegate)

`AffectiveCloudResponseDelegate` 用来获取情感云返回数据代理。里面包含四类方法： 

* session 会话相关代理方法
* biodata 生物数据
* affectiveData 情感数据
* error 错误处理

~~~swift
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
~~~
