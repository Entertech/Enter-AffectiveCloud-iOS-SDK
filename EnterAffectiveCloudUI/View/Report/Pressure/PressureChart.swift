//
//  PressureChart.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/17.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class PressureChart: UIView {

    private var _pressreArray: [Float] = []
    
    public var chartColor: UIColor = UIColor(red: 1.0, green: 102.0/255.0, blue: 130.0/255.0, alpha: 1)
    
    public var xAxisLabelColor: UIColor = UIColor.gray
    
    public var timeStamp = 0
    
    public var pressureArray: [Float] {
        get {
            return _pressreArray
        }
        set {
            _pressreArray = newValue
            self.setNeedsDisplay()
        }
    }
    private let interval: CGFloat = 0.8
    public var valueCount: Int = 0
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if pressureArray.count > 0 {
            let context = UIGraphicsGetCurrentContext()!
            let viewSize = self.frame.size
            let width: CGFloat = 266.0
            let originX = (viewSize.width - width) / 2
            let minWidth = width / CGFloat(pressureArray.count)
            var initIndex = 0
            for i in stride(from: 0, to: pressureArray.count, by: 1) {
                if pressureArray[i] > 0 {
                    initIndex = i
                    break
                }
            }
            for (index, e) in pressureArray.enumerated() {
                let colorAlpha: CGFloat = CGFloat(e) / 100.0
                var color: UIColor?
                if index < initIndex {
                    color = #colorLiteral(red: 0.9, green: 0.90, blue: 0.90, alpha: 0.7)
                } else {
                    var red:CGFloat   = 0.0
                    var green:CGFloat = 0.0
                    var blue:CGFloat  = 0.0
                    var alpha:CGFloat = 0.0
                    chartColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                    color = UIColor(red: red, green: green, blue: blue, alpha: colorAlpha)
                }
                let rect = CGRect(x: originX+CGFloat(index)*minWidth, y: 0, width: minWidth, height: 40.0)
                context.setFillColor(color!.cgColor)
                context.fill(rect)
                context.fillPath()
            }
            drawLabel(context)
        }
    }
    
    ///画时间
    ///
    /// - Parameters:
    ///   - context: context description
    private func drawLabel(_ context: CGContext) {
        let viewSize = self.frame.size
        let originY: CGFloat = viewSize.height - 16
        let originX: CGFloat = (viewSize.width - 266.0) / 2
        var timestamps: [String] = []
        let timeCount = CGFloat(valueCount) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        if timeStamp != 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            for i in stride(from: 0, to: Int(timeCount), by: minTime) {
                let time = i + timeStamp
                let date = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
                timestamps.append(date)
            }
        } else {
            for i in stride(from: 0, to: Int(timeCount), by: minTime) {
                timestamps.append("\(Int(i / 60))")
            }
        }
        
        
        
        
        var drawAttributes = [NSAttributedString.Key : AnyObject]()
        var paragraphStyle: NSMutableParagraphStyle?
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        paragraphStyle?.alignment = .center
        drawAttributes.removeAll()
        drawAttributes[.font] = UIFont.systemFont(ofSize: 12)
        drawAttributes[.paragraphStyle] = paragraphStyle
        drawAttributes[.foregroundColor] = xAxisLabelColor
        if timestamps.count > 0 {
            let average = 266.0 / CGFloat(timestamps.count-1)
            context.saveGState()
            UIGraphicsPushContext(context)
            
            for (index, value) in timestamps.enumerated() {
                let nsLabel: NSString = value as NSString
                let labelSize = value.size(withAttributes: drawAttributes)
                nsLabel.draw(at: CGPoint(x: originX + CGFloat(index) * average - CGFloat(labelSize.width / 2.0), y: originY), withAttributes: drawAttributes)
            }
            
            UIGraphicsPopContext()
            
            context.restoreGState()
        }
    }
}

