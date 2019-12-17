# 情感云UI

> 情感云UI分两部分, 实时数据展示UI和报表数据UI, 可选用需要的部分。
> 所有UI继承自UIView, 可自己定义需要的Layer, 我们也提供了一些参数给您可以选择UI样式。

- [情感云UI](#%e6%83%85%e6%84%9f%e4%ba%91ui)
  - [实时数据UI](#%e5%ae%9e%e6%97%b6%e6%95%b0%e6%8d%aeui)
    - [RealtimeHeartRateView](#realtimeheartrateview)
      - [参数](#%e5%8f%82%e6%95%b0)
      - [方法](#%e6%96%b9%e6%b3%95)
    - [RealtimeAttentionView &amp; RealtimeRelaxationView &amp; RealtimePressureView](#realtimeattentionview-amp-realtimerelaxationview-amp-realtimepressureview)
      - [参数](#%e5%8f%82%e6%95%b0-1)
      - [方法](#%e6%96%b9%e6%b3%95-1)
    - [RealtimeBrainwaveSpectrumView](#realtimebrainwavespectrumview)
      - [参数](#%e5%8f%82%e6%95%b0-2)
      - [方法](#%e6%96%b9%e6%b3%95-2)
    - [RealtimeBrainwaveView](#realtimebrainwaveview)
      - [参数](#%e5%8f%82%e6%95%b0-3)
      - [方法](#%e6%96%b9%e6%b3%95-3)
  - [报表数据UI](#%e6%8a%a5%e8%a1%a8%e6%95%b0%e6%8d%aeui)
    - [BrainSpecturmReportView](#brainspecturmreportview)
      - [参数](#%e5%8f%82%e6%95%b0-4)
      - [方法](#%e6%96%b9%e6%b3%95-4)
    - [HeartRateReportView](#heartratereportview)
      - [参数](#%e5%8f%82%e6%95%b0-5)
      - [方法](#%e6%96%b9%e6%b3%95-5)
    - [HeartRateVariablityReportView](#heartratevariablityreportview)
      - [参数](#%e5%8f%82%e6%95%b0-6)
      - [方法](#%e6%96%b9%e6%b3%95-6)
    - [RelaxationReportView &amp; AttentionReportView](#relaxationreportview-amp-attentionreportview)
      - [参数](#%e5%8f%82%e6%95%b0-7)
      - [方法](#%e6%96%b9%e6%b3%95-7)
    - [PressureChart](#pressurechart)
      - [参数](#%e5%8f%82%e6%95%b0-8)
      - [方法](#%e6%96%b9%e6%b3%95-8)

## 实时数据UI

### RealtimeHeartRateView

实时心率

#### 参数

合适View高度: 123

![image-20191010145121952](img/../../img/image-20191010145121952.png)

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
#### 方法

开启监听：`observe()`

### RealtimeAttentionView & RealtimeRelaxationView & RealtimePressureView

实时注意力/放松度/压力值

#### 参数

合适View高度: 152

![image-20191010145415901](img/../../img/image-20191010145415901.png)

| 参数            | 类型    | 默认值                         | 说明                 |
| --------------- | ------- | ------------------------------ | -------------------- |
| mainColor       | UIColor | `#0064FF`                      | 主色                 |
| textColor       | UIColor | `#FFFFFF`                      | 字体颜色             |
| bgColor         | UIColor | `#000000`                      | 背景                 |
| borderRadius    | CGFloat | 8.0                            | 圆角                 |
| isShowInfoIcon  | Bool    | true                           | 是否显示‘说明’图标   |
| infoUrlString   | String  | `"https://demo.entertech.com"` | 实时数据说明网页链接 |
| buttonImageName | String  | `"info_button_icon"`           | 按钮图片             |

#### 方法

开启监听：`observe()`

### RealtimeBrainwaveSpectrumView

实时脑波频谱

#### 参数

合适View高度: 232

![image-20191010150032042](img/../../img/image-20191010150032042.png)

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

#### 方法 

开启监听：`observe()`

### RealtimeBrainwaveView

实时脑波

#### 参数

合适View高度: 321

![image-20191010150729231](img/../../img/image-20191010150729231.png)

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

#### 方法

开启监听：`observe()`

## 报表数据UI

### BrainSpecturmReportView

脑波频谱报表

#### 参数

合适View高度: 314

![image-20191014140326307](img/../../img/image-20191014140326307.png)

| 参数            | 类型      | 默认值                                      | 说明                                      |
| --------------- | --------- | ------------------------------------------- | ----------------------------------------- |
| mainColor       | UIColor   | `#0064FF`                                   | 主色                                      |
| textColor       | UIColor   | `#FFFFFF`                                   | 字体颜色                                  |
| bgColor         | UIColor   | `#000000`                                   | 背景                                      |
| isShowInfoIcon  | Bool      | true                                        | 是否显示说明图标                          |
| sample          | Int       | 3                                           | 采样率，表示几个点采一个，默认3个点采一个 |
| spectrumColors  | [UIColor] | `[#23233A,#23233A,#23233A,#23233A,#23233A]` | 各个占比颜色，一次对应γ，β，α，θ，δ       |
| buttonImageName | String    | `"info_button_icon"`                        | 按钮图片                                  |
| borderRadius    | CGFloat   | 8                                           | 圆角                                      |
| infoUrlString   | String    | `https://demo.com`                          | 按钮打开的说明网页                        |

#### 方法

设置值：`setDataFromModel(gama: [Float], delta: [Float], theta: [Float], alpha: [Float], beta: [Float], timestamp: Int? = nil)`
| 参数      | 类型    | 说明                                         |
| --------- | ------- | -------------------------------------------- |
| gama      | [Float] | gama array                                   |
| delta     | [Float] | delta array                                  |
| theta     | [Float] | theta array                                  |
| alpha     | [Float] | alpha  array                                 |
| beta      | [Float] | beta array                                   |
| timestamp | Int | 情感云的起始时间，用于计算列表时间，默认为空 |


### HeartRateReportView

心率报表

#### 参数

合适View高度: 285

![image-20191014141340894](img/../../img/image-20191014141340894.png)

| 参数                | 类型      | 默认值                           | 说明                                      |
| ------------------- | --------- | -------------------------------- | ----------------------------------------- |
| mainColor           | UIColor   | `#0064FF`                        | 主色                                      |
| textColor           | UIColor   | `#FFFFFF`                        | 字体颜色                                  |
| bgColor             | UIColor   | `#000000`                        | 背景                                      |
| isShowInfoIcon      | Bool      | true                             | 是否显示说明图标                          |
| sample              | Int       | 3                                | 采样率，表示几个点采一个，默认3个点采一个 |
| avgValue            | Int       | nil                              | 展示平均值                                |
| maxValue            | Int       | nil                              | 展示最大值                                |
| minValue            | Int       | nil                              | 是否展示最小值                            |
| heartRateLineColors | [UIColor] | [`#23233A`, `#23233A`,`#23233A`] | 心率较高曲线颜色(依次为高，中， 低)       |
| buttonImageName     | String    | `"info_button_icon"`             | 按钮图片                                  |
| borderRadius        | CGFloat   | 8                                | 圆角                                      |
| infoUrlString       | String    | `https://demo.com`               | 按钮打开的说明网页                        |

#### 方法

设置值`setDataFromModel(hr: [Int]?, timestamp: Int? = nil)`
| 参数      | 类型    | 说明                                         |
| --------- | ------- | -------------------------------------------- |
| hr        | [Int]   | 心率报表数组                                 |
| timestamp | Int | 情感云的起始时间，用于计算列表时间，默认为空 |

### HeartRateVariablityReportView

心率变异性报表

#### 参数

合适View高度: 260

![image-20191014141910905](img/../../img/image-20191014141910905.png)

| 参数            | 类型    | 默认值               | 说明                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| mainColor       | UIColor | `#0064FF`            | 主色                                      |
| textColor       | UIColor | `#FFFFFF`            | 字体颜色                                  |
| bgColor         | UIColor | `#000000`            | 背景                                      |
| isShowInfoIcon  | Bool    | true                 | 是否显示说明图标                          |
| sample          | Int     | 3                    | 采样率，表示几个点采一个，默认3个点采一个 |
| avgValue        | Int     | nil                  | 展示平均值                                |
| lineColor       | UIColor | `#23233A`            | 曲线颜色                                  |
| buttonImageName | String  | `"info_button_icon"` | 按钮图片                                  |
| borderRadius    | CGFloat | 8                    | 圆角                                      |
| infoUrlString   | String  | `https://demo.com`   | 按钮打开的说明网页                        |

#### 方法

设置值`setDataFromModel(hrv: [Int]?, timestamp: Int? = nil)`

| 参数      | 类型    | 说明                                         |
| --------- | ------- | -------------------------------------------- |
| hrv        | [Int]   | 心率变异性报表数组                                 |
| timestamp | Int | 情感云的起始时间，用于计算列表时间，默认为空 |

### RelaxationReportView & AttentionReportView

放松度报表/注意力报表

#### 参数

合适View高度: 298

![image-20191014142421739](img/../../img/image-20191014142421739.png)

| 参数            | 类型    | 默认值               | 说明                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| mainColor       | UIColor | `#0064FF`            | 主色                                      |
| textColor       | UIColor | `#FFFFFF`            | 字体颜色                                  |
| bgColor         | UIColor | `#000000`            | 背景                                      |
| isShowInfoIcon  | Bool    | true                 | 是否显示说明图标                          |
| sample          | Int     | 3                    | 采样率，表示几个点采一个，默认3个点采一个 |
| avgValue        | Int     | nil                  | 展示平均值                                |
| maxValue        | Int     | nil                  | 展示最大值                                |
| minValue        | Int     | nil                  | 是否展示最小值                            |
| fillColor       | UIColor | `#23233A`            | 填充颜色                                  |
| buttonImageName | String  | `"info_button_icon"` | 按钮图片                                  |
| borderRadius    | CGFloat | 8                    | 圆角                                      |
| infoUrlString   | String  | `https://demo.com`   | 按钮打开的说明网页                        |

#### 方法

注意力报表`setDataFromModel(attention: [Int]?, timestamp: Int? = nil)`

| 参数      | 类型    | 说明                                         |
| --------- | ------- | -------------------------------------------- |
| attention        | [Int]   | 注意力报表数组                                 |
| timestamp | Int | 情感云的起始时间，用于计算列表时间，默认为空 |

放松度报表`setDataFromModel(relaxation: [Int]?, timestamp: Int? = nil)`

| 参数      | 类型    | 说明                                         |
| --------- | ------- | -------------------------------------------- |
| relaxation        | [Int]   | 放松度报表数组                                 |
| timestamp | Int | 情感云的起始时间，用于计算列表时间，默认为空 |

### PressureChart

压力报表

#### 参数

合适View高度: 195

![image-20191014142733860](img/../../img/image-20191014142733860.png)

| 参数            | 类型    | 默认值               | 说明                                      |
| --------------- | ------- | -------------------- | ----------------------------------------- |
| mainColor       | UIColor | `#0064FF`            | 主色                                      |
| textColor       | UIColor | `#FFFFFF`            | 字体颜色                                  |
| bgColor         | UIColor | `#000000`            | 背景                                      |
| isShowInfoIcon  | Bool    | true                 | 是否显示说明图标                          |
| sample          | Int     | 3                    | 采样率，表示几个点采一个，默认3个点采一个 |
| chartColor      | UIColor | `#23233A`            | 填充颜色                                  |
| buttonImageName | String  | `"info_button_icon"` | 按钮图片                                  |
| borderRadius    | CGFloat | 8                    | 圆角                                      |
| infoUrlString   | String  | `https://demo.com`   | 按钮打开的说明网页                        |

#### 方法

设置值`setDataFromModel(pressure: [Float]?, timestamp: Int? = nil)`

| 参数      | 类型    | 说明                                         |
| --------- | ------- | -------------------------------------------- |
| pressure        | [pressure]   | 放松度报表数组                                 |
| timestamp | Int | 情感云的起始时间，用于计算列表时间，默认为空 |
