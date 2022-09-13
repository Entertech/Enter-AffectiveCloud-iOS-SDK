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
    override init(viewPortHandler: ViewPortHandler, axis: YAxis, transformer: Transformer?) {
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: transformer)
    }

    override func transformedPositions() -> [CGPoint]
    {
        guard let entries = entries
            else { return [CGPoint]() }
        guard let transformer = self.transformer else { return [] }
        
//        var positions = axis.entries.map { CGPoint(x: 0.0, y: $0) }
        var positions = [CGPoint]()
        
        for i in stride(from: 0, to: entries.count, by: 1)
        {
            positions.append(CGPoint(x: 0.0, y: Double(entries[i])))
        }
        transformer.pointValuesToPixel(&positions)
        
        return positions
    }
    
    override func drawYLabels(
        context: CGContext,
        fixedPosition: CGFloat,
        positions: [CGPoint],
        offset: CGFloat,
        textAlign: TextAlignment)
    {
        guard let entries = entries
            else { return }
        let labelFont = axis.labelFont
        let labelTextColor = axis.labelTextColor
        
        let from = 0
        let to = entries.count
        
        let xOffset = axis.labelXOffset
        
        for i in from..<to
        {
            let text = "\(entries[i])"
            context.drawText(text,
                             at: CGPoint(x: fixedPosition + xOffset, y: positions[i].y + offset),
                             align: textAlign,
                             attributes: [.font: labelFont, .foregroundColor: labelTextColor])
        }
    }

    
    override func renderLimitLines(context: CGContext)
    {
        guard let transformer = self.transformer else { return }
        
        let limitLines = axis.limitLines
        
        guard !limitLines.isEmpty else { return }
        
        context.saveGState()
        defer { context.restoreGState() }
        
        let trans = transformer.valueToPixelMatrix
        
        var position = CGPoint(x: 0.0, y: 0.0)
        
        for l in limitLines where l.isEnabled
        {
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
            guard l.drawLabelEnabled, !label.isEmpty else { continue }
            
            let labelLineHeight = l.valueFont.lineHeight
            
            let xOffset = 4.0 + l.xOffset
            let yOffset = l.lineWidth + labelLineHeight + l.yOffset
            
            let align: TextAlignment
            let point: CGPoint
            
            switch l.labelPosition
            {
            case .rightTop:
                let path = UIBezierPath(roundedRect: CGRect(x: viewPortHandler.contentRight - xOffset - 75, y: position.y - yOffset - 4, width: 82, height: 22), cornerRadius: 11)
                
                context.addPath(path.cgPath)
                if #available(iOS 13.0, *) {
                    context.setFillColor(UIColor.systemBackground.changeAlpha(to: 0.6).cgColor)
                    l.valueTextColor = .label
                } else {
                    context.setFillColor(UIColor.white.changeAlpha(to: 0.6).cgColor)
                    l.valueTextColor = .black
                    // Fallback on earlier versions
                }
                context.fillPath()
                align = .right
                point = CGPoint(x: viewPortHandler.contentRight - xOffset,
                                y: position.y - yOffset)
                
            case .rightBottom:
                let path = UIBezierPath(roundedRect: CGRect(x: viewPortHandler.contentRight - xOffset - 55, y: position.y + yOffset - 18, width: 62, height: 22), cornerRadius: 11)
                
                context.addPath(path.cgPath)
                if #available(iOS 13.0, *) {
                    context.setFillColor(UIColor.systemBackground.changeAlpha(to: 0.6).cgColor)
                    l.valueTextColor = .label
                } else {
                    context.setFillColor(UIColor.white.changeAlpha(to: 0.6).cgColor)
                    l.valueTextColor = .black
                    // Fallback on earlier versions
                }
                context.fillPath()
                align = .right
                point = CGPoint(x: viewPortHandler.contentRight - xOffset,
                                y: position.y + yOffset - labelLineHeight)
                
            case .leftTop:
                align = .left
                point = CGPoint(x: viewPortHandler.contentLeft + xOffset,
                                y: position.y - yOffset)
                
            case .leftBottom:
                align = .left
                point = CGPoint(x: viewPortHandler.contentLeft + xOffset,
                                y: position.y + yOffset - labelLineHeight)
            }
            
            context.drawText(label,
                             at: point,
                             align: align,
                             attributes: [.font: l.valueFont, .foregroundColor: l.valueTextColor])
        }
    }
}
/// Y轴描述
public class YValueFormatter: NSObject, AxisValueFormatter {
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - timeStamps: 列表
    public override init() {
        super.init()
    }
    
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))%"
    }
}

