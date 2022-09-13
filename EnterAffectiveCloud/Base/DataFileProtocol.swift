//
//  DataFileProtocol.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

/// 字节类型
public typealias Byte = UInt8
/// 字节序列
public typealias Bytes = [Byte]
/// 时间戳类型
public typealias Timestamp = UInt

/**
 * 数据文件协议
 */
public protocol DataFileProtocol: AnyObject {
    /// 协议版本号
    var protocolVersion: String { get }
    /// 文件头长度
    var headerLength: Byte { get }
    /// 文件类型
    var fileType: Byte { get }
    /// 数据版本号
    var dataVersion: String { get }
    /// 数据长度
    var dataLength: UInt64 { get }
    /// 校验和
    var checksum: UInt16 { get }
    /// 时间戳
    var timestamp: Timestamp { get }
    /// 数据
    var data: Data { get }
}

/**
 * 数据文件`读`协议
 */
public protocol DataFileReadable: DataFileProtocol {
    /**
     加载文件

     - parameter file: 文件的本地 URL

     - throws: 加载错误
     */
    func loadFile(_ fileURL: URL) throws
}

/**
 * 数据文件`写`协议
 */
public protocol DataFileWritable: DataFileProtocol {

    /**
     创建一个数据文件

     - parameter file: 文件的本地 URL

     - throws: 创建错误
     */
    func createFile(_ fileURL: URL) throws

    /**
     写入一段数据

     - parameter data: 要写入的数据

     - throws: 写入错误
     */
    func writeData(_ data: Data) throws

    /**
     关闭写文件

     - throws: 文件错误
     */
    func close() throws
}
