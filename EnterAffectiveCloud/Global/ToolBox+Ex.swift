//
//  ToolBox+Ex.swift
//  Enter-AffectiveComputing-iOS-SDK
//
//  Created by Anonymous on 2019/8/13.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import CommonCrypto

func MD5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let data = string.data(using: .utf8)!
    var digest = Data(count: length)
    _ = digest.withUnsafeMutableBytes { outer -> UInt8 in
        data.withUnsafeBytes({ innerBytes -> UInt8 in
            if let innerA = innerBytes.baseAddress,
                let byteA = outer.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(data.count)
                CC_MD5(innerA, messageLength, byteA)
            }
            return 0
        })
    }
    return data
}


extension Data {
    /// Hashing algorithm for hashing a Data instance.
    ///
    /// - Parameters:
    ///   - type: The type of hash to use.
    ///   - output: The type of hash output desired, defaults to .hex.
    ///   - Returns: The requested hash output or nil if failure.
    public func hashed(_ type: HashType, output: HashOutputType = .hex) -> String? {

        // setup data variable to hold hashed value
        var digest = Data(count: Int(type.length))

        _ = digest.withUnsafeMutableBytes{ digestBytes -> UInt8 in
            self.withUnsafeBytes { messageBytes -> UInt8 in
                if let mb = messageBytes.baseAddress, let db = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let length = CC_LONG(self.count)
                    switch type {
                    case .md5: CC_MD5(mb, length, db)
                    case .sha1: CC_SHA1(mb, length, db)
                    case .sha224: CC_SHA224(mb, length, db)
                    case .sha256: CC_SHA256(mb, length, db)
                    case .sha384: CC_SHA384(mb, length, db)
                    case .sha512: CC_SHA512(mb, length, db)
                    }
                }
                return 0
            }
        }

        // return the value based on the specified output type.
        switch output {
        case .hex: return digest.map { String(format: "%02hhx", $0) }.joined()
        case .base64: return digest.base64EncodedString()
        }
    }
}

// Defines types of hash string outputs available
public enum HashOutputType {
    // standard hex string output
    case hex
    // base 64 encoded string output
    case base64
}

// Defines types of hash algorithms available
public enum HashType {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512

    var length: Int32 {
        switch self {
        case .md5: return CC_MD5_DIGEST_LENGTH
        case .sha1: return CC_SHA1_DIGEST_LENGTH
        case .sha224: return CC_SHA224_DIGEST_LENGTH
        case .sha256: return CC_SHA256_DIGEST_LENGTH
        case .sha384: return CC_SHA384_DIGEST_LENGTH
        case .sha512: return CC_SHA512_DIGEST_LENGTH
        }
    }
}

public extension String {

    /// Hashing algorithm for hashing a string instance.
    ///
    /// - Parameters:
    ///   - type: The type of hash to use.
    ///   - output: The type of output desired, defaults to .hex.
    /// - Returns: The requested hash output or nil if failure.
    func hashed(_ type: HashType, output: HashOutputType = .hex) -> String? {

        // convert string to utf8 encoded data
        guard let message = data(using: .utf8) else { return nil }
        return message.hashed(type, output: output)
    }
}

extension Notification.Name {
    /// 结束会话成功通知
    static let websocketConnectNotify = Notification.Name(rawValue:"websocketConnectNotify")
    static let biodataServicesSubscribeNotify = Notification.Name(rawValue:"biodataServicesSubscribeNotify")
    static let biodataServicesReportNotify = Notification.Name(rawValue:"biodataServicesReportNotify")
    static let biodataTagSubmitNotify = Notification.Name(rawValue: "biodataTagSubmitNotify")
    static let affectiveDataSubscribeNotify = Notification.Name(rawValue:"affectiveDataSubscribeNotify")
    static let affectiveDataReportNotify = Notification.Name(rawValue:"affectiveDataReportNotify")
}

// MARK: - NSData 扩展
extension Data {

    /// 获取完整数据的 range
    var fullRange: NSRange {
        return NSMakeRange(0, self.count)
    }

    /// 获取所有的字节
    var allBytes: Bytes {
        return try! self.bytesInRange(self.fullRange)
    }

    /**
     获取在某个范围内的字节序列

     - parameter range: NSRange 范围

     - throws: 如果 range 超出范围，可能抛出 `OutOfRangeError`

     - returns: 返回 range 范围内的字节序列
     */
    func bytesInRange(_ range: NSRange) throws -> [Byte] {
        if range.location + range.length > self.count {
            throw DataFileOutOfRangeError()
        }
        var thisBytes: [Byte] = [Byte](repeating: 0, count: range.length)
        (self as NSData).getBytes(&thisBytes, range: range)
        return thisBytes
    }

    /**
     获取指定位置的字节

     - parameter index: 位置索引

     - throws: 如果 index 超出范围，可能会抛出 `OutOfRangeError`

     - returns: 返回 index 位置的字节
     */
    func byteAtIndex(_ index: Int) throws -> Byte {
        if index >= self.count {
            throw DataFileOutOfRangeError()
        }
        var thisBytes: [Byte] = [0]
        (self as NSData).getBytes(&thisBytes, range: NSMakeRange(index, 1))
        return thisBytes[0]
    }
}

func unix_time() -> Timestamp {
    return Timestamp(Date().timeIntervalSince1970)
}

extension Array {
    /**
     连接数组的所有元素为字符串

     - parameter joinString: 连接字符串

     - returns: 连接后完整字符串
     */
    func componentsJoinedByString(_ joinString: String) -> String {
        return self.map {
            return String(describing: $0)
        }.joined(separator: joinString)
    }
}
