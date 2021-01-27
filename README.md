# Enter-AffectiveCloud-iOS-SDK

## 目录

- [Enter-AffectiveCloud-iOS-SDK](#enter-affectivecloud-ios-sdk)
  - [目录](#目录)
  - [SDK 说明](#sdk-说明)
  - [Demo演示](#demo演示)
  - [结构说明](#结构说明)
  - [安装集成](#安装集成)
    - [版本需求](#版本需求)
    - [Cocoapods](#cocoapods)

## SDK 说明

回车情感云可以根据用户的脑波数据和心率数据来进行高级情绪情感数据分析的一个云算法平台，同时能给出包括：放松度、注意力、愉悦值，压力值、激动度（内测）在内的多种情绪情感值。详情请查看[官网](https://www.entertech.cn)。

在开始开发前，请先查看回车情感云的[开发文档](https://docs.affectivecloud.com)，了解情感云平台的架构和所能提供的服务具体说明，确定好你的应用中所需要的服务。你还需要联系管理员注册好测试应用，然后再进行开发。

为了方便你进行 iOS 平台的快速开发，我们提供了情感云快速开发 SDK，通过本 SDK 你可以快速地将情感云的能力集成到你的 app 中。

## Demo演示

[心流](https://github.com/Entertech/Enter-AffectiveCloud-Demo-iOS.git)这个演示应用集成了基础蓝牙功能、蓝牙设备管理界面、情感云SDK、以及自定义的数据展示控件，较好的展示了脑波及心率数据从 硬件中采集到上传情感云实时分析最后产生分析报表及数据展示的整个过程。

## 结构说明

- [EnterAffectiveCloud](EnterAffectiveCloud/)提供了向算法平台提供脑波数据和心率数据的接口，同时可以计算多种情绪值
- [EnterAffectiveCloudUI](UI/EnterAffectiveCloudUI/) 提供了各UI模块用以展示实时数据和报表数据(可选)。

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/6.png" width="500">

## 安装集成

### 版本需求
- Xcode 10.2
- Swift 5.0

### Cocoapods

添加下面内容到你的 Podfile。

```
# 指定 pod 仓库源
source 'git@github.com:EnterTech/PodSpecs.git'

target 'Your Target' do
    pod 'EnterAffectiveCloud', '~> 2.2.0'
    pod 'EnterAffectiveCloudUI', '~> 2.2.0'  #(可选)
end
```
运行 `pod  install` 安装命令.

