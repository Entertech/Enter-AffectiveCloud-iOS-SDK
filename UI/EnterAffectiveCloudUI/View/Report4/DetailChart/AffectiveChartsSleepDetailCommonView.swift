//
//  AffectiveChartsSleepDetailCommonView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/12/13.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts
import SnapKit

public class AffectiveChartsSleepDetailCommonView: LineChartView {

    internal var chartParam: AffectiveChartsSleepParameter? {
        didSet {
            if let param = chartParam {
                self.setupChart(param)
            }
        }
    }
    internal var yRender: AffectiveChartsSleepStageYRender!
    
    internal func setupChart(_ param: AffectiveChartsSleepParameter) {
        self.backgroundColor = .clear
        leftAxis.labelTextColor = param.yAxisLabelColor ?? .black
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        leftAxis.gridColor = param.yGrideLineColor ?? .black
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridLineDashPhase = 2.0
        leftAxis.gridLineDashLengths = [2.0, 2.0]
        leftAxis.drawAxisLineEnabled = false
        leftAxis.axisLineWidth = 1
        leftAxis.axisLineDashPhase = 4
        leftAxis.axisLineDashLengths = [4.0, 6.0]
        leftAxis.axisLineColor = param.xAxisLineColor ?? .black
        leftAxis.drawGridLinesBehindDataEnabled = true
        leftAxis.labelPosition = .insideChart
        rightAxis.enabled = false
        
        xAxis.labelTextColor = param.xAxisLabelColor ?? .black
        xAxis.gridColor = param.xGrideLineColor ?? .black
        xAxis.gridLineWidth = 0.5
        xAxis.gridLineDashLengths = [2.0, 4.0]
        xAxis.axisLineColor = param.xAxisLineColor ?? .black
        xAxis.axisLineWidth = 1
        xAxis.valueFormatter = AffectiveChartsSleepHourValueFormatter(start: param.start, end: param.end)
        xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        xAxis.labelPosition = .bottom
        xAxis.avoidFirstLastClippingEnabled = true
        backgroundColor = .clear
        gridBackgroundColor = .clear
        drawBordersEnabled = false
        chartDescription.enabled = false
        pinchZoomEnabled = false
        scaleXEnabled = false
        scaleYEnabled = false
        legend.enabled = false
        highlightPerTapEnabled = false
        dragEnabled = false
        yRender = AffectiveChartsSleepStageYRender(viewPortHandler: self.viewPortHandler, axis: self.leftAxis, transformer: self.getTransformer(forAxis: .left))
        self.leftYAxisRenderer = yRender
    }
    
    
    
    func resizeArray<T>(array: inout [T], toSize newSize: Int) {
        guard array.count > newSize else { return } // No need to remove elements if array size is already within the limit
        
        while array.count > newSize {
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            array.remove(at: randomIndex)
        }
    }
}


class AffectiveChartsSleepStageYRender: YAxisRenderer {
    open var entries: [Int]?
    override init(viewPortHandler: ViewPortHandler, axis: YAxis, transformer: Transformer?) {
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: transformer)
    }
    
    override func transformedPositions() -> [CGPoint]
    {
        
        if let entries = entries {
            guard let transformer = self.transformer else { return [] }
            
            var positions = [CGPoint]()
            
            for i in stride(from: 0, to: entries.count, by: 1)
            {
                positions.append(CGPoint(x: 0.0, y: Double(entries[i])))
            }
            transformer.pointValuesToPixel(&positions)
            
            return positions
        } else {
            return super.transformedPositions()
            
        }


    }

    /// draws the y-axis labels to the screen
    override func renderAxisLabels(context: CGContext)
    {
        guard
            axis.isEnabled,
            axis.isDrawLabelsEnabled
            else { return }
        if let entries = entries {
            axis.entries.removeAll()
            axis.entries.append(contentsOf: entries.map({Double($0)}))
        }
        let xoffset = axis.xOffset
        let yoffset = axis.labelFont.lineHeight / 2.5 + axis.yOffset
        
        let dependency = axis.axisDependency
        let labelPosition = axis.labelPosition
        
        let xPos: CGFloat
        let textAlign: TextAlignment
        
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
        
        drawYLabels(context: context,
                    fixedPosition: xPos,
                    positions: transformedPositions(),
                    offset: yoffset - axis.labelFont.lineHeight,
                    textAlign: textAlign)
    }
    
    /// draws the y-labels on the specified x-position
    override func drawYLabels(
        context: CGContext,
        fixedPosition: CGFloat,
        positions: [CGPoint],
        offset: CGFloat,
        textAlign: TextAlignment)
    {
        let labelFont = axis.labelFont
        let labelTextColor = axis.labelTextColor
        
        let from = axis.isDrawBottomYLabelEntryEnabled ? 0 : 1
        let to = axis.isDrawTopYLabelEntryEnabled ? axis.entryCount : (axis.entryCount - 1)
        
        let xOffset = axis.labelXOffset
        var yOffset: CGFloat = 8
        for i in from..<to
        {
            let text = axis.getFormattedLabel(i)
            context.drawText(text,
                             at: CGPoint(x: fixedPosition + xOffset, y: positions[i].y + offset + yOffset),
                             align: textAlign,
                             attributes: [.font: labelFont, .foregroundColor: labelTextColor])
        }
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
