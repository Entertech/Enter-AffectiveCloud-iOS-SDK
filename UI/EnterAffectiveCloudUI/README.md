# 情感云数据标准UI

- [情感云数据标准UI](#%e6%83%85%e6%84%9f%e4%ba%91%e6%95%b0%e6%8d%ae%e6%a0%87%e5%87%86ui)
  - [Demo](#demo)
  - [实时数据UI](#%e5%ae%9e%e6%97%b6%e6%95%b0%e6%8d%aeui)
    - [接入](#%e6%8e%a5%e5%85%a5)
    - [完整图示](#%e5%ae%8c%e6%95%b4%e5%9b%be%e7%a4%ba)
  - [报表UI](#%e6%8a%a5%e8%a1%a8ui)
    - [接入](#%e6%8e%a5%e5%85%a5-1)
    - [横向放大报表](#%e6%a8%aa%e5%90%91%e6%94%be%e5%a4%a7%e6%8a%a5%e8%a1%a8)
    - [完整图示](#%e5%ae%8c%e6%95%b4%e5%9b%be%e7%a4%ba-1)
  - [情感云UI详细API](#%e6%83%85%e6%84%9f%e4%ba%91ui%e8%af%a6%e7%bb%86api)

为了方便用户接入, 我们提供了数据展示UI的标准模版, 分为实时数据UI和报表UI。

## Demo

UI库的Demo包含以下组件：
- [1.实时数据演示Demo](../EnterRealtimeUIDemo/)
- [2.报表数据演示Demo](../EnterReportUIDemo/)

[心流 App](https://github.com/Entertech/Enter-AffectiveCloud-Demo-iOS.git) 这个演示应用集成了基础蓝牙功能、蓝牙设备管理界面、情感云SDK、以及自定义的数据展示控件，较好的展示了脑波及心率数据从 硬件中采集到上传情感云实时分析最后产生分析报表及数据展示的整个过程。

## 实时数据UI

在此以心率为例, 展示如何接入实时UI。

### 接入

```swift
let hrView = RealtimeHeartRateView()
// 设置属性
hrView.bgColor = UIColor(red: 1, green: 229.0/255.0, blue: 231.0/255.0, alpha: 1)
hrView.mainColor = UIColor(red: 1, green: 72.0/255.0, blue: 82.0/255.0, alpha: 1)
self.view.addSubview(hrView)
hrView.snp.makeConstraints {
  $0.left.right.equalTo(16)
  $0.hight.equalTo(123) //高度不可定制
  //...其他约束
}

// 开启监听, 开启情感云后会自动更新界面上的心率数据
hrView.observe()
```
<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/hr_screenshoot.png" width="300">

### 完整图示

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/WechatIMG1.jpeg" width="300">

## 报表UI

在此以注意力报表为例, 展示如何接入报表UI。

### 接入

```swift

let attentionReportView = AttentionReportView()
self.view.addSubview(attentionReportView)
attentionReportView.snp.makeConstraints {
  $0.left.right.equalTo(16)
  $0.hight.equalTo(298) // 高度不可定制
  //...其他约束
}
// 平均值
attentionReportView.avgValue = 78
// 最大值
attentionReportView.maxValue = 99
// 最小值
attentionReportView.minValue = 6
// 图表数组
attentionReportView.setDataFromModel(attention: intArray)

```
setDataFromModel 方法有两个参数

| 参数      | 类型     | 说明                       |
| --------- | -------- | -------------------------- |
| attention | Int 数组 | 组成列表的数据             |
| timestamp | Int      | 情感云的起始时间, 可不设置 |

不传timestamp参数时, X轴坐标：

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/image-20191014142421740.png" width="300">

传入timestamp时, X轴坐标：

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/attention_with_timstamp.png" width="300">

### 横向放大报表

点击右上角放大按钮可获得横向报表。

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/IMG_C67F3DC6DCDB-1.jpeg" width="600">

### 完整图示

经过定制可作出如下效果：

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/IMG_5034.JPG" width="300">

## 情感云UI详细API
- 情感云UI的API文档请查看: [情感云UI文档](../../APIDocuments/AffectiveCloudUI.md)
