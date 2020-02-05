# 情感云UI

> 情感云UI分两部分, 实时数据展示UI和报表数据UI, 可选用需要的部分。
> 所有UI继承自UIView, 可自己定义需要的Layer, 我们也提供了一些参数给您可以选择UI样式。

- [情感云UI](#%e6%83%85%e6%84%9f%e4%ba%91ui)
  - [实时数据UI](#%e5%ae%9e%e6%97%b6%e6%95%b0%e6%8d%aeui)
    - [实时心率](#%e5%ae%9e%e6%97%b6%e5%bf%83%e7%8e%87)
      - [参数](#%e5%8f%82%e6%95%b0)
      - [方法](#%e6%96%b9%e6%b3%95)
    - [实时心率变异性](#%e5%ae%9e%e6%97%b6%e5%bf%83%e7%8e%87%e5%8f%98%e5%bc%82%e6%80%a7)
      - [参数](#%e5%8f%82%e6%95%b0-1)
      - [方法](#%e6%96%b9%e6%b3%95-1)
    - [实时注意力/放松度/压力值/激活度/和谐度](#%e5%ae%9e%e6%97%b6%e6%b3%a8%e6%84%8f%e5%8a%9b%e6%94%be%e6%9d%be%e5%ba%a6%e5%8e%8b%e5%8a%9b%e5%80%bc%e6%bf%80%e6%b4%bb%e5%ba%a6%e5%92%8c%e8%b0%90%e5%ba%a6)
      - [参数](#%e5%8f%82%e6%95%b0-2)
      - [方法](#%e6%96%b9%e6%b3%95-2)
    - [实时脑波频谱](#%e5%ae%9e%e6%97%b6%e8%84%91%e6%b3%a2%e9%a2%91%e8%b0%b1)
      - [参数](#%e5%8f%82%e6%95%b0-3)
      - [方法](#%e6%96%b9%e6%b3%95-3)
    - [实时脑波](#%e5%ae%9e%e6%97%b6%e8%84%91%e6%b3%a2)
      - [参数](#%e5%8f%82%e6%95%b0-4)
      - [方法](#%e6%96%b9%e6%b3%95-4)
  - [报表数据UI](#%e6%8a%a5%e8%a1%a8%e6%95%b0%e6%8d%aeui)
    - [脑波频谱报表](#%e8%84%91%e6%b3%a2%e9%a2%91%e8%b0%b1%e6%8a%a5%e8%a1%a8)
      - [参数](#%e5%8f%82%e6%95%b0-5)
      - [方法](#%e6%96%b9%e6%b3%95-5)
    - [心率报表](#%e5%bf%83%e7%8e%87%e6%8a%a5%e8%a1%a8)
      - [参数](#%e5%8f%82%e6%95%b0-6)
      - [方法](#%e6%96%b9%e6%b3%95-6)
    - [心率变异性报表](#%e5%bf%83%e7%8e%87%e5%8f%98%e5%bc%82%e6%80%a7%e6%8a%a5%e8%a1%a8)
      - [参数](#%e5%8f%82%e6%95%b0-7)
      - [方法](#%e6%96%b9%e6%b3%95-7)
    - [放松度报表](#%e6%94%be%e6%9d%be%e5%ba%a6%e6%8a%a5%e8%a1%a8)
      - [参数](#%e5%8f%82%e6%95%b0-8)
      - [方法](#%e6%96%b9%e6%b3%95-8)
    - [注意力报表](#%e6%b3%a8%e6%84%8f%e5%8a%9b%e6%8a%a5%e8%a1%a8)
      - [参数](#%e5%8f%82%e6%95%b0-9)
      - [方法](#%e6%96%b9%e6%b3%95-9)
    - [压力报表](#%e5%8e%8b%e5%8a%9b%e6%8a%a5%e8%a1%a8)
      - [参数](#%e5%8f%82%e6%95%b0-10)
      - [方法](#%e6%96%b9%e6%b3%95-10)

## 实时数据UI

### 实时心率

> RealtimeHeartRateView

#### 参数

合适View高度: 123

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010145121952.png" width="300">

| 参数               | 类型    | 默认值                         | 说明                                                                                                                                   |
| ------------------ | ------- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| mainColor          | UIColor | `#0064FF`                      | 主色(默认值为RGB显示颜色，如此处对应的是`UIColor(red: 0x23/255.0, green: 0x23/255.0, blue: 0x3a/255.0, alpha: 1)`，alpha必须为1，下同) |
| textColor          | UIColor | `#FFFFFF`                      | 字体颜色                                                                                                                               |
| bgColor            | UIColor | `#000000`                      | 背景色                                                                                                                                 |
| borderRadius       | CGFloat | 8.0                            | 圆角                                                                                                                                   |
| isShowExtremeValue | Bool    | true                           | 是否显示心率最大最小值                                                                                                                 |
| isShowInfoIcon     | Bool    | true                           | 是否显示‘说明’图标                                                                                                                     |
| infoUrlString      | String  | `"https://demo.entertech.com"` | 实时数据说明网页链接                                                                                                                   |
| buttonImageName    | String  | `"info_button_icon"`           | 按钮图片                                                                                                                               |
| title              | String  | `"心率"`                       | 标题                                                                                                                                   |

#### 方法

开启监听：`observe()`

### 实时心率变异性

> RealtimeHRVView

#### 参数

合适View高度: 123

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010145121953.png" width="300">

| 参数               | 类型    | 默认值                         | 说明                                                                                                                                   |
| ------------------ | ------- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| mainColor          | UIColor | `#0064FF`                      | 主色(默认值为RGB显示颜色，如此处对应的是`UIColor(red: 0x23/255.0, green: 0x23/255.0, blue: 0x3a/255.0, alpha: 1)`，alpha必须为1，下同) |
| textColor          | UIColor | `#FFFFFF`                      | 字体颜色                                                                                                                               |
| bgColor            | UIColor | `#000000`                      | 背景色                                                                                                                                 |
| lineColor          | UIColor | `#FF563B`                      | 背景色                                                                                                                                 |
| borderRadius       | CGFloat | 8.0                            | 圆角                                                                                                                                   |
| isShowExtremeValue | Bool    | true                           | 是否显示心率最大最小值                                                                                                                 |
| isShowInfoIcon     | Bool    | true                           | 是否显示‘说明’图标                                                                                                                     |
| infoUrlString      | String  | `"https://demo.entertech.com"` | 实时数据说明网页链接                                                                                                                   |
| buttonImageName    | String  | `"info_button_icon"`           | 按钮图片                                                                                                                               |
| title              | String  | `"心率变异性"`                 | 标题                                                                                                                                   |
#### 方法

开启监听：`observe()`


### 实时注意力/放松度/压力值/激活度/和谐度

> RealtimeAttentionView / RealtimeRelaxationView / RealtimePressureView / RealtimeArousalView / RealtimeCoherenceView

#### 参数

合适View高度: 152

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010145415901.png" width="300">

| 参数            | 类型    | 默认值                         | 说明                 |
| --------------- | ------- | ------------------------------ | -------------------- |
| mainColor       | UIColor | `#0064FF`                      | 主色                 |
| textColor       | UIColor | `#FFFFFF`                      | 字体颜色             |
| bgColor         | UIColor | `#000000`                      | 背景                 |
| borderRadius    | CGFloat | 8.0                            | 圆角                 |
| isShowInfoIcon  | Bool    | true                           | 是否显示‘说明’图标   |
| infoUrlString   | String  | `"https://demo.entertech.com"` | 实时数据说明网页链接 |
| buttonImageName | String  | `"info_button_icon"`           | 按钮图片             |
| title           | String  | `"注意力"`                     | 标题                 |

#### 方法

开启监听：`observe()`

### 实时脑波频谱

> RealtimeBrainwaveSpectrumView

#### 参数

合适View高度: 232

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010150032042.png" width="300">

| 参数            | 类型    | 默认值                         | 说明                 |
| --------------- | ------- | ------------------------------ | -------------------- |
| mainColor       | UIColor | `#0064FF`                      | 主色                 |
| textColor       | UIColor | `#FFFFFF`                      | 字体颜色             |
| textFont        | String  | `"PingFangSC-Semibold"`        | 字体                 |
| bgColor         | UIColor | `#000000`                      | 背景                 |
| borderRadius    | CGFloat | 8.0                            | 圆角                 |
| isShowInfoIcon  | Bool    | true                           | 是否显示‘说明’图标   |
| infoUrlString   | String  | `"https://demo.entertech.com"` | 实时数据说明网页链接 |
| buttonImageName | String  | `"info_button_icon"`           | 按钮图片             |
| title           | String  | `"脑波频谱"`                   | 标题                 |

#### 方法 

开启监听：`observe()`

### 实时脑波

> RealtimeBrainwaveView

#### 参数

合适View高度: 321

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191010150729231.png" width="300">

| 参数                    | 类型    | 默认值                         | 说明                 |
| ----------------------- | ------- | ------------------------------ | -------------------- |
| mainColor               | UIColor | `#0064FF`                      | 主色                 |
| textColor               | UIColor | `#FFFFFF`                      | 字体颜色             |
| textFont                | String  | `"PingFangSC-Semibold"`        | 字体                 |
| bgColor                 | UIColor | `#000000`                      | 背景                 |
| borderRadius            | CGFloat | 8.0                            | 圆角                 |
| isShowInfoIcon          | boolean | true                           | 是否显示‘说明’图标   |
| leftBrainwaveLineColor  | UIColor | `#FF4852`                      | 左脑波曲线颜色       |
| rightBrainwaveLineColor | UIColor | `#0064FF`                      | 右脑波曲线颜色       |
| infoUrlString           | String  | `"https://demo.entertech.com"` | 实时数据说明网页链接 |
| buttonImageName         | String  | `"info_button_icon"`           | 按钮图片             |
| title                   | String  | `"实时脑电波"`                 | 标题                 |

#### 方法

开启监听：`observe()`

## 报表数据UI

### 脑波频谱报表

> AffectiveChartBrainSpectrumView

#### 参数

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014140326307.png" width="300">

| 参数           | 类型      | 默认值                                      | 说明                                |
| -------------- | --------- | ------------------------------------------- | ----------------------------------- |
| textColor      | UIColor   | `#FFFFFF`                                   | 字体颜色                            |
| bgColor        | UIColor   | `#000000`                                   | 背景                                |
| spectrumColors | [UIColor] | `[#23233A,#23233A,#23233A,#23233A,#23233A]` | 各个占比颜色，一次对应γ，β，α，θ，δ |
| cornerRadius   | CGFloat   | 8                                           | 圆角                                |
| title          | String    | `"脑波频谱"`                                | 标题                                |

#### 方法

设置值：`setDataFromModel(gama: [Float], delta: [Float], theta: [Float], alpha: [Float], beta: [Float], timestamp: Int? = nil)`
| 参数      | 类型    | 说明                                         |
| --------- | ------- | -------------------------------------------- |
| gama      | [Float] | gama array                                   |
| delta     | [Float] | delta array                                  |
| theta     | [Float] | theta array                                  |
| alpha     | [Float] | alpha  array                                 |
| beta      | [Float] | beta array                                   |
| timestamp | Int     | 情感云的起始时间，用于计算列表时间，默认为空 |


### 心率报表

> AffectiveChartHeartRateView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014141340894.png" width="300">

#### 参数

| 参数         | 类型    | 默认值      | 说明         |
| ------------ | ------- | ----------- | ------------ |
| textColor    | UIColor | `#FFFFFF`   | 字体颜色     |
| bgColor      | UIColor | `#000000`   | 背景         |
| hrAvg        | Int     | nil         | 展示平均值   |
| lineColor    | UIColor | [`#FF6682`] | 心率曲线颜色 |
| cornerRadius | CGFloat | 8           | 圆角         |
| title        | String  | `"心率"`    | 标题         |

#### 方法

设置值`setDataFromModel(hr: [Int]?, timestamp: Int? = nil)`
| 参数      | 类型  | 说明                                         |
| --------- | ----- | -------------------------------------------- |
| hr        | [Int] | 心率报表数组                                 |
| timestamp | Int   | 情感云的起始时间，用于计算列表时间，默认为空 |

### 心率变异性报表

> AffectiveChartHRVView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014141910905.png" width="300">

#### 参数

| 参数         | 类型    | 默认值         | 说明         |
| ------------ | ------- | -------------- | ------------ |
| textColor    | UIColor | `#FFFFFF`      | 字体颜色     |
| bgColor      | UIColor | `#000000`      | 背景         |
| hrvAvg       | Int     | nil            | 展示平均值   |
| lineColor    | UIColor | [`#FF6682`]    | 心率曲线颜色 |
| cornerRadius | CGFloat | 8              | 圆角         |
| title        | String  | `"心率变异性"` | 标题         |

#### 方法

设置值`setDataFromModel(hrv: [Int]?, timestamp: Int? = nil)`

| 参数      | 类型  | 说明                                         |
| --------- | ----- | -------------------------------------------- |
| hrv       | [Int] | 心率变异性报表数组                           |
| timestamp | Int   | 情感云的起始时间，用于计算列表时间，默认为空 |

### 放松度报表

> AffectiveChartRelaxationView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014142421739.png" width="300">

#### 参数

| 参数            | 类型    | 默认值               | 说明                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| textColor    | UIColor | `#FFFFFF`      | 字体颜色     |
| bgColor      | UIColor | `#000000`      | 背景         |
| avg       | Int     | nil            | 展示平均值   |
| lineColor    | UIColor | [`#FF6682`]    | 心率曲线颜色 |
| cornerRadius | CGFloat | 8              | 圆角         |
| title        | String  | `"放松度"` | 标题         |

#### 方法

注意力报表`setDataFromModel(relaxation: [Int]?, timestamp: Int? = nil)`

| 参数      | 类型  | 说明                                         |
| --------- | ----- | -------------------------------------------- |
| attention | [Int] | 注意力报表数组                               |
| timestamp | Int   | 情感云的起始时间，用于计算列表时间，默认为空 |

### 注意力报表

> AffectiveChartAttentionView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014142421740.png" width="300">

#### 参数

| 参数            | 类型    | 默认值               | 说明                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| textColor    | UIColor | `#FFFFFF`      | 字体颜色     |
| bgColor      | UIColor | `#000000`      | 背景         |
| avg       | Int     | nil            | 展示平均值   |
| lineColor    | UIColor | [`#FF6682`]    | 心率曲线颜色 |
| cornerRadius | CGFloat | 8              | 圆角         |
| title        | String  | `"注意力"` | 标题         |

#### 方法

注意力报表`setDataFromModel(attention: [Int]?, timestamp: Int? = nil)`

| 参数      | 类型  | 说明                                         |
| --------- | ----- | -------------------------------------------- |
| attention | [Int] | 注意力报表数组                               |
| timestamp | Int   | 情感云的起始时间，用于计算列表时间，默认为空 |

### 压力报表

> AffectiveChartPressureView

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014142733860.png" width="300">

#### 参数

| 参数            | 类型    | 默认值               | 说明                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| textColor    | UIColor | `#FFFFFF`      | 字体颜色     |
| bgColor      | UIColor | `#000000`      | 背景         |
| avg       | Int     | nil            | 展示平均值   |
| lineColor    | UIColor | [`#FF6682`]    | 心率曲线颜色 |
| cornerRadius | CGFloat | 8              | 圆角         |
| title        | String  | `"压力值"` | 标题         |

#### 方法

设置值`setDataFromModel(pressure: [Float]?, timestamp: Int? = nil)`

| 参数      | 类型       | 说明                                         |
| --------- | ---------- | -------------------------------------------- |
| pressure  | [pressure] | 放松度报表数组                               |
| timestamp | Int        | 情感云的起始时间，用于计算列表时间，默认为空 |
