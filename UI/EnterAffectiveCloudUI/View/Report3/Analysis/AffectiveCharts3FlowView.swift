//
//  AffectiveCharts3Flow.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2022/8/31.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import DGCharts
import UIKit

public class AffectiveCharts3FlowLineView: UIView {
    
    public required init(colors: [UIColor], data: [Double], labelCount: Int = 3, date: Date?=nil, state: [Int]?=nil, max: Double?=nil, min: Double?=nil, quality: [Int]? = nil, isShowQuality: Bool = false) {
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
        self.isShowQuality = isShowQuality
        sample = data.count / maxDataCount == 0 ? 1 : Int(ceilf(Float(data.count) / Float(maxDataCount)))
        if let quality = quality {
            self.qualityValue.removeAll()
            var qualityTmp = quality
            if data.count > 0 { // 比对数组是否一致
                if qualityTmp.count < data.count {
                    let len = data.count - qualityTmp.count
                    let appendMore = Array<Int>.init(repeating: 0, count: len)
                    qualityTmp.append(contentsOf: appendMore)
                }
            }
            var apartCount = 0
            if qualityTmp.count < 40 {
                apartCount = qualityTmp.count
            } else {
                apartCount = 40
            }
            let devide = Int(ceil(Double(qualityTmp.count) / Double(apartCount)))
            for i in stride(from: 0, to: qualityTmp.count, by: devide) {
                var apart = qualityTmp[i..<devide+i]
                if qualityTmp.count - (i+devide) < devide {
                    apart.append(contentsOf: qualityTmp[i+devide..<qualityTmp.count])
                }
                let pass = apart.filter { value in
                    value > 1
                }
                let percent = Double(pass.count) / Double(apart.count)
                if percent > 0.7 {
                    qualityValue.append(true)
                } else {
                    qualityValue.append(false)
                }
                if qualityTmp.count - (i+devide) < devide {
                    break
                }
            }
        }
        
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
    internal var isShowQuality: Bool = false
    var colors: [UIColor] = [.black, .lightGray, .red, .green, .blue]
    
    var state: [Int]?
    
    var dataSource: [Double] = []
    
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
        let invalidData = 1.0
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
        } else {
            
        }
        for i in stride(from: 0, to: len, by: sample) {
            sampleArray.append(dataSource[i])
        }
        var smoothArray: [Double]
        if stateArray.count > 0 {
            smoothArray = sampleArray.smoothData()
        } else {
            smoothArray = sampleArray.smoothData(invalidValue: 100)
        }
        

        var yVals: [ChartDataEntry] = []
        var lineColor: [UIColor] = []
        var parts = 0.0
        let devide = qualityValue.count
        if devide > 0 {
            parts = Double(smoothArray.count) / Double(devide)
        }
        var index = 1
        for i in stride(from: 0, to: smoothArray.count, by: 1) {
            if isShowQuality {
                if sampleArray[i] < invalidData { //如果为无效数据
                    lineColor.append(colors[4])
                } else {
                    if parts > 0.0 { //显示质量
                        if Double(index) * parts < Double(i) {
                            index += 1
                        }
                        if index - 1 >= devide {
                            index = devide
                        }
                        if qualityValue[index-1] { //数据质量判断
                            if stateArray.count > 0 {
                                if stateArray[i] > 0 {
                                    lineColor.append(colors[3])
                                } else {
                                    lineColor.append(colors[2])
                                }
                            } else {
                                lineColor.append(colors[2])
                            }
                        } else {
                            lineColor.append(colors[4])
                        }
                    } else {
                        if stateArray.count > 0 {
                            if stateArray[i] > 0 {
                                lineColor.append(colors[3])
                            } else {
                                lineColor.append(colors[2])
                            }
                        } else {
                            lineColor.append(colors[2])
                        }
                    }
                    
                }
            } else {
                if stateArray.count > 0 {
                    if stateArray[i] > 0 {
                        lineColor.append(colors[3])
                    } else {
                        lineColor.append(colors[2])
                    }
                } else {
                    lineColor.append(colors[2])
                }
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

    }
}
