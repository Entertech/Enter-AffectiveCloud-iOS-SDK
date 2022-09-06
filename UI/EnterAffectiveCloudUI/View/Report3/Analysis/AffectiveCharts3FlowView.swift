//
//  AffectiveCharts3Flow.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2022/8/31.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts
import UIKit

public class AffectiveCharts3FlowLineView: UIView {
    
    public required init(colors: [UIColor], data: [Double], date: Date?=nil, state: [Int]?=nil, max: Double?=nil, min: Double?=nil) {
        super.init(frame: CGRect.zero)
        guard colors.count >= 3 else {return}
        self.colors.removeAll()
        self.colors.append(contentsOf: colors)
        self.dataSource.append(contentsOf: data)
        self.state = state
        self.startDate = date
        self.maxValue = max
        self.minValue = min
        sample = data.count / maxDataCount == 0 ? 1 : data.count / maxDataCount
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    internal var sample = 3
    internal var maxDataCount = 100
    internal var interval = 0.6
    
    var colors: [UIColor] = [.black, .lightGray, .red, .green, .blue]
    
    var state: [Int]?
    
    var dataSource: [Double] = []
    
    var startDate: Date?
    
    var maxValue: Double?
    
    var minValue: Double?
    
    private let chartView = LineChartView()
    
    func initChart() {
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesBehindDataEnabled = true
        if let maxValue = maxValue {
            chartView.leftAxis.axisMaximum = maxValue
        }
        if let minValue = minValue {
            chartView.leftAxis.axisMinimum = minValue
        }
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelTextColor = colors[0]
        chartView.xAxis.axisMinLabels = 3
        chartView.xAxis.axisMaxLabels = 6
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.axisLineColor = colors[1]
        chartView.xAxis.axisLineWidth = 1
        
        chartView.dragEnabled = false
        chartView.scaleXEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.xAxis.valueFormatter = AffectiveCharts3HourValueFormatter(start: startDate)
        chartView.backgroundColor = .clear
        chartView.gridBackgroundColor = .clear
        chartView.drawBordersEnabled = false
        chartView.chartDescription.enabled = false
        chartView.scaleYEnabled = false
        chartView.legend.enabled = false
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false
    }
    
    func setLine() {
        let invalidData = 5.0
        var initValue = 0.0 //初始数据
        var initIndex = 0 //开始有值索引位置
        for i in stride(from: 0, to: dataSource.count, by: sample) {
            let value = dataSource[i]
            if value > invalidData && initValue == 0 {
                initValue = value
                initIndex = i
                break
            }
        }
        var yVals: [ChartDataEntry] = []
        var lineColors: [UIColor] = []
        var len = dataSource.count
        if let state = state { // 避免长度不一致
            if state.count < len {
                len = state.count
            }
        }
        for i in stride(from: 0, to: len, by: sample) {
            
            if initIndex > i {
                lineColors.append(.clear)
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: initValue))
            } else {
                let value = dataSource[i]
                if value < invalidData {
                    
                } else {
                    if let state = state, state[i] > 0 {
                        lineColors.append(colors[3])
                    } else {
                        lineColors.append(colors[2])
                    }
                    
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: value))
                }
            }
        }
        let set = LineChartDataSet(entries: yVals, label: "")

        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.colors = lineColors
        set.drawIconsEnabled = false
        set.highlightEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView.data = data

    }
}
