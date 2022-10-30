//
//  AffectiveCharts3CoherenceView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class AffectiveCharts3CoherenceView: AffectiveCharts3LineCommonView {
    
    public override func setMarker() -> Self {

        return self
    }
    
    
    public override func build() {
        let invalidData = 5.0
        var stateArray = [Int]()
        var sampleArray = [Double]()
        var len = dataSorce.count
        if coherenceValue.count > 0 {
            
            for i in stride(from: 0, to: len, by: sample) {
                if i > coherenceValue.count-1 {
                    stateArray.append(0)
                } else {
                    stateArray.append(coherenceValue[i])
                }
            }
        }
        for i in stride(from: 0, to: len, by: sample) {
            sampleArray.append(Double(dataSorce[i]))
        }
        
        let smoothArray = sampleArray.smoothData()
        var yVals: [ChartDataEntry] = []
        var colors: [UIColor] = []
        
        for i in stride(from: 0, to: smoothArray.count, by: 1) {
            if stateArray[i] > 0 {
                colors.append(theme.themeColor)
            } else {
                colors.append(ColorExtension.lineLight)
            }

            if smoothArray[i] > invalidData { //小于无效值的不做点
                yVals.append(ChartDataEntry(x: Double(i*sample)*interval, y: Double(smoothArray[i])))
            }
            
        }
        
        let marker = AffectiveCharts3CommonMarkerView(theme: theme)
        marker.addInterval(anotherArray: stateArray)
        marker.chartView = chartView
        chartView.marker = marker

        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.setColors(colors, alpha: 1)
        set.drawIconsEnabled = false
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = ColorExtension.lineLight
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView.data = data
        yRender?.entries = separateY
    }
}
