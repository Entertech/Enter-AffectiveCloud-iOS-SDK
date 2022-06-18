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

}
