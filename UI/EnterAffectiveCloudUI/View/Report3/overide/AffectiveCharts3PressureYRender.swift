//
//  AffectiveCharts3PressureYRender.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveCharts3PressureYRender: YAxisRenderer {

    override init(viewPortHandler: ViewPortHandler, axis: YAxis, transformer: Transformer?) {
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: transformer)
    }

    /// draws the y-axis labels to the screen
    override func renderAxisLabels(context: CGContext)
    {
        guard
            axis.isEnabled,
            axis.isDrawLabelsEnabled
            else { return }

        let xoffset = axis.xOffset
        let yoffset = axis.labelFont.lineHeight / 2.5 + axis.yOffset
        
        let dependency = axis.axisDependency
        let labelPosition = axis.labelPosition
        
        let xPos: CGFloat
        let textAlign: TextAlignment
        var yInnerOffset: CGFloat = 0 // pressure 在内部时需要设置偏移
        
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
                yInnerOffset =  axis.labelFont.lineHeight
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
        
        drawYLabels(context: context,
                    fixedPosition: xPos,
                    positions: transformedPositions(),
                    offset: yoffset - axis.labelFont.lineHeight + yInnerOffset,
                    textAlign: textAlign)
    }

    
    override func renderGridLines(context: CGContext) {
        guard axis.isEnabled else { return }

        if axis.drawGridLinesEnabled
        {
            let positions = transformedPositions()
            
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
            
            // draw the grid
            positions.forEach {
                if $0 != positions.first {
                    drawGridLine(context: context, position: $0)
                }
                
            }
        }

        if axis.drawZeroLineEnabled
        {
            // draw zero line
            drawZeroLine(context: context)
        }
    }
    


}
