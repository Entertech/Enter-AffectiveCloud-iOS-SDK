//
//  AffectiveCharts3CandyCommonView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/17.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveCharts3CandleCommonView: CombinedChartView {
    var theme: AffectiveChart3Theme!
    weak var dataSouceChanged: AffectiveCharts3ChartChanged?
    private var yRender: LimitYAxisRenderer?
    internal var lastXValue: Double = 0
    internal var dataList: [Double] = []
    internal var lowDataList: [Double] = []
    internal var highDataList: [Double] = []

    init(theme: AffectiveChart3Theme) {
        super.init(frame: CGRect.zero)
        self.theme = theme
        self.drawOrder = [
                               DrawOrder.candle.rawValue,
                               DrawOrder.line.rawValue
        ]
        self.drawBarShadowEnabled = false
        self.drawValueAboveBarEnabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.dragEnabled = true
        self.highlightPerTapEnabled = false
        self.highlightPerDragEnabled = false
        self.dragDecelerationEnabled = false
        self.extraTopOffset = 92
        self.legend.enabled = false
        let marker = AffectiveCharts3CommonMarkerView(theme: theme)
        marker.chartView = self
        self.marker = marker
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
        
        self.leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
        self.leftAxis.labelTextColor = ColorExtension.textLv2
        self.leftAxis.gridColor = ColorExtension.lineLight
        self.leftAxis.gridLineWidth = 1
        self.leftAxis.gridLineCap = .round
        self.leftAxis.gridLineDashPhase = 2.0
        self.leftAxis.gridLineDashLengths = [3.0, 2.0]
        self.leftAxis.drawAxisLineEnabled = false
    
        self.rightAxis.enabled = false
        
        self.xAxis.labelTextColor = ColorExtension.textLv2
        self.xAxis.gridColor = ColorExtension.lineLight
        self.xAxis.gridLineWidth = 1
        self.xAxis.gridLineCap = .round
        self.xAxis.gridLineDashLengths = [2.0, 4.0]
        self.xAxis.axisLineColor = ColorExtension.lineHard
        self.xAxis.axisLineWidth = 1
        self.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        self.xAxis.labelPosition = .bottom
        self.xAxis.axisMaxLabels = 8

        
        yRender = LimitYAxisRenderer(viewPortHandler: self.viewPortHandler, axis: self.leftAxis, transformer: self.getTransformer(forAxis: .left))
        self.leftYAxisRenderer = yRender!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataCount(low: [Double], high: [Double], average: [Double]) {
        self.dataList = average
        self.lowDataList = low
        self.highDataList = high
        let data = CombinedChartData()
        
        data.candleData = generateCandleData(low: low, high: high)
        data.lineData = generateLineData(average)
        self.xAxis.axisMinimum = -0.5
        self.xAxis.axisMaximum = data.xMax + 0.5
        self.data = data
        if theme.style == .month {
            self.setVisibleXRangeMaximum(31)
        } else {
            self.setVisibleXRangeMaximum(12)
        }
        if let minValue = self.lowDataList.min() {
            self.leftAxis.axisMinimum = Double(Int(minValue / 10.0)*10)
        }
        if let last = data.lineData.dataSets[0].entryForIndex(low.count-1) {
            self.moveViewToX(last.x)
            self.lastXValue = last.x
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            self.overloadY()
        }
    }
    
    private func generateLineData(_ average: [Double]) -> LineChartData {

        var entries = [ChartDataEntry]()
        for i in 0..<average.count {
            let entry = ChartDataEntry(x: Double(i), y: average[i])
            entries.append(entry)
        }
        
        let set = LineChartDataSet(entries: entries, label: "Line DataSet")
        set.setColor(theme.themeColor)
        set.setCircleColor(theme.themeColor)
        set.lineWidth = 2
        set.circleRadius = 3
        set.circleHoleRadius = 2
        set.circleHoleColor = ColorExtension.white
        set.mode = .linear
        set.drawValuesEnabled = false
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    private func generateCandleData(low: [Double], high: [Double]) -> CandleChartData {
        
        var entries = [CandleChartDataEntry]()
        for i in 0..<low.count {
            let entry = CandleChartDataEntry(x: Double(i), shadowH: high[i], shadowL: low[i], open: high[i], close: low[i])
            entries.append(entry)
        }
        
        let set = CandleChartDataSet(entries: entries, label: "Candle DataSet")
        set.setColor(ColorExtension.lineLight)
        set.decreasingColor = ColorExtension.lineLight
        set.shadowColor = ColorExtension.lineLight
        set.drawValuesEnabled = false
        if theme.style == .month {
            set.barSpace = 0.2
        } else {
            set.barSpace = 0.1
        }
        
        set.barCornerRadius = 50
        return CandleChartData(dataSet: set)
    }
    
    func overloadY() {
        let leftX = Int(round(self.lowestVisibleX) - self.chartXMin)
        let rightX = Int(round(self.highestVisibleX) - self.chartXMin)
        var maxValue: Double = 0
        for i in leftX..<rightX {
            if let value = self.candleData?.dataSets.first?.entryForIndex(i) as? CandleChartDataEntry {
                if value.high > maxValue {
                    maxValue = value.high
                }
            }
        }
        setYLable(maxY: maxValue)
    }
    
    private func setYLable(maxY: Double) {
        var gotIt: Double = 0
        var part: Int = 0
        var limitArray: [Int] = []
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
        
        guard part > 1 else {return}
        self.leftAxis.removeAllLimitLines()
        
        let partValue = Int(gotIt)/(part)
        for i in 0...part {
            let yAxis = partValue*i
//            print("maxAxis:\(yAxis)  part:\(i)")
            limitArray.append(yAxis)
            let limitLine = ChartLimitLine.init(limit: Double(yAxis), label: "\(yAxis)")
            limitLine.drawLabelEnabled = false
            limitLine.lineWidth = 1
            limitLine.lineDashLengths = [3, 2]
            limitLine.lineColor = ColorExtension.lineLight
            self.leftAxis.addLimitLine(limitLine)
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
        let left = round(self.lowestVisibleX)
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
            for i in leftIndex..<leftIndex+count {
                sum += dataList[i]
            }
            let ave = Int(round(sum / Double(count)))
            return ave
        } else {
            return 0
        }
    }

}

