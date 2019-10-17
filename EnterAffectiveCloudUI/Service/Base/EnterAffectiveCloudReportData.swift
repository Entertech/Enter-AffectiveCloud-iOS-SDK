//
//  EnterAffectiveCloudReportData.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

/// ReportData 由标量数据（scalars）和绘图数组组成 (digitals)
public class EnterAffectiveCloudReportData {

    public let scalars: [ReportScalar]
    public let digitals: [ReportDigital]

    public init(scalars: [ReportScalar], digitals: [ReportDigital]) {
        self.scalars = scalars
        self.digitals = digitals
    }

    public func data() -> Data {
        var datas = Data()
        // 标量数据
        for scalar in scalars {
            datas.append(scalar.data())
        }

        // 数据数据
        for digital in digitals {
            datas.append(digital.data())
        }

        return datas
    }
}

/// 标量数据: 有 1 个字节和 4 个字节的 value 组成, value 为 Float
public struct ReportScalar {
    public let type: ReportScalarType
    public let value: Float
    
    public init(type: ReportScalarType, value: Float) {
            self.type = type
            self.value = value
    }

    public func data() -> Data {
        var data = Data(from: value)
        data.insert(type.rawValue, at: 0)
        return data
    }
}

/// 数组数据: 绘制报表的曲线数据类型：由 1 个字节的 type 和 4 个字节的 length 再加 bodyDatas 组成
public struct ReportDigital {
    public let type: ReportDigitalType
    public let length: Float32
    public let bodyDatas: Data

    public init(type: ReportDigitalType, length: Float32, data: Data) {
        self.type      = type
        self.length    = length
        self.bodyDatas = data
    }

    public func data() -> Data {
        var data = Data(from: self.length)
        data.insert(self.type.rawValue, at: 0)
        data.append(self.bodyDatas)
        return data
    }
}

// Flowtime Report Type
/*
 * 0x00 保留
 * 0x01 心率平均值，值域 0-255
 * 0x02 心率最大值，值域 0-255
 * 0x03 心率最小值，值域 0-255
 * 0x04 hrv平均值，值域0-255
 * 0x05 hrv最大值，值域0-255
 * 0x06 hrv最小值，值域0-255
 * 0x07 注意力平均值，值域0-100
 * 0x08 注意力最大值，值域0-100
 * 0x09 注意力最小值，值域0-100
 * 0x0a 放松度平均值，值域0-100
 * 0x0b 放松度最大值，值域0-100
 * 0x0c 放松度最小值，值域0-100
 * 0x0d 压力值平均值，值域0-100
 * 0x0e 压力值最大值，值域0-100
 * 0x0f 压力值最小值，值域0-100
 * 0x10 愉悦度平均值，值域0-100
 * 0x11 愉悦度最大值，值域0-100
 * 0x12 愉悦度最小值，值域0-100
 * 0x13 激活度平均值，值域0-100
 * 0x14 激活度最大值，值域0-100
 * 0x15 激活度最小值，值域0-100
 */
public enum ReportScalarType: UInt8 {
    case retained         = 0x00
    case hrAverage        = 0x01
    case hrMax            = 0x02
    case hrMin            = 0x03
    case hrvAverage       = 0x04
    case hrvMax           = 0x05
    case hrvMin           = 0x06
    case attentionAverage = 0x07
    case attentionMax     = 0x08
    case attentionMin     = 0x09
    case relaxAverage     = 0x0a
    case relaxMax         = 0x0b
    case relaxMin         = 0x0c
    case pressureAverage  = 0x0d
    case pressureMax      = 0x0e
    case pressureMin      = 0x0f
    case pleasureAverage  = 0x10
    case pleasureMax      = 0x11
    case pleasureMin      = 0x12
    case activateAverage  = 0x13
    case activateMax      = 0x14
    case activateMin      = 0x15
}

/*
 * 0xf0 保留
 * 0xf1 脑电α频段能量变化曲线 [0, 1]
 * 0xf2 脑电β频段能量变化曲线 [0, 1]
 * 0xf3 脑电θ频段能量变化曲线 [0, 1]
 * 0xf4 脑电δ频段能量变化曲线 [0, 1]
 * 0xf5 脑电γ频段能量变化曲线 [0, 1]
 * 0xf6 心率值全程记录[0, 255]
 * 0xf7 心率变异性全程记录[0, 255]
 * 0xf8 注意力全程记录[0, 100]
 * 0xf9 放松度全程记录[0, 100]
 * 0xfa 压力值全程记录[0, 100]
 * 0xfb 愉悦度全程记录[0, 100]
 * 0xfc 激活度全程记录[0, 100]
 */
public enum ReportDigitalType: UInt8 {
    case retained = 0xf0
    case alpha = 0xf1
    case belta = 0xf2
    case theta = 0xf3
    case delta = 0xf4
    case gamma = 0xf5
    case hr = 0xf6
    case hrv = 0xf7
    case attention = 0xf8
    case relax = 0xf9
    case pressure = 0xfa
    case pleasure = 0xfb
    case activate = 0xfc
}

extension Data {
    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { Data($0)}
    }

    func to<T>(type: T.Type) -> T? where T: ExpressibleByIntegerLiteral {
        var value: T = 0
        guard count >= MemoryLayout.size(ofValue: value) else {
            return nil
        }
        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0) })
        return value
    }

    init<T>(fromArray values: [T]) {
        self = values.withUnsafeBytes { Data($0)}
    }

    func to<T>(arrayType: T.Type) -> [T]? where T: ExpressibleByIntegerLiteral {
        var array = Array<T>(repeating: 0, count: self.count/MemoryLayout<T>.stride)
        _ = array.withUnsafeMutableBytes { copyBytes(to: $0) }
        return array
    }
}
