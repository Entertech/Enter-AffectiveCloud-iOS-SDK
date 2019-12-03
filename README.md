# Enter-AffectiveCloud-iOS-SDK

# 目录

- [Enter-AffectiveCloud-iOS-SDK](#enter-affectivecloud-ios-sdk)
- [目录](#%e7%9b%ae%e5%bd%95)
- [SDK 说明](#sdk-%e8%af%b4%e6%98%8e)
  - [结构说明](#%e7%bb%93%e6%9e%84%e8%af%b4%e6%98%8e)
  - [安装集成](#%e5%ae%89%e8%a3%85%e9%9b%86%e6%88%90)
    - [版本需求](#%e7%89%88%e6%9c%ac%e9%9c%80%e6%b1%82)
    - [Cocoapods](#cocoapods)

# SDK 说明

回车情感云可以根据用户的脑波数据和心率数据来进行高级情绪情感数据分析的一个云算法平台，同时能给出包括：放松度、注意力、愉悦值，压力值、激动度（内测）在内的多种情绪情感值。详情请查看[官网](https://www.entertech.cn)。

在开始开发前，请先查看回车情感云的[开发文档](https://docs.affectivecloud.com)，了解情感云平台的架构和所能提供的服务具体说明，确定好你的应用中所需要的服务。你还需要联系管理员注册好测试应用，然后再进行开发。

为了方便你进行 iOS 平台的快速开发，我们提供了情感云快速开发 SDK，通过本 SDK 你可以快速地将情感云的能力集成到你的 app 中。

## 结构说明

- [EnterAffectiveCloud](EnterAffectiveCloud/)提供了向算法平台提供脑波数据和心率数据的接口，同时可以计算多种情绪值
- [EnterAffectiveCloudUI](EnterAffectiveCloudUI/) 提供了各UI模块用以展示实时数据和报表数据(可选)。

<img src="https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/blob/master/img/4.png" width="500">

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
    pod 'EnterAffectiveCloud', '~> 1.3.6'
    pod 'EnterAffectiveCloudUI', '~> 1.3.6'  #(可选)
end
```
运行 `pod  install` 安装命令.

