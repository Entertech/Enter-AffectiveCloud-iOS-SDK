//
//  ToolBox+Ex.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/8.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

extension Notification.Name {
    /// 通知
    static let websocketConnectNotify = Notification.Name(rawValue:"websocketConnectNotify")
    static let biodataServicesSubscribeNotify = Notification.Name(rawValue:"biodataServicesSubscribeNotify")
    static let biodataServicesReportNotify = Notification.Name(rawValue:"biodataServicesReportNotify")
    static let affectiveDataSubscribeNotify = Notification.Name(rawValue:"affectiveDataSubscribeNotify")
    static let affectiveDataReportNotify = Notification.Name(rawValue:"affectiveDataReportNotify")
}

extension UIColor {
    
    
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
        let gifPath = Bundle.init(identifier: "cn.entertech.EnterAffectiveCloudUI")?.path(forResource: gif, ofType: "gif")
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
}




