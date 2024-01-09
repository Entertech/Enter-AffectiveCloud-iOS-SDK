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
    
    internal func setupChart(_ param: AffectiveChartsSleepParameter) {
        self.backgroundColor = .clear
        leftAxis.labelTextColor = param.yAxisLabelColor ?? .black
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        leftAxis.gridColor = param.yGrideLineColor ?? .black
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridLineDashPhase = 2.0
        leftAxis.gridLineDashLengths = [2.0, 4.0]
        leftAxis.drawAxisLineEnabled = true
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
        
    }
    
    
    
    func resizeArray<T>(array: inout [T], toSize newSize: Int) {
        guard array.count > newSize else { return } // No need to remove elements if array size is already within the limit
        
        while array.count > newSize {
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            array.remove(at: randomIndex)
        }
    }
}

