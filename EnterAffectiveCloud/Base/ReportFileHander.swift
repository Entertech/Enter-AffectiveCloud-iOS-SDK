//
//  ReportFileHander.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class ReportFileHander: NSObject {
    /* path 生成规则：FTFileManager.shared.userDirectory(#userID).appendingPathComponent("#startTime")
     * userID: 为用户的ID
     * startTime: 为体验开始时间（如：2019-06-04 17:23:12）
     *
     * MuseReportData 包含两类数据： 标量数据集合（scalars）、数组数据集合（digitals）
     * 标量数据：MuseScalar 生成标量数据如 MuseScalar(type: .hrMin, value: 66)
     * 数组数据：MuseDigital 生成数组数据 MuseDigital(type: .hr, length: 100, data: #data)
     * 上面 data 为 心率数据集合的字节流，[Float] 转成 Data 数据得到。
     */
    public class func createReportFile(_ path: String,_ museReportData: EnterAffectiveCloudReportData) {
        let writer = EnterAffectiveCloudFileWriter()

        let url = URL(fileURLWithPath: path)
        do {
            try writer.createFile(url)
            let fragment = ReportDataFragment()
            fragment.write(report: museReportData)
            try writer.writeReportData(fragment)
        } catch {
            //TODO: do something
            print("write report file error: \(error)")
        }
    }

    /* path 生成规则：FTFileManager.shared.userDirectory(#userID).appendingPathComponent("#startTime")
     * userID: 为用户的ID
     * startTime: 为体验开始时间（如：2019-06-04 17:23:12）
     *
     * 返回值说明：
     * MuseReportData 包含两类数据： 标量数据（scalars）、数组数据（digitals）
     * 标量数据：通过 MuseScalar type 去获取不同的数据。如 scalars[i].type == .hr 可拿到 scalars[i].value
     * 数组数据: 通过 MuseDigital type 去获取不同类型曲线数组。 如 digital[i].type 可拿到 digital.bodyDatas
     * 然后将 data 转换成 [Float]
     */
    public class func readReportFile(_ path: String) -> EnterAffectiveCloudReportData? {
        guard FileManager.init().fileExists(atPath: path) else {
            return nil
        }
        let reader = EnterAffectiveCloudReportFileReader()
        let url = URL(fileURLWithPath: path)
        do {
            try reader.loadFile(url)
            return reader.fragments.first?.reportData ?? nil
        } catch {
            //TODO: do something
            print("reader report file error \(error)")
        }
        return nil
    }
    
    static var cacheDirectory: String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return path
    }
}
