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
    
    public required init(colors: [UIColor], data: [Double], labelCount: Int = 3, date: Date?=nil, state: [Int]?=nil, max: Double?=nil, min: Double?=nil) {
        super.init(frame: CGRect.zero)
        guard colors.count >= 3 else {return}
        self.colors.removeAll()
        self.colors.append(contentsOf: colors)
        self.dataSource.removeAll()
        self.dataSource.append(contentsOf: data)
        self.state = state
        self.startDate = date
        self.maxValue = max
        self.minValue = min
        sample = data.count / maxDataCount == 0 ? 1 : data.count / maxDataCount
        
        initChart()
        setLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    internal var sample = 3
    internal var maxDataCount = 2000
    internal var interval = 0.6
    
    var colors: [UIColor] = [.black, .lightGray, .red, .green, .blue]
    
    var state: [Int]?
    
    var dataSource: [Double] = []
    
    var startDate: Date?
    
    var maxValue: Double?
    
    var minValue: Double?
    
    var lableCount: Int = 3
    
    private let chartView = LineChartView()
    
    func initChart() {
        self.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesBehindDataEnabled = true
        chartView.leftAxis.drawLabelsEnabled = false
        if let maxValue = maxValue {
            chartView.leftAxis.axisMaximum = maxValue
        }
        if let minValue = minValue {
            chartView.leftAxis.axisMinimum = minValue
        }

        chartView.rightAxis.enabled = false
        chartView.xAxis.labelHeight = 14
        
        chartView.xAxis.labelTextColor = colors[0]
        chartView.xAxis.setLabelCount(lableCount, force: true)
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.axisLineColor = colors[1]
        chartView.xAxis.axisLineWidth = 1
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.animate(xAxisDuration: 2, easingOption: .easeInOutCubic)
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
        var stateArray = [Int]()
        var sampleArray = [Double]()
        var len = dataSource.count
        if let state = state {
            
            for i in stride(from: 0, to: len, by: sample) {
                if i > state.count-1 {
                    stateArray.append(0)
                } else {
                    stateArray.append(state[i])
                }
            }
        }
        for i in stride(from: 0, to: len, by: sample) {
            sampleArray.append(dataSource[i])
        }
        
        let smoothArray = sampleArray.smoothData()

        var yVals: [ChartDataEntry] = []
        var lineColors: [UIColor] = []
        for i in stride(from: 0, to: smoothArray.count, by: 1) {
            
            let value = smoothArray[i]
            if value < invalidData {
                
            } else {
                if stateArray.count > 0 {
                    if stateArray[i] > 0 {
                        lineColors.append(colors[3])
                    } else {
                        lineColors.append(colors[2])
                    }
                } else {
                    lineColors.append(colors[2])
                }
                
                yVals.append(ChartDataEntry(x: Double(i*sample)*interval, y: value))
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
