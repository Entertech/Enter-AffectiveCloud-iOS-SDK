//
//  AffectiveCharts3CoherenceView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts

public class AffectiveCharts3CoherenceView: AffectiveCharts3LineCommonView {
    
    public override func setMarker() -> Self {

        
        
        return self
    }
    
    
    public override func build() {
        let invalidData = 5
        var initValue = 0 //初始数据
        var initIndex = 0 //开始有值索引位置
        for i in stride(from: 0, to: dataSorce.count, by: sample) {
            let value = dataSorce[i]
            if value > invalidData && initValue == 0 {
                initValue = value
                initIndex = i
                break
            }
        }
        var yVals: [ChartDataEntry] = []
        var colors: [UIColor] = []
        var cohereceArray = [Int]()
        for i in stride(from: 0, to: dataSorce.count, by: sample) {
            cohereceArray.append(coherenceValue[i])
            if coherenceValue[i] > 0 {
                colors.append(theme.themeColor)
            } else {
                colors.append(ColorExtension.lineLight)
            }
            if initIndex > i {
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if dataSorce[i] > invalidData { //小于无效值的不做点
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(dataSorce[i])))
                }
            }
        }
        
        let marker = AffectiveCharts3CommonMarkerView(theme: theme)
        marker.addInterval(anotherArray: cohereceArray)
        marker.chartView = chartView
        chartView.marker = marker

        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .horizontalBezier
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
