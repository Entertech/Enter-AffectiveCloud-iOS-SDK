//
//  ToolBox+Ex.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/8.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import CommonCrypto
import EnterAffectiveCloud

func DLog(_ items: Any...) {
    
    print("[FLOWTIME DEBUG]: \(items)")
    
}

/// 二维数组
public struct Array2D<T> {
    public let columns: Int
    public let rows: Int
    fileprivate var array: [T]
    
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows*columns)
    }
    
    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row*columns + column]
        }
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row*columns + column] = newValue
        }
    }
}

extension Notification.Name {
    /// 通知
    static let websocketConnectNotify = Notification.Name(rawValue:"websocketConnectNotify")
    static let biodataServicesSubscribeNotify = Notification.Name(rawValue:"biodataServicesSubscribeNotify")
    static let biodataServicesReportNotify = Notification.Name(rawValue:"biodataServicesReportNotify")
    static let affectiveDataSubscribeNotify = Notification.Name(rawValue:"affectiveDataSubscribeNotify")
    static let affectiveDataReportNotify = Notification.Name(rawValue:"affectiveDataReportNotify")
}

extension UIColor {
    static func colorWithInt(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    /// hex to UIColor FFFFFF  -> .white
    /// - Parameter hexColor: hexString like A0B0C0
    static func colorWithHexString(hexColor: String) -> UIColor {
        
        var cString = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // String should be 6
        if cString.count < 6 {
            return .black
            
        }
        
        if cString.hasPrefix("0X") {
            cString.removeFirst(2)
        }
        if cString.hasPrefix("#") {
            cString.removeFirst(1)
        }
        
        if cString.count != 6 {return .black}
        
        // Separate r g b Substrings
        let rStartIndex = cString.index(cString.startIndex, offsetBy: 0)
        let rEndIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[rStartIndex..<rEndIndex])
        
        let gStartIndex = cString.index(cString.startIndex, offsetBy: 2)
        let gEndIndex = cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[gStartIndex..<gEndIndex])
        
        let bStartIndex = cString.index(cString.startIndex, offsetBy: 4)
        let bEndIndex = cString.index(cString.startIndex, offsetBy: 6)
        let bString = String(cString[bStartIndex..<bEndIndex])
        
        // Scan values
        let rValue = UInt32(rString, radix: 16)
        let gValue = UInt32(gString, radix: 16)
        let bValue = UInt32(bString, radix: 16)
        
        if let r = rValue, let g = gValue, let b = bValue {
            return UIColor(red: CGFloat(r)/255.0
                , green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
        } else  {
            return .black
        }
        
    }
    
    func changeAlpha(to newAlpha: CGFloat) -> UIColor {
        var red:CGFloat   = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat  = 0.0
        var alpha:CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red, green: green, blue: blue, alpha: newAlpha)
    }
}

extension UIImage {
    /// GIF
    class func resolveGifImage(gif: String) -> [UIImage]{
        var images:[UIImage] = []
        let gifPath = Bundle.init(identifier: "org.cocoapods.EnterAffectiveCloudUI")?.path(forResource: gif, ofType: "gif")
        if gifPath != nil{
            if let gifData = try? Data(contentsOf: URL.init(fileURLWithPath: gifPath!)){
                let gifDataSource = CGImageSourceCreateWithData(gifData as CFData, nil)
                let gifcount = CGImageSourceGetCount(gifDataSource!)
                for i in 0...gifcount - 1{
                    let imageRef = CGImageSourceCreateImageAtIndex(gifDataSource!, i, nil)
                    let image = UIImage(cgImage: imageRef!)
                    images.append(image)
                }
            }
        }
        return images
    }
    
    class func loadImage(name: String) -> UIImage {
        return UIImage(named: name, in: Bundle.init(identifier: "org.cocoapods.EnterAffectiveCloudUI"), compatibleWith: nil)!
    }
}

// MARK: - Array 数组扩展
extension Array {
    
    /// 从数组中返回一个随机元素
    public var sample: Element? {
        //如果数组为空，则返回nil
        guard count > 0 else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
    
    /// 从数组中从返回指定个数的元素
    ///
    /// - Parameters:
    ///   - size: 希望返回的元素个数
    ///   - noRepeat: 返回的元素是否不可以重复（默认为false，可以重复）
    public func sample(size: Int, noRepeat: Bool = false) -> [Element]? {
        //如果数组为空，则返回nil
        guard !isEmpty else { return nil }
        
        var sampleElements: [Element] = []
        
        //返回的元素可以重复的情况
        if !noRepeat {
            for _ in 0..<size {
                sampleElements.append(sample!)
            }
        }
            //返回的元素不可以重复的情况
        else{
            //先复制一个新数组
            var copy = self.map { $0 }
            for _ in 0..<size {
                //当元素不能重复时，最多只能返回原数组个数的元素
                if copy.isEmpty { break }
                let randomIndex = Int(arc4random_uniform(UInt32(copy.count)))
                let element = copy[randomIndex]
                sampleElements.append(element)
                //每取出一个元素则将其从复制出来的新数组中移除
                copy.remove(at: randomIndex)
            }
        }
        
        return sampleElements
    }

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

    /**
     分隔数组为等量的子数组

     - parameter subSize: 子数组的 size

     - returns: 分割后的数组
     */
    func splitBy(_ subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map { startIndex in
            let endIndex = startIndex.advanced(by: subSize)
            return Array(self[startIndex ..< endIndex])
        }
    }
}

// MARK: - NSData 扩展
extension Data {

    /// 获取完整数据的 range
    var fullRange: NSRange {
        return NSMakeRange(0, self.count)
    }

}

func unix_time() -> Timestamp {
    return Timestamp(Date().timeIntervalSince1970)
}



