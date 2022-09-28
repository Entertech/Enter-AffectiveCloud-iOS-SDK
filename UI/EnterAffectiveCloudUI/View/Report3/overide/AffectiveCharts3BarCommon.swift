//
//  AffectiveCharts3BarCommon.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/17.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveCharts3RoundCornerBar: BarChartView {
    var theme: AffectiveChart3Theme! 
    
    weak var dataSouceChanged: AffectiveCharts3ChartChanged?
    private var yRender: AffectiveCharts3DynamicYRender?
    internal var lastXValue: Double = 0
    internal var dataList: [Double] = []
    
    init(theme: AffectiveChart3Theme) {
        super.init(frame: CGRect.zero)
        self.theme = theme
        self.drawBarShadowEnabled = false
        self.drawValueAboveBarEnabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.dragXEnabled = true
        self.dragYEnabled = false
        self.highlightPerTapEnabled = false
        self.highlightPerDragEnabled = false
        self.dragDecelerationEnabled = false
        self.xAxisRenderer = AffectiveChart3CommonXRender(viewPortHandler: self.viewPortHandler, axis: self.xAxis, transformer: self.getTransformer(forAxis: .left))

        self.extraTopOffset = 92
        self.legend.enabled = false
        self.leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
        self.leftAxis.labelTextColor = ColorExtension.textLv2
        self.leftAxis.gridColor = ColorExtension.lineLight
        self.leftAxis.gridLineWidth = 0.5
        self.leftAxis.gridLineCap = .round
        self.leftAxis.gridLineDashPhase = 2.0
        self.leftAxis.gridLineDashLengths = [3.0, 2.0]
        self.leftAxis.drawAxisLineEnabled = false
        self.leftAxis.drawGridLinesBehindDataEnabled = true
        self.leftAxis.axisMinimum = 0
        self.rightAxis.enabled = false
        
        self.xAxis.labelTextColor = ColorExtension.textLv2
        self.xAxis.gridColor = ColorExtension.lineLight
        self.xAxis.gridLineWidth = 0.5
        self.xAxis.gridLineCap = .round
        self.xAxis.gridLineDashLengths = [2.0, 4.0]
        self.xAxis.axisLineColor = ColorExtension.lineLight
        self.xAxis.drawGridLinesBehindDataEnabled = true
        self.xAxis.axisLineWidth = 0.5
        self.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        self.xAxis.labelPosition = .bottom
        
        

        switch theme.style {
        case .session:
            self.dragEnabled = false
            xAxis.valueFormatter = AffectiveCharts3HourValueFormatter()
            
        case .month:
            self.dragEnabled = true
            xAxis.valueFormatter = AffectiveCharts3DayValueFormatter(originDate: Date.init(timeIntervalSince1970: theme.startTime))
        case .year:
            self.dragEnabled = true
            xAxis.valueFormatter = AffectiveCharts3MonthValueFormatter(originDate: Date.init(timeIntervalSince1970: theme.startTime))

        }
        
        let marker = AffectiveCharts3CommonMarkerView(theme: theme)
        marker.chartView = self
        self.marker = marker
        
        yRender = AffectiveCharts3DynamicYRender(viewPortHandler: self.viewPortHandler, axis: self.leftAxis, transformer: self.getTransformer(forAxis: .left))
        self.leftYAxisRenderer = yRender!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var last: Double = 0
    func setDataCount(value: [Double]) {
        dataList.removeAll()
        dataList.append(contentsOf: value)
        var yVals = [BarChartDataEntry]()
        for e in 0..<value.count {
            let yVal = BarChartDataEntry(x: Double(e), y: value[e])
            yVals.append(yVal)
        }
        
        var set1: BarChartDataSet! = nil
        if let set = self.data?.first as? BarChartDataSet {
            set1 = set
            set1.roundedCorners = [.topLeft, .topRight]
            set1.replaceEntries(yVals)
            self.data?.notifyDataChanged()
            self.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "The year")
            set1.roundedCorners = [.topLeft, .topRight]
            set1.colors = [theme.themeColor]
            set1.drawValuesEnabled = false
            let data = BarChartData(dataSet: set1)
            if theme.style == .month {
                data.barWidth = 0.6
            } else {
                data.barWidth = 0.8
            }
            self.data = data
            
        }
        if theme.style == .month {
            self.setVisibleXRangeMaximum(31)
        } else if theme.style == .year {
            self.setVisibleXRangeMaximum(12)
        }

        
        if let last = yVals.last {
            self.moveViewToX(last.x)
            self.lastXValue = last.x
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: {
            self.overloadY()
        })
        
        
    }
    
    
    
    func overloadY() {
        let leftX = Int(round(self.lowestVisibleX) - self.chartXMin)
        let rightX = Int(round(self.highestVisibleX) - self.chartXMin)
        var maxValue: Double = 0
        for i in leftX..<rightX {
            if let value = self.barData?.dataSets.first?.entryForIndex(i) {
                if value.y > maxValue {
                    maxValue = value.y
                }
            }
        }
        setYLable(maxY: maxValue)
    }
    
    private func setYLable(maxY: Double) {
        var gotIt: Double = 0
        var part: Int = 0
        var limitArray: [Int] = []
        if maxY <= 4 {
            gotIt = 4
            part = 4
        } else if maxY <= 8 {
            gotIt = 8
            part = 4
        } else {
            for i in 0...10 {
                let value = 10 * Int(round(maxY / 10.0)) + 10 + i*5

                for e in 4...5 {
                    if value % e == 0 && (value / e) % 5 == 0{
                        
                        gotIt = Double(value)
                        part = e
                        break
                    }
                }
                if gotIt > 0 {
                    break
                }
            }
        }

        
        guard part > 1 else {return}
        self.leftAxis.removeAllLimitLines()
        
        let partValue = Int(gotIt)/(part)
        for i in 0...part {
            let yAxis = partValue*i
//            print("maxAxis:\(yAxis)  part:\(i)")
            limitArray.append(yAxis)
//            let limitLine = ChartLimitLine.init(limit: Double(yAxis), label: "\(yAxis)")
//            limitLine.drawLabelEnabled = false
//            limitLine.lineWidth = 1
//            limitLine.lineDashLengths = [3, 2]
//            limitLine.lineColor = ColorExtension.lineLight
//            self.leftAxis.addLimitLine(limitLine)
        }

        yRender?.entries = limitArray
        self.setVisibleYRangeMaximum(gotIt, axis: .left)
        self.setVisibleYRangeMinimum(gotIt, axis: .left)
        if theme.style == .month {
            self.moveViewTo(xValue: self.lowestVisibleX, yValue: gotIt/2, axis: .left)
        } else {
            self.moveViewTo(xValue: self.lowestVisibleX, yValue: gotIt/2, axis: .left)
        }
        
        let time = self.calculatAverageTime()
        let ave = self.calculatAverage()
        self.dataSouceChanged?.update(single: ave, mult: nil, from: time.0, to: time.1)
    }
    
    internal func calculatAverageTime() -> (Double, Double) {
        let left = round(self.lowestVisibleX) < 0 ? 0 : round(self.lowestVisibleX)
        let right = round(self.highestVisibleX)
        switch theme.style {
        case .session:
            
            let fromTime = self.theme.startTime + left
            let toTime = self.theme.startTime + right
            return (fromTime, toTime)
        case .month:
            guard let fromTime = self.theme.startDate.getDayAfter(days: Int(left))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            guard let toTime = self.theme.startDate.getDayAfter(days: Int(right))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            return (fromTime, toTime)
        case .year:
            guard let fromTime = self.theme.startDate.getMonthAfter(month: Int(left))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            guard let toTime = self.theme.startDate.getMonthAfter(month: Int(right))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            return (fromTime, toTime)
        }

    }
    
    internal func calculatAverage() -> Int {

        let left = self.lowestVisibleX < 0 ? 0 : round(self.lowestVisibleX)
        let right = round(self.highestVisibleX)
        
        let leftIndex = Int(left)
        let count = Int(right-left)
        
        if leftIndex+count <= dataList.count {
            var sum = 0.0
            var num = 0
            for i in leftIndex..<leftIndex+count {
                if dataList[i] > 0 {
                    num += 1
                }
                sum += dataList[i]
            }
            let ave = Int(sum / Double(num > 0 ? num : 1))
            return ave
        } else {
            return 0
        }
    }
    
    
}


