//
//  AffectiveChartsTrainingTargetView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2024/1/31.
//  Copyright © 2024 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import DGCharts
import UIKit

public class AffectiveChartsTrainingTargetView: UIView {
    public required init(colors: [UIColor], data: [Double], labelCount: Int = 3, date: Date?=nil, state: [Int]?=nil, max: Double?=nil, min: Double?=nil, separateValue: Double? = nil, isLargerSeparate: Bool = false) {
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
        self.separateValue = separateValue
        self.isLargerSeparate = isLargerSeparate
        sample = data.count / maxDataCount == 0 ? 1 : Int(ceilf(Float(data.count) / Float(maxDataCount)))
        
        initChart()
        setLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    internal var sample = 3
    internal var maxDataCount = 2000
    internal var interval = 0.6
    internal var qualityValue: [Bool] = []
    var colors: [UIColor] = [.black, .lightGray, .red, .green, .blue]
    
    var state: [Int]?
    
    var dataSource: [Double] = []
    var separateValue: Double?
    var isLargerSeparate: Bool = false
    var startDate: Date?
    
    var maxValue: Double?
    
    var minValue: Double?
    
    var lableCount: Int = 3
    
    public let chartView = LineChartView()
    
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
        var stateArray = [Int]()
        var sampleArray = [Double]()
        let len = dataSource.count
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
        var smoothArray: [Double]
        if stateArray.count > 0 {
            smoothArray = sampleArray.smoothData()
        } else {
            if let max = maxValue {
                smoothArray = sampleArray.smoothData(invalidValue: 100)
            } else {
                smoothArray = sampleArray.smoothData()
            }
            
        }
        

        var yVals: [ChartDataEntry] = []
        var lineColor: [UIColor] = []
   
        for i in stride(from: 0, to: smoothArray.count, by: 1) {
            
            if stateArray.count > 0 {
                if stateArray[i] > 0 {
                    lineColor.append(colors[2])
                } else {
                    lineColor.append(colors[4])
                }
            } else {
                lineColor.append(colors[2])
            }
            
            let value = smoothArray[i]
            yVals.append(ChartDataEntry(x: Double(i*sample)*interval, y: value))
        }
        let set = LineChartDataSet(entries: yVals, label: "")

        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.colors = lineColor
        set.drawIconsEnabled = false
        set.highlightEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false

        let data = LineChartData(dataSet: set)
        chartView.data = data

        guard self.state == nil else {
            return
        }
        if let sep = self.separateValue {
            let limitLine = ChartLimitLine(limit: sep, label: "")
            limitLine.lineWidth = 2
            limitLine.lineColor = colors[2]
            limitLine.lineDashLengths = [2, 2]
            chartView.leftAxis.addLimitLine(limitLine)
            
            var dataMax: Double = 100
            var dataMin: Double = 0
            let validArray = sampleArray.filter({$0 > 0})
            if validArray.count > 0 {
                if let max = maxValue, let min = minValue {
                    dataMax = max
                    dataMin = min
                } else if let max = validArray.max(), let min = validArray.min() {
                    dataMax = max
                    dataMin = min
                }
            } else {
                if let max = maxValue, let min = minValue {
                    dataMax = max
                    dataMin = min
                } else {
                    dataMax = 0
                    dataMin = 0
                }
            }

            if sep < dataMax && sep > dataMin {
                if isLargerSeparate {
                    set.colors = [colors[2], colors[2], colors[4], colors[4]]
                    set.isDrawLineWithGradientEnabled = true
                    set.gradientPositions = [dataMin, sep, sep+0.01, dataMax]
                } else {
                    set.colors = [colors[4], colors[4], colors[2], colors[2]]
                    set.isDrawLineWithGradientEnabled = true
                    set.gradientPositions = [dataMin, sep, sep+0.01, dataMax]
                }

            } else if sep >= dataMax {
                chartView.leftAxis.axisMaximum = sep + 5
                if isLargerSeparate {
                    set.setColor(colors[2])
                } else {
                    set.setColor(colors[4])
                }
               
            } else if sep <= dataMin {
                chartView.leftAxis.axisMinimum = sep - 5
                if isLargerSeparate {
                    set.setColor(colors[4])
                } else {
                    set.setColor(colors[2])
                }
            }

        }
    }

}
