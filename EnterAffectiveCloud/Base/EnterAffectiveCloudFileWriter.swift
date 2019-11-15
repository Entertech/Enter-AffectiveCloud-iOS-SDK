//
//  EnterAffectiveCloudFileWriter.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class EnterAffectiveCloudFileWriter: DataFileWriterV2 {
    public override init() {
        super.init()
        fileType = 5
    }

    public func writeReportData(_ fragement: ReportDataFragment) throws {
        try super.write(fragment: fragement)
    }
}


/// V2 的写数据类
open class DataFileWriterV2: DataFileWriter {

    public override init() {
        super.init()
        protocolVersion = "2.0"
    }

    @available(*, unavailable, message: "使用 write(fragment:) 分片写入")
    open override func writeData(_ data: Data) throws {
        try super.writeData(data)
    }

    /// 写入一个分片数据
    ///
    /// - Parameter fragment: 分片数据
    /// - Throws: 写入异常
    open func write(fragment: FragmentData) throws {
        let data = fragment.dump()
        try super.writeData(data)
    }

}
