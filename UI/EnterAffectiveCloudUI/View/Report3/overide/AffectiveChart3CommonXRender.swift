//
//  AffectiveChart3CommonXRender.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveChart3CommonXRender: XAxisRenderer {
    var isMonth = false
    override init(viewPortHandler: ViewPortHandler, axis: XAxis, transformer: Transformer?) {
        
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: transformer)
    }

    
    open override func renderGridLines(context: CGContext)
    {
        guard
            let transformer = self.transformer,
            axis.isEnabled,
            axis.isDrawGridLinesEnabled
            else { return }
        
        context.saveGState()
        defer { context.restoreGState() }

        context.clip(to: self.gridClippingRect)
        
        context.setShouldAntialias(axis.gridAntialiasEnabled)
        context.setStrokeColor(axis.gridColor.cgColor)
        context.setLineWidth(axis.gridLineWidth)
        context.setLineCap(axis.gridLineCap)
        
        if axis.gridLineDashLengths != nil
        {
            context.setLineDash(phase: axis.gridLineDashPhase, lengths: axis.gridLineDashLengths)
        }
        else
        {
            context.setLineDash(phase: 0.0, lengths: [])
        }
        
        let valueToPixelMatrix = transformer.valueToPixelMatrix
        
        var position = CGPoint.zero
        
        let entries = axis.entries
        
        for entry in entries
        {
            if isMonth {
                position.x = CGFloat(entry-0.5)
            } else {
                position.x = CGFloat(entry-0.5)
            }
            
            position.y = CGFloat(entry)
            position = position.applying(valueToPixelMatrix)
            
            drawGridLine(context: context, x: position.x, y: position.y)
        }
    }
    
    /// draws the x-labels on the specified y-position
    override func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint)
    {
        guard let transformer = self.transformer else { return }
        
        let paraStyle = ParagraphStyle.default.mutableCopy() as! MutableParagraphStyle
        paraStyle.alignment = .center
        
        let labelAttrs: [NSAttributedString.Key : Any] = [.font: axis.labelFont,
                                                         .foregroundColor: axis.labelTextColor,
                                                         .paragraphStyle: paraStyle]

        let labelRotationAngleRadians: CGFloat = 0
        let isCenteringEnabled = axis.isCenterAxisLabelsEnabled
        let valueToPixelMatrix = transformer.valueToPixelMatrix

        var position = CGPoint.zero
        var labelMaxSize = CGSize.zero
        
        if axis.isWordWrapEnabled
        {
            labelMaxSize.width = axis.wordWrapWidthPercent * valueToPixelMatrix.a
        }
        
        let entries = axis.entries
        
        for i in entries.indices
        {
            let px = isCenteringEnabled ? CGFloat(axis.centeredEntries[i]) : CGFloat(entries[i])
            position = CGPoint(x: px, y: 0)
                .applying(valueToPixelMatrix)

            guard viewPortHandler.isInBoundsX(position.x) else { continue }
            
            let label = axis.valueFormatter?.stringForValue(axis.entries[i], axis: axis) ?? ""
            let labelns = label as NSString
            
            if axis.isAvoidFirstLastClippingEnabled
            {
                // avoid clipping of the last
                if i == axis.entryCount - 1 && axis.entryCount > 1
                {
                    let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                    
                    if width > viewPortHandler.offsetRight * 2.0,
                        position.x + width > viewPortHandler.chartWidth
                    {
                        position.x -= width / 2.0
                    }
                }
                else if i == 0
                { // avoid clipping of the first
                    let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                    position.x += width / 2.0
                }
            }
            
            drawLabel(context: context,
                      formattedLabel: label,
                      x: position.x,
                      y: pos,
                      attributes: labelAttrs,
                      constrainedTo: labelMaxSize,
                      anchor: anchor,
                      angleRadians: labelRotationAngleRadians)
        }
    }
    
}


