//
//  HighlightIcon.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/4/29.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

extension UIImage {
    /// 中间有颜色圆点，周围有阴影的icon
    class func highlightIcon(centerColor: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 15, height: 15)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.clear.cgColor)
        //// Color Declarations
        let color = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let color2 = centerColor

        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.lightGray
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 5

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 2.5, y: 2.5, width: 10, height: 10))
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        color.setFill()
        ovalPath.fill()
        context.restoreGState()



        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 4.5, y: 4.5, width: 6, height: 6))
        color2.setFill()
        oval2Path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
