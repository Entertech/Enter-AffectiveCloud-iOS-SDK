//
//  limitYAxisRenderer.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/25.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class LimitYAxisRenderer: YAxisRenderer {
    open var entries: [Int]?
    override init(viewPortHandler: ViewPortHandler, yAxis: YAxis?, transformer: Transformer?) {
        super.init(viewPortHandler: viewPortHandler, yAxis: yAxis, transformer: transformer)
    }

    /// draws the y-axis labels to the screen
     open override func renderAxisLabels(context: CGContext)
     {
         guard let yAxis = self.axis as? YAxis else { return }
         
         if !yAxis.isEnabled || !yAxis.isDrawLabelsEnabled
         {
             return
         }
         
         let xoffset = yAxis.xOffset
         let yoffset = yAxis.labelFont.lineHeight / 2.5 + yAxis.yOffset
         
         let dependency = yAxis.axisDependency
         let labelPosition = yAxis.labelPosition
         
         var xPos = CGFloat(0.0)
         
         var textAlign: NSTextAlignment
         
         if dependency == .left
         {
             if labelPosition == .outsideChart
             {
                 textAlign = .right
                 xPos = viewPortHandler.offsetLeft - xoffset
             }
             else
             {
                 textAlign = .left
                 xPos = viewPortHandler.offsetLeft + xoffset
             }
             
         }
         else
         {
             if labelPosition == .outsideChart
             {
                 textAlign = .left
                 xPos = viewPortHandler.contentRight + xoffset
             }
             else
             {
                 textAlign = .right
                 xPos = viewPortHandler.contentRight - xoffset
             }
         }
         
         etDrawYLabels(
             context: context,
             fixedPosition: xPos,
             positions: transformedPositions(),
             offset: yoffset - yAxis.labelFont.lineHeight,
             textAlign: textAlign)
     }
    
    override func transformedPositions() -> [CGPoint] {
        guard let yAxis = self.axis as? YAxis,
            let transformer = self.transformer, let entries = entries
            else { return [CGPoint]() }
        
        var positions = [CGPoint]()
        positions.reserveCapacity(yAxis.entryCount)
        
        for i in stride(from: 0, to: entries.count, by: 1)
        {
            positions.append(CGPoint(x: 0.0, y: Double(entries[i])))
        }

        transformer.pointValuesToPixel(&positions)
        
        return positions
    }
    
 
    func etDrawYLabels(
        context: CGContext,
        fixedPosition: CGFloat,
        positions: [CGPoint],
        offset: CGFloat,
        textAlign: NSTextAlignment)
    {
        guard
            let yAxis = self.axis as? YAxis, let entries = entries
            else { return }
        
        let labelFont = yAxis.labelFont
        let labelTextColor = yAxis.labelTextColor
        
        let from = 0
        let to = entries.count
        
        for i in stride(from: from, to: to, by: 1)
        {
            let text = "\(entries[i])"
            ChartUtils.drawText(
                context: context,
                text: text,
                point: CGPoint(x: fixedPosition, y: positions[i].y + offset),
                align: textAlign,
                attributes: [.font: labelFont, .foregroundColor: labelTextColor]
            )
        }
    }
    
    override func renderLimitLines(context: CGContext) {
        guard
            let yAxis = self.axis as? YAxis,
            let transformer = self.transformer
            else { return }
        
        var limitLines = yAxis.limitLines
        
        if limitLines.count == 0
        {
            return
        }
        
        context.saveGState()
        
        let trans = transformer.valueToPixelMatrix
        
        var position = CGPoint(x: 0.0, y: 0.0)
        
        for i in 0 ..< limitLines.count
        {
            let l = limitLines[i]
            
            if !l.isEnabled
            {
                continue
            }
            
            context.saveGState()
            defer { context.restoreGState() }
            
            var clippingRect = viewPortHandler.contentRect
            clippingRect.origin.y -= l.lineWidth / 2.0
            clippingRect.size.height += l.lineWidth
            context.clip(to: clippingRect)
            
            position.x = 0.0
            position.y = CGFloat(l.limit)
            position = position.applying(trans)
            
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: position.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: position.y))
            
            context.setStrokeColor(l.lineColor.cgColor)
            context.setLineWidth(l.lineWidth)
            if l.lineDashLengths != nil
            {
                context.setLineDash(phase: l.lineDashPhase, lengths: l.lineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            context.strokePath()
            
            let label = l.label
            
            // if drawing the limit-value label is enabled
            if l.drawLabelEnabled && label.count > 0
            {
                
                let labelLineHeight = l.valueFont.lineHeight
                let xOffset: CGFloat = 4.0 + l.xOffset
                let yOffset: CGFloat = l.lineWidth + labelLineHeight + l.yOffset
                
                if l.labelPosition == .topRight
                {
                    let path = UIBezierPath(roundedRect: CGRect(x: viewPortHandler.contentRight - xOffset - 55, y: position.y - yOffset - 4, width: 62, height: 22), cornerRadius: 11)
                    
                    context.addPath(path.cgPath)
                    if #available(iOS 13.0, *) {
                        context.setFillColor(UIColor.systemBackground.changeAlpha(to: 0.8).cgColor)
                        l.valueTextColor = .label
                    } else {
                        context.setFillColor(UIColor.white.changeAlpha(to: 0.8).cgColor)
                        l.valueTextColor = .black
                        // Fallback on earlier versions
                    }
                    context.fillPath()
                    
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y - yOffset),
                        align: .right,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
                else if l.labelPosition == .bottomRight
                {
                    let path = UIBezierPath(roundedRect: CGRect(x: viewPortHandler.contentRight - xOffset - 55, y: position.y + yOffset - 12, width: 62, height: 22), cornerRadius: 11)
                    
                    context.addPath(path.cgPath)
                    if #available(iOS 13.0, *) {
                        context.setFillColor(UIColor.systemBackground.changeAlpha(to: 0.8).cgColor)
                        l.valueTextColor = .label
                    } else {
                        context.setFillColor(UIColor.white.changeAlpha(to: 0.8).cgColor)
                        l.valueTextColor = .black
                        // Fallback on earlier versions
                    }
                    context.fillPath()
                    
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .right,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
                else if l.labelPosition == .topLeft
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y - yOffset),
                        align: .left,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
                else
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .left,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
            }
        }
        
        context.restoreGState()
    }
}
/// Y轴描述
public class YValueFormatter: NSObject, IAxisValueFormatter {
    private var labels: [Double] = [];
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - timeStamps: 列表
    public override init() {
        super.init()
    }
    
    public init(values: [Int]) {
        super.init()
        for e in values {
            labels.append(Double(e))
        }
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        axis?.entryCount 
        axis?.entries = self.labels
        return "\(Int(value))"
    }
}

