//
//  AffectiveCharts3Pressure.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class AffectiveCharts3Pressure: AffectiveCharts3LineCommonView {
    
    public override func setTheme(_ theme: AffectiveChart3Theme) -> Self {
        self.theme = theme
        titleView.setTheme(theme)
            .build(isAlreadShow: isFullScreen)
        titleView.delegate = self
        self.backgroundColor = ColorExtension.bgZ1
        chartView.leftAxis.labelTextColor = ColorExtension.textLv2
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        chartView.leftAxis.gridColor = ColorExtension.lineLight
        chartView.leftAxis.gridLineWidth = 1
        chartView.leftAxis.gridLineCap = .round
        chartView.leftAxis.gridLineDashPhase = 2.0
        chartView.leftAxis.gridLineDashLengths = [2.0, 4.0]
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.labelPosition = .insideChart
        chartView.rightAxis.enabled = false
        chartView.leftAxis.valueFormatter = AffectiveCharts3PressureYFormatter()
        chartView.leftAxis.setLabelCount(5, force: true)
        
        chartView.xAxis.labelTextColor = ColorExtension.textLv2
        chartView.xAxis.gridColor = ColorExtension.lineLight
        chartView.xAxis.gridLineWidth = 1
        chartView.xAxis.gridLineCap = .round
        chartView.xAxis.gridLineDashLengths = [2.0, 4.0]
        chartView.xAxis.axisLineColor = ColorExtension.lineHard
        chartView.xAxis.axisLineWidth = 1
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisMaxLabels = 8
        chartView.xAxis.valueFormatter = AffectiveCharts3HourValueFormatter()
        return self
    }
    
    public override func setData(_ array: [Int]) -> Self {
        dataSorce.append(contentsOf: array)
        
        //计算抽样
        sample = array.count / maxDataCount == 0 ? 1 : array.count / maxDataCount
        
        chartView.leftAxis.axisMaximum = Double(100)
        chartView.leftAxis.axisMinimum = Double(0)
        separateY.append(0)
        separateY.append(25)
        separateY.append(50)
        separateY.append(75)
        separateY.append(100)

        
        return self
        
    }
    
    public override func setChartProperty() -> Self {
        chartView.delegate = self
        chartView.backgroundColor = .clear
        chartView.animate(xAxisDuration: 0.5)
        chartView.drawGridBackgroundEnabled = true
        chartView.gridBackgroundColor = .clear
        chartView.drawBordersEnabled = false
        chartView.borderColor = .green
        chartView.borderLineWidth = 2
        chartView.chartDescription.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.scaleXEnabled = isFullScreen
        chartView.scaleYEnabled = false
        chartView.legend.enabled = false
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false
        let press = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        press.minimumPressDuration = 0.3
        chartView.addGestureRecognizer(press)
        chartView.leftYAxisRenderer = AffectiveCharts3PressureYRender(viewPortHandler: chartView.viewPortHandler, axis: chartView.leftAxis, transformer: chartView.getTransformer(forAxis: .left))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let startColor = UIColor.colorWithHexString(hexColor: "FB9C98").changeAlpha(to: 0.5)
        let endColor = UIColor.colorWithHexString(hexColor: "5F76FF").changeAlpha(to: 0.5)
        guard let startColorComponents = startColor.cgColor.components else { return self}
        guard let endColorComponents = endColor.cgColor.components else { return  self}
        let colorComponents: [CGFloat]
                    = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        let locations:[CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: colorComponents,locations: locations,count: 2) else { return self}
        chartView.gridGradient = gradient
        
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
        for i in stride(from: 0, to: dataSorce.count, by: sample) {
            if initIndex > i {
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if dataSorce[i] > invalidData { //小于无效值的不做点
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(dataSorce[i])))
                }
            }
        }
        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.setColor(theme.themeColor)
        set.drawIconsEnabled = false
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = ColorExtension.lineLight
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView.data = data
    }
}


