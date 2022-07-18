//
//  AffectiveChart3CommonXRender.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveChart3CommonXRender: XAxisRenderer {
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
            position.x = CGFloat(entry-0.5)
            position.y = CGFloat(entry)
            position = position.applying(valueToPixelMatrix)
            
            drawGridLine(context: context, x: position.x, y: position.y)
        }
    }
    
}
