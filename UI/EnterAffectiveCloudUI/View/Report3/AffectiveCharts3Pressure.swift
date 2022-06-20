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
    private let front1View = UIView()
    private let front2View = UIView()
    private var panValue:CGFloat = 0
    private var bIsCalculatePan = false
    private var startDate: Date!
    private var lastXValue: Double = 0
    weak var dataSouceChanged: AffectiveCharts3ChartChanged?
    public override func setTheme(_ theme: AffectiveChart3Theme) -> Self {
        self.theme = theme
        self.startDate = theme.startDate
        titleView.setTheme(theme)
            .build(isAlreadShow: isFullScreen)
        titleView.delegate = self
        self.backgroundColor = ColorExtension.bgZ1
        front1View.backgroundColor = ColorExtension.bgZ1
        front2View.backgroundColor = ColorExtension.bgZ1
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
    
    public override func setLayout() -> Self {
        self.addSubview(chartView)
        self.addSubview(titleView)
        self.addSubview(front1View)
        self.addSubview(front2View)
        front1View.snp.makeConstraints {
            $0.top.leading.equalTo(chartView)
            $0.width.equalTo(9)
            $0.bottom.equalTo(chartView.snp.bottom).offset(-16)
        }
        front2View.snp.makeConstraints {
            $0.top.trailing.equalTo(chartView)
            $0.width.equalTo(9)
            $0.bottom.equalTo(chartView.snp.bottom).offset(-16)
        }
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(90)
        }
        chartView.extraTopOffset = 92
        
        return self
    }
    
    public override func setChartProperty() -> Self {
        chartView.delegate = self
        chartView.backgroundColor = .clear
        chartView.animate(xAxisDuration: 0.5)
        chartView.drawGridBackgroundEnabled = true
        chartView.gridBackgroundColor = .clear
        chartView.drawBordersEnabled = false
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
        switch theme.style {
        case .session:
            chartView.dragEnabled = false
            chartView.xAxis.valueFormatter = AffectiveCharts3HourValueFormatter()
        case .month:
            self.dataSouceChanged = titleView
            chartView.dragEnabled = true
            chartView.xAxis.valueFormatter = AffectiveCharts3DayValueFormatter(originDate: Date.init(timeIntervalSince1970: theme.startTime))
        case .year:
            self.dataSouceChanged = titleView
            chartView.dragEnabled = true
            chartView.xAxis.valueFormatter = AffectiveCharts3MonthValueFormatter(originDate: Date.init(timeIntervalSince1970: theme.startTime))

        }
        
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

        if theme.style == .month {
            set.drawCirclesEnabled = true
            set.drawCircleHoleEnabled = true
        } else if theme.style == .year {
            set.drawCirclesEnabled = true
            set.drawCircleHoleEnabled = true
        } else {
            set.drawCirclesEnabled = false
            set.drawCircleHoleEnabled = false
        }
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.setColor(theme.themeColor)
        set.setCircleColor(theme.themeColor)
        set.circleRadius = 3
        set.circleHoleRadius = 2
        set.circleHoleColor = ColorExtension.white
        set.drawIconsEnabled = false
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = ColorExtension.lineLight
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView.data = data
        if theme.style == .month {
            chartView.setVisibleXRangeMaximum(31)
            if let last = yVals.last {
                self.chartView.moveViewToX(last.x)
                self.lastXValue = last.x
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: {
                self.overloadY()
            })
        } else if theme.style == .year {
            chartView.setVisibleXRangeMaximum(12)
            if let last = yVals.last {
                self.chartView.moveViewToX(last.x)
                self.lastXValue = last.x
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: {
                self.overloadY()
            })
        }
    }
}

extension AffectiveCharts3Pressure: ChartViewDelegate {
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.bIsCalculatePan = true
            if self.panValue >= 15 {
                let leftValue = self.chartView.lowestVisibleX
                var aim = 0.0
                if self.theme.style == .month {
                    let date = self.startDate.getDayAfter(days: Int(round(leftValue)))
                    if let day = date?.get(.day) {
                        aim = round(leftValue - Double(day) + 1.0)
                        aim -= 0.3
                    }
                } else {
                    let date = self.startDate.getMonthAfter(month: Int(round(leftValue)))
                    if let day = date?.get(.month) {
                        aim = round(leftValue - Double(day) + 1.0)
                        aim -= 0.4
                    }
                }
                self.chartView.moveViewToAnimated(xValue: aim, yValue: 0, axis: .left, duration: 0.3, easingOption: .easeInCubic)
                self.lastXValue = aim
            } else if self.panValue < -15 {
                let rightValue = self.chartView.highestVisibleX
                var aim = 0.0
                if self.theme.style == .month {
                    let date = self.startDate.getDayAfter(days: Int(round(rightValue)))
                    if let day = date?.get(.day) {
                        aim = round(rightValue - Double(day) + 1.0)
                        aim -= 0.3
                    }
                } else {
                    let date = self.startDate.getMonthAfter(month: Int(round(rightValue)))
                    if let day = date?.get(.month) {
                        aim = round(rightValue - Double(day) + 1.0)
                        aim -= 0.4
                    }
                }
                self.chartView.moveViewToAnimated(xValue: aim, yValue: 0, axis: .left, duration: 0.3, easingOption: .easeInCubic)
                self.lastXValue = aim
            } else {
                self.chartView.moveViewToAnimated(xValue: self.lastXValue, yValue: 0, axis: .left, duration: 0.1, easingOption: .easeInCubic)
            }
            self.panValue = 0
            self.bIsCalculatePan = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.overloadY()
        }
        
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        if !bIsCalculatePan {
            
            panValue += dX
        } else {
            
        }
    }
    
    
    func overloadY() {
        let leftX = Int(round(self.chartView.lowestVisibleX) - self.chartView.chartXMin)
        let rightX = Int(round(self.chartView.highestVisibleX) - self.chartView.chartXMin)
        var maxValue: Double = 0
        for i in leftX..<rightX {
            if let value = self.chartView.lineData?.dataSets.first?.entryForIndex(i) {
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
        self.chartView.leftAxis.removeAllLimitLines()
        
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
            self.chartView.leftAxis.addLimitLine(limitLine)
        }


        yRender?.entries = limitArray
        self.chartView.setVisibleYRangeMaximum(gotIt, axis: .left)
        self.chartView.setVisibleYRangeMinimum(gotIt, axis: .left)
        if theme.style == .month {
            self.chartView.moveViewTo(xValue: self.chartView.lowestVisibleX, yValue: gotIt/2, axis: .left)
        } else {
            self.chartView.moveViewTo(xValue: self.chartView.lowestVisibleX, yValue: gotIt/2, axis: .left)
        }
        
        let time = self.calculatAverageTime()
        let ave = self.calculatAverage()
        self.dataSouceChanged?.update(single: ave, mult: nil, from: time.0, to: time.1)
    }
    
    internal func calculatAverageTime() -> (Double, Double) {
        let left = round(self.chartView.lowestVisibleX)
        let right = round(self.chartView.highestVisibleX)
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

        let left = round(self.chartView.lowestVisibleX)
        let right = round(self.chartView.highestVisibleX)
        
        let leftIndex = Int(left)
        let count = Int(right-left)
        
        if leftIndex+count <= dataSorce.count {
            var sum = 0.0
            for i in leftIndex..<leftIndex+count {
                sum += Double(dataSorce[i])
            }
            let ave = Int(round(sum / Double(count)))
            return ave
        } else {
            return 0
        }
    }
    
}
