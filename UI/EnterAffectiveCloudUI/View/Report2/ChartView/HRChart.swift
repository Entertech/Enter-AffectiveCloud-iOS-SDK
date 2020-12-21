//
//  HRVChart.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/1.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

class HRChart: LineChartView {
    /// 数据上传周期，用于计算图表x轴间隔
    public var uploadCycle: UInt = 3 {
        willSet {
            if newValue == 0 {
                interval = 0.4
            } else {
                interval = 0.6 * Double(newValue)
            }
        }
    }
    
    /// 在整个图表显示的最大点数
    public var maxDataCount = 500
    
    /// 整个屏幕显示的点数
    public var maxScreenCount = 0
    
    /// 背景颜色
    public var bgColor: UIColor = .clear {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    /// 暗色，诸如线条之类的颜色设置
    public var axisColor: UIColor = ColorExtension.textLv1 {
        willSet {
            //let highPercentColor = newValue.changeAlpha(to: 0.8)
            let midPercentColor = newValue.changeAlpha(to: 0.6)
            let lowPercentColor = newValue.changeAlpha(to: 0.2)
            self.xAxis.labelTextColor = midPercentColor
            self.leftAxis.labelTextColor = midPercentColor
            self.xAxis.axisLineColor = midPercentColor
            self.xAxis.gridColor = lowPercentColor
        }
    }
    
    public var animationSpeed: Float = 0 {
        willSet {
            self.animate(xAxisDuration: TimeInterval(animationSpeed))
        }
    }
    
    public var isNeedLeftLabel: Bool = true {
        willSet {
            self.leftAxis.drawLabelsEnabled = newValue
        }
    }
    
    /// 主要线条颜色
    public var lineColor: UIColor = UIColor.colorWithHexString(hexColor: "#FF6682")
    /// 子线条颜色
    public var paddingLineColor: UIColor = UIColor.colorWithHexString(hexColor: "#60C696")
    
    /// 平均值的文案
    public var averageText = "Average"
    
    public var chartTitleText = "Heart Rate"
    
    /// 设置平均值
    public var hrvAvg: Float = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue), label: String.init(format: "%@: %d", averageText, Int(newValue)))
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [4, 2]
            avgLine.lineColor = axisColor
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            avgLine.valueTextColor = axisColor
            avgLine.lineWidth = 1
            self.leftAxis.addLimitLine(avgLine)
        }
    }
    
    /// Marker 的背景色
    public var markerBackgroundColor = UIColor.white {
        willSet {
            valueMarker?.backgroundColor = newValue
        }
    }
    
    /// highlight 颜色
    public var highlightLineColor = UIColor.systemGray {
        willSet {
            valueMarker?.lineColor = newValue
        }
    }


    private var yRender: LimitYAxisRenderer?
    private var valueMarker: ValueMarkerView?
    private var panGesture: UIPanGestureRecognizer?
    private lazy var dotIcon = UIImage.highlightIcon(centerColor: self.lineColor)
    private var interval = 1.8
    private var timeStamp: Int = 0
    private var sample: Int = 3
    private var listArray: [Int]?
    private var paddingArray: [Int] = []
    
    init() {
        super.init(frame: CGRect.zero)
        initChart()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initChart()
    }
    
    private func initChart() {
        let highPercentColor = axisColor.changeAlpha(to: 0.8)
        let midPercentColor = axisColor.changeAlpha(to: 0.6)
        let lowPercentColor = axisColor.changeAlpha(to: 0.2)
        
        yRender = LimitYAxisRenderer(viewPortHandler: self.viewPortHandler, yAxis: self.leftAxis, transformer: self.getTransformer(forAxis: .left))
        self.leftYAxisRenderer = yRender!
        self.backgroundColor = .clear
        self.gridBackgroundColor = .clear
        self.drawBordersEnabled = false
        self.chartDescription?.enabled = false
        self.pinchZoomEnabled = true
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.legend.enabled = false
        //self.animate(xAxisDuration: 0.5)
        self.extraTopOffset = 60
        self.highlightPerTapEnabled = false
        self.highlightPerDragEnabled = false
        
        valueMarker = ValueMarkerView(frame: CGRect(x: 0, y: 0, width: 100, height: 47))
        valueMarker?.chartView = self
        valueMarker?.titleLabel?.text = chartTitleText
        valueMarker?.titleLabel?.textColor = highPercentColor
        valueMarker?.dot?.backgroundColor = lineColor
        self.marker = valueMarker
        
        let leftAxis = self.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = midPercentColor
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.gridColor = lowPercentColor
        leftAxis.gridLineWidth = 1
        leftAxis.gridLineDashPhase = 1
        leftAxis.gridLineDashLengths = [3,2]
        leftAxis.axisMaxLabels = 5
        self.rightAxis.enabled = false
        
        let xAxis = self.xAxis
        xAxis.gridLineWidth = 0.5
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = highPercentColor  
        xAxis.labelTextColor = midPercentColor
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.axisLineWidth = 1

    }
    
    
    /// 给图标设置数据
    /// - Parameters:
    ///   - list: 数据
    ///   - timestamp: 起始时间戳
    public func setData(list: [Int]?, timestamp: Int? = nil) {
        
        if let timestamp = timestamp, timestamp != 0 {
            timeStamp = timestamp
        }
        
        if let value = list {
            sample = value.count / maxDataCount == 0 ? 1 : value.count / maxDataCount
            listArray = value
            if value.count - paddingArray.count > 0 {
                for _ in 0..<(value.count-paddingArray.count) {
                    paddingArray.insert(0, at: 0)
                }
            }
            mapDataList()
        }
        
    }
    
    public func setPadding(list: [Int]) {
        for e in list {
            for _ in 0...1 {
                paddingArray.append(e)
            }
        }
    }
    
    var paddingIndex = 0
    /// 把数据映射到图表上
    /// - Parameter waveArray: 数据
    private func mapDataList() {
        guard let waveArray = listArray else {
            return
        }
        
        var colors: [UIColor] = [] //废弃
        var initValue = 0
        var initIndex = 0
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if waveArray[i] > 0 {
                initValue = waveArray[i]
                initIndex = i
                break
            }
        }
        
        var minValue = 100
        var maxValue = 0
        var yVals: [ChartDataEntry] = []
        var notZero: Int = 0
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if i < initIndex{  //为0的为无效数据
                colors.append(lineColor) //分别数据颜色
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if waveArray[i] == 0 {//为0的为无效数据
                    colors.append(lineColor)
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                } else {
                    if minValue > waveArray[i] {
                        minValue = waveArray[i]
                    }
                    if maxValue < waveArray[i] {
                        maxValue = waveArray[i]
                    }
                    notZero = waveArray[i]
                    if i < paddingArray.count {
                        if paddingArray[i] != 0 {
                            if paddingIndex == 0 {
                                paddingIndex = yVals.count-1
                            }
                            
                            colors.append(paddingLineColor)
                        } else {
                            colors.append(lineColor)
                        }
                    } else {
                        colors.append(lineColor)
                    }
                    
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i])))
                }
                
            }
            
        }
        // 设置chart set
        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 1.5
        //set.setColor(lineColor)
        set.colors = colors
        set.drawIconsEnabled = true
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = highlightLineColor
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        self.data = data
        
        // 设置坐标轴
        var labelArray: [Int] = []
        let tempMax5 = (maxValue / 5 + 1) * 5 > 150 ? 150 : (maxValue / 5 + 1) * 5
        let tempMin5 = (minValue / 5 ) * 5 < 0 ? 0 : (minValue / 5) * 5
        
        var maxLabel = 0
        var minLabel = 0
        var bScaleIs2 = false
        if (maxValue - minValue) / 4 >= 2 {
            maxLabel = tempMax5
            minLabel = tempMin5
        } else {
            let tempMax2 = (maxValue / 2 + 1) * 2 > 150 ? 150 : (maxValue / 2 + 1) * 2
            let tempMin2 = (minValue / 2 ) * 2 < 0 ? 0 : (minValue / 2) * 2
            maxLabel = tempMax2
            minLabel = tempMin2
            bScaleIs2 = true
        }

        if !bScaleIs2 {
            let scaled = 5
            for i in (0...5) {
                let scale = scaled * i
                if (minLabel-scale) < 0 {
                    if ((maxLabel+scale) - minLabel) % 4 == 0 {
                        self.leftAxis.axisMaximum = Double(maxLabel+scale)
                        self.leftAxis.axisMinimum = Double(minLabel)
                        labelArray.append(minLabel)
                        labelArray.append((maxLabel+scale)-(maxLabel-minLabel+scale)*3/4)
                        labelArray.append((maxLabel+scale)-(maxLabel-minLabel+scale)*2/4)
                        labelArray.append((maxLabel+scale)-(maxLabel-minLabel+scale)*1/4)
                        labelArray.append(maxLabel+scale)
                        break
                    }
                } else {
                    if (maxLabel - (minLabel-scale)) % 4 == 0 {
                        self.leftAxis.axisMaximum = Double(maxLabel)
                        self.leftAxis.axisMinimum = Double(minLabel-scale)
                        labelArray.append(minLabel-scale)
                        labelArray.append(maxLabel-(maxLabel-minLabel+scale)*3/4)
                        labelArray.append(maxLabel-(maxLabel-minLabel+scale)*2/4)
                        labelArray.append(maxLabel-(maxLabel-minLabel+scale)*1/4)
                        labelArray.append(maxLabel)
                        break
                    }
                }
            }
        } else {
            self.leftAxis.axisMaximum = Double(minLabel+8)
            self.leftAxis.axisMinimum = Double(minLabel)
            labelArray.append(minLabel)
            labelArray.append(minLabel+2)
            labelArray.append(minLabel+4)
            labelArray.append(minLabel+6)
            labelArray.append(minLabel+8)
        }
        yRender?.entries = labelArray
        setLimitLine(yVals.count, labelArray, paddingIndex)
    }
    
    
    private var timeApart: [Int] = []
    private func setLimitLine(_ valueCount: Int, _ yLabels: [Int], _ paddingIndex: Int = 0) {
        guard valueCount > 1 else {
            return
        }
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            timeApart.append(i)
        }
        
        self.xAxis.axisMinimum = 0
        self.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        self.setVisibleXRangeMinimum(20) //限制屏幕最少显示100个点
        
        self.maxVisibleCount = valueCount + 1
        self.xAxis.valueFormatter = HRVXValueFormatter(timeApart, timeStamp)
        
        if maxScreenCount > 0 {
            self.setVisibleXRange(minXRange: 150, maxXRange: 150)
            let value = Double(paddingIndex)/Double(valueCount)*self.xRange
            self.moveViewToX(value-30)
            
        }
    }
    
 
    
    
}
