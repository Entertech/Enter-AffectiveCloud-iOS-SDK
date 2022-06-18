//
//  AffectiveCharts3DynamicYRender.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/17.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveCharts3DynamicYRender: YAxisRenderer {
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
}
