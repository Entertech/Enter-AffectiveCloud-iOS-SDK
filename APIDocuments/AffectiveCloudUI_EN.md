# Affective Cloud UI API

- [Affective Cloud UI API](#affective-cloud-ui-api)
  - [Real-time Data UI](#real-time-data-ui)
    - [Real-time Heart Rate](#real-time-heart-rate)
      - [Parameters](#parameters)
      - [Function](#function)
    - [Real-time Heart Rate Variability](#real-time-heart-rate-variability)
      - [Parameters](#parameters-1)
      - [Function](#function-1)
    - [Real-time Attention/Relaxation/Pressure/ArousalView/coherence](#real-time-attentionrelaxationpressurearousalviewcoherence)
      - [Parameters](#parameters-2)
      - [Function](#function-2)
    - [Real-time Brainwave Spectrum](#real-time-brainwave-spectrum)
      - [Parameters](#parameters-3)
      - [Function](#function-3)
    - [Real-time Brainwave Spectrum](#real-time-brainwave-spectrum-1)
      - [Parameters](#parameters-4)
      - [Function](#function-4)
  - [Report Data UI](#report-data-ui)
    - [Brainwave Spectrum Report](#brainwave-spectrum-report)
      - [Parameters](#parameters-5)
      - [Function](#function-5)
    - [Heart Rate Report](#heart-rate-report)
      - [Parameters](#parameters-6)
      - [Function](#function-6)
    - [Heart Rate Variability Report](#heart-rate-variability-report)
      - [Parameters](#parameters-7)
      - [Function](#function-7)
    - [Relaxation Report](#relaxation-report)
      - [Parameters](#parameters-8)
      - [Function](#function-8)
    - [Attention report](#attention-report)
      - [Parameters](#parameters-9)
      - [Function](#function-9)
    - [Pressure Report](#pressure-report)
      - [Parameters](#parameters-10)
      - [Function](#function-10)

> The Affective Cloud UI is divided into two parts, the real-time data display UI and the report data UI, and the required part can be selected.
> All UI inherits from UIView, you can define the required Layer yourself, and we also provide some parameters for you to choose the UI style.

## Real-time Data UI

### Real-time Heart Rate

> RealtimeHeartRateView

#### Parameters

Suitable View height: 123

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010145121952.png" width="300">

| Parameter               | Type    | Defaults                         | Description                                                                                                                                  |
| ------------------ | ------- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| mainColor          | UIColor | `#0064FF`                      | Main color (default value is RGB display color, UIColor(red: 0x23/255.0, green: 0x23/255.0, blue: 0x3a/255.0, alpha: 1), alpha must be 1, the same below) |
| textColor          | UIColor | `#FFFFFF`                      | Font color                                                                                                                               |
| bgColor            | UIColor | `#000000`                      | Background color                                                                                                                                |
| borderRadius       | CGFloat | 8.0                            | Border radius                                                                                                                |
| isShowExtremeValue | Bool    | true                           | Whether to display the maximum and minimum heart rate                                                                                                           |
| isShowInfoIcon     | Bool    | true                           | Whether to display the'description' icon                                                                                                               |
| infoUrlString      | String  | `"https://demo.entertech.com"` | Real-time data description web link                                                                                                                   |
| buttonImageName    | String  | `"info_button_icon"`           | Button image                                                                                                                             |
| title              | String  | `"心率"`                       | Title                                                                                             |

#### Function

Turn on monitoring: `observe()`

### Real-time Heart Rate Variability

> RealtimeHRVView

#### Parameters

Suitable View height: 123

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010145121953.png" width="300">

| Parameter              | Type    | Defaults                        | Description                                                                                                                                 |
| ------------------ | ------- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| mainColor          | UIColor | `#0064FF`                      | Main color (default value is RGB display color, UIColor(red: 0x23/255.0, green: 0x23/255.0, blue: 0x3a/255.0, alpha: 1), alpha must be 1, the same below) |
| textColor          | UIColor | `#FFFFFF`                      | Font color                                                                                                                                     |
| bgColor            | UIColor | `#000000`                      | Background color                                                                                                                                |
| lineColor          | UIColor | `#FF563B`                      | Line Color                                                                                                                              |
| borderRadius       | CGFloat | 8.0                            | Border Radius                                                                                                                                  |
| isShowExtremeValue | Bool    | true                           | Whether to display the maximum and minimum heart rate                                                 |
| isShowInfoIcon     | Bool    | true                           | Whether to display the'description' icon                                                                                                |
| infoUrlString      | String  | `"https://demo.entertech.com"` | Real-time data description web link                                                                                                     |
| buttonImageName    | String  | `"info_button_icon"`           | Button image                                                                                                    |
| title              | String  | `"心率变异性"`                 | Title                                                                                                                                   |

#### Function

Turn on monitoring: `observe()`

### Real-time Attention/Relaxation/Pressure/ArousalView/coherence

> RealtimeAttentionView / RealtimeRelaxationView / RealtimePressureView / RealtimeArousalView / RealtimeCoherenceView

#### Parameters

Suitable View height: 152

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010145415901.png" width="300">

| Parameter            | Type    | Defaults                          | Description                 |
| --------------- | ------- | ------------------------------ | -------------------- |
| mainColor       | UIColor | `#0064FF`                      | Main color                |
| textColor       | UIColor | `#FFFFFF`                      | Font color             |
| bgColor         | UIColor | `#000000`                      | Background Color                 |
| borderRadius    | CGFloat | 8.0                            | Border Radius                |
| isShowInfoIcon  | Bool    | true                           | Whether to display the'description' icon      |
| infoUrlString   | String  | `"https://demo.entertech.com"` | Real-time data description web link                 |
| buttonImageName | String  | `"info_button_icon"`           | Button image                   |
| title           | String  | `"注意力"`                     | Title                    |

#### Function

Turn on monitoring: `observe()`

### Real-time Brainwave Spectrum

> RealtimeBrainwaveSpectrumView

#### Parameters

Suitable View height: 232

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010150032042.png" width="300">

| Parameter            | Type    | Defaults                           | Description              |
| --------------- | ------- | ------------------------------ | -------------------- |
| mainColor       | UIColor | `#0064FF`                      | Main color                |
| textColor       | UIColor | `#FFFFFF`                      | Text color             |
| textFont        | String  | `"PingFangSC-Semibold"`        | Font                |
| bgColor         | UIColor | `#000000`                      | Background Color               |
| borderRadius    | CGFloat | 8.0                            | Border Radius                    |
| isShowInfoIcon  | Bool    | true                           | Whether to display the'description' icon   |
| infoUrlString   | String  | `"https://demo.entertech.com"` | Real-time data description web link       |
| buttonImageName | String  | `"info_button_icon"`           | Button image                 |
| title           | String  | `"脑波频谱"`                   | Title                   |

#### Function

Turn on monitoring: `observe()`

### Real-time Brainwave Spectrum

> RealtimeBrainwaveView

#### Parameters

Suitable View height: 321

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010150729231.png" width="300">

| Parameter                | Type      | Defaults                       | Description            |
| ----------------------- | ------- | ------------------------------ | -------------------- |
| mainColor               | UIColor | `#0064FF`                      | Main color                |
| textColor               | UIColor | `#FFFFFF`                      | Text color         |
| textFont                | String  | `"PingFangSC-Semibold"`        | Font                  |
| bgColor                 | UIColor | `#000000`                      | Background Color              |
| borderRadius            | CGFloat | 8.0                            | Border Radius               |
| isShowInfoIcon          | boolean | true                           | Whether to display the'description' icon  |
| leftBrainwaveLineColor  | UIColor | `#FF4852`                      | Left brain wave curve color    |
| rightBrainwaveLineColor | UIColor | `#0064FF`                      | Right brain wave curve color   |
| infoUrlString           | String  | `"https://demo.entertech.com"` | Real-time data description web link |
| buttonImageName         | String  | `"info_button_icon"`           | Button image         |
| title                   | String  | `"实时脑电波"`                 | Title                 |

#### Function

Turn on monitoring:`observe()`

## Report Data UI

### Brainwave Spectrum Report

> AffectiveChartBrainSpectrumView

#### Parameters

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014140326307.png" width="300">

| Parameter         | Type       | Defaults                               | Description                         |
| -------------- | --------- | ------------------------------------------- | ----------------------------------- |
| textColor      | UIColor   | `#FFFFFF`                                   | Text Color                          |
| bgColor        | UIColor   | `#000000`                                   | Background Color                                 |
| spectrumColors | [UIColor] | `[#23233A,#23233A,#23233A,#23233A,#23233A]` | Each proportion of the color, once corresponding to γ, β, α, θ, δ |
| cornerRadius   | CGFloat   | 8                                           | Border Radius                                |
| title          | String    | `"脑波频谱"`                                | Title                                  |

#### Function

Settings `setDataFromModel(gama: [Float], delta: [Float], theta: [Float], alpha: [Float], beta: [Float], timestamp: Int? = nil)`
| Parameter      | Type    | Description                                         |
| --------- | ------- | -------------------------------------------- |
| gama      | [Float] | gama array                                   |
| delta     | [Float] | delta array                                  |
| theta     | [Float] | theta array                                  |
| alpha     | [Float] | alpha  array                                 |
| beta      | [Float] | beta array                                   |
| timestamp | Int?     | The starting time of the affective cloud, used to calculate the list time, the default is empty|


### Heart Rate Report

> AffectiveChartHeartRateView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014141340894.png" width="300">

#### Parameters

| Parameter         | Type    | Defaults      | Description         |
| ------------ | ------- | ----------- | ------------ |
| textColor    | UIColor | `#FFFFFF`   | Text Color       |
| bgColor      | UIColor | `#000000`   | Background Color         |
| hrAvg        | Int     | nil         | Display average   |
| lineColor    | UIColor | [`#FF6682`] | Heart rate curve color |
| cornerRadius | CGFloat | 8           | Border Radius       |
| title        | String  | `"心率"`    | Title        |

#### Function

Settings `setDataFromModel(hr: [Int]?, timestamp: Int? = nil)`
| Parameter      | Type  | Description                                         |
| --------- | ----- | -------------------------------------------- |
| hr        | [Int] | Heart rate report array                       |
| timestamp | Int   | The starting time of the affective cloud, used to calculate the list time, the default is empty |

### Heart Rate Variability Report

> AffectiveChartHRVView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014141910905.png" width="300">

#### Parameters

| Parameter         | Type    | Defaults         | Description         |
| ------------ | ------- | -------------- | ------------ |
| textColor    | UIColor | `#FFFFFF`      | Text Color     |
| bgColor      | UIColor | `#000000`      | Background Color        |
| hrvAvg       | Int     | nil            | Display average    |
| lineColor    | UIColor | [`#FF6682`]    | Heart rate variability curve color |
| cornerRadius | CGFloat | 8              | Border Radius        |
| title        | String  | `"心率变异性"`   | Title          |

#### Function

Settings `setDataFromModel(hrv: [Int]?, timestamp: Int? = nil)`

| Parameter      | Type  | Description                                         |
| --------- | ----- | -------------------------------------------- |
| hrv       | [Int] | Heart rate variability report array                 |
| timestamp | Int   | The starting time of the affective cloud, used to calculate the list time, the default is empty |

### Relaxation Report

> AffectiveChartRelaxationView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014142421739.png" width="300">

#### Parameters

| Parameter            | Type    | Defaults               | Description                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| textColor    | UIColor | `#FFFFFF`      | Text Color     |
| bgColor      | UIColor | `#000000`      | Background Color        |
| avg       | Int     | nil            | Display average    |
| lineColor    | UIColor | [`#FF6682`]    | Curve color |
| cornerRadius | CGFloat | 8              | Border Radius       |
| title        | String  | `"放松度"` | Title        |

#### Function

Attention report `setDataFromModel(relaxation: [Int]?, timestamp: Int? = nil)`

| Parameter      | Type  | Description                                         |
| --------- | ----- | -------------------------------------------- |
| attention | [Int] | Relaxation report array                              |
| timestamp | Int   | The starting time of the affective cloud, used to calculate the list time, the default is empty |

### Attention report

> AffectiveChartAttentionView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014142421740.png" width="300">

#### Parameters

| Parameter            | Type    | Defaults               | Description                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| textColor    | UIColor | `#FFFFFF`      | Text Color   |
| bgColor      | UIColor | `#000000`      | Background Color        |
| avg       | Int     | nil            | Display average    |
| lineColor    | UIColor | [`#FF6682`]    | Curve color  |
| cornerRadius | CGFloat | 8              | Border Radius      |
| title        | String  | `"注意力"` | Title      |

#### Function

Attention report `setDataFromModel(attention: [Int]?, timestamp: Int? = nil)`

| Parameter      | Type  | Description                                         |
| --------- | ----- | -------------------------------------------- |
| attention | [Int] | Attention report array                               |
| timestamp | Int   | The starting time of the affective cloud, used to calculate the list time, the default is empty |

### Pressure Report

> AffectiveChartPressureView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014142733860.png" width="300">

#### Parameters

| Parameter            | Type    | Defaults               | Description                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| textColor    | UIColor | `#FFFFFF`      | Text Color    |
| bgColor      | UIColor | `#000000`      | Background Color       |
| avg       | Int     | nil            | Display average   |
| lineColor    | UIColor | [`#FF6682`]    | Curve color  |
| cornerRadius | CGFloat | 8              | Border Radius        |
| title        | String  | `"压力值"` | Title         |

#### Function

设置值`setDataFromModel(pressure: [Float]?, timestamp: Int? = nil)`

| Parameter      | Type       | Description                                         |
| --------- | ---------- | -------------------------------------------- |
| pressure  | [pressure] | Pressure report array                               |
| timestamp | Int        | The starting time of the affective cloud, used to calculate the list time, the default is empty |