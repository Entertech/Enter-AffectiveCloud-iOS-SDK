//
//  EnterAffectiveCloudReportFileReader.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

let kReportScalarTypeLength = 5
let kFragmentHeaderLength = 16 // 每个片头为 16 个字节

class EnterAffectiveCloudReportFileReader: DataFileReader {
    public var fragments = [ReportDataFragment]()

    public override func loadFile(_ fileURL: URL) throws {
        do {
            try super.loadFile(fileURL)
            self.fragments = self.parse(self.data)
        } catch {
            throw error
        }
    }

    private func parse(_ data: Data) -> [ReportDataFragment] {
        var fragments = [ReportDataFragment]()
        var reportBodyData = data

        while reportBodyData.count > kFragmentHeaderLength {
            let header = self.data.prefix(kFragmentHeaderLength)
            let fragment = ReportDataFragment(header: header.allBytes)

            let range: Range = kFragmentHeaderLength..<reportBodyData.count
            if let fragmentBodyData = self.serialize(reportBodyData.subdata(in: range)) {
                fragment.reportData = fragmentBodyData
                fragment.data = fragmentBodyData.data()
            } else {
                break
            }
            fragments.append(fragment)

            reportBodyData.removeFirst(Int(fragment.length))
        }

        return fragments
    }

    private let digitalTypeList: [Byte] = [0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff]
    private func serialize(_ data: Data) -> EnterAffectiveCloudReportData? {
        let bytes = data.allBytes
        var digitalBeginIndex: Int = 0
        for (index, value) in bytes.enumerated() {
            if digitalTypeList.contains(value),
                index % kReportScalarTypeLength == 0 {
                digitalBeginIndex = index
                break
            }
        }
        
        if digitalBeginIndex == 0 { return nil}
        let scalerRange: Range = 0..<digitalBeginIndex
        let scalarData = data.subdata(in: scalerRange)
        let scalars = toReportScalarWith(data: scalarData)

        let digitalRange: Range = digitalBeginIndex..<data.count
        let digitalData = data.subdata(in: digitalRange)
        let digitals = toReportDigitalWith(data: digitalData)
        if scalars.count == 0, digitals.count == 0 { return nil }
        return EnterAffectiveCloudReportData(scalars: scalars, digitals: digitals, version: self.dataVersion)
    }

    // 解析标量数据
    private func toReportScalarWith(data: Data) -> [ReportScalar] {
        let bytes = data.allBytes
        let scalars: [ReportScalar] = stride(from: bytes.startIndex, to: bytes.endIndex, by: kReportScalarTypeLength).map{ startIndex in
            let type = ReportScalarType(rawValue: bytes[startIndex]) ?? ReportScalarType.retained
            let range = (startIndex + 1)..<(startIndex + kReportScalarTypeLength)
            let valueData = data.subdata(in: range)
            let value: Float = valueData.to(type: Float.self)!
            let scalar = ReportScalar(type: type, value: value)

            return scalar
        }

        return scalars
    }

    // 解析绘图数据数组
    private func toReportDigitalWith(data: Data) -> [ReportDigital] {
        var digitals = [ReportDigital]()
        let tempData = data
        var startIndex = 0
        var endIndex = 0
        while (startIndex < data.count) {
            var type = ReportDigitalType.retained
            switch tempData[startIndex]  {
            case 0xf1:
                type = ReportDigitalType.alpha
            case 0xf2:
                type = ReportDigitalType.belta
            case 0xf3:
                type = ReportDigitalType.theta
            case 0xf4:
                type = ReportDigitalType.delta
            case 0xf5:
                type = ReportDigitalType.gamma
            case 0xf6:
                type = ReportDigitalType.hr
            case 0xf7:
                type = ReportDigitalType.hrv
            case 0xf8:
                type = ReportDigitalType.attention
            case 0xf9:
                type = ReportDigitalType.relax
            case 0xfa:
                type = ReportDigitalType.pressure
            case 0xfb:
                type = ReportDigitalType.pleasure
            case 0xfc:
                type = ReportDigitalType.activate
            case 0xfd:
                type = ReportDigitalType.coherence
            case 0xfe:
                type = ReportDigitalType.sleepy
            case 0xff:
                type = ReportDigitalType.coherenceType
            default:
                break
            }
            let headRange = (startIndex + 1)..<(startIndex + kReportScalarTypeLength)
            let localData = tempData.subdata(in: headRange)
            let length = localData.to(type: Float32.self)!

            endIndex = startIndex + kReportScalarTypeLength + Int(length * 4)
            if endIndex > data.count { break }
            let bodyRange = (startIndex + kReportScalarTypeLength)..<endIndex
            let digitalDatas = data.subdata(in: bodyRange)
            let digital = ReportDigital(type: type,
                                      length: length,
                                      data: digitalDatas)
            digitals.append(digital)
            startIndex = endIndex
        }
        return digitals
    }
}


public class ReportDataFragment: FragmentData {
    public var reportData: EnterAffectiveCloudReportData?

    public override func write(data: Data) {
        super.write(data: data)
    }

    public func write(report: EnterAffectiveCloudReportData) {
        self.reportData = report
        super.write(data: report.data())
    }
}
