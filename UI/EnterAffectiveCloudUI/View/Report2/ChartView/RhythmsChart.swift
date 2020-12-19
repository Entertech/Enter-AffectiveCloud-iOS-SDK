//
//  RhythmsChart.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/2.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

class RhythmsChart: LineChartView {

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
    
    /// 整个屏幕显示的点数. 0表示不限制
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
            let highPercentColor = newValue.changeAlpha(to: 0.8)
            let midPercentColor = newValue.changeAlpha(to: 0.6)
            let lowPercentColor = newValue.changeAlpha(to: 0.2)
            self.xAxis.labelTextColor = midPercentColor
            self.xAxis.axisLineColor = midPercentColor
            self.xAxis.gridColor = lowPercentColor
        }
    }
    
    public var animationSpeed: Float = 0 {
        willSet {
            self.animate(xAxisDuration: TimeInterval(animationSpeed))
        }
    }
    
    public lazy var enableGama = true {
        didSet {
            if self.data != nil {
                mapDataList(array2D: brainwave)
            }
        }
    }
    
    public lazy var enableBeta = true {
        didSet {
            if self.data != nil {
                mapDataList(array2D: brainwave)
            }
        }
    }
    
    public lazy var enableAlpha = true {
        didSet {
            if self.data != nil {
                mapDataList(array2D: brainwave)
            }
        }
    }
    
    public lazy var enableTheta = true {
        didSet {
            if self.data != nil {
                mapDataList(array2D: brainwave)
            }
        }
    }
    
    public lazy var enableDelta = true {
        didSet {
            if self.data != nil {
                mapDataList(array2D: brainwave)
            }
        }
    }
    
    public var gamaColor = UIColor.colorWithHexString(hexColor: "#FF6682") {
        willSet {
            markerView?.dotArray[0].backgroundColor = newValue
            colors[0] = newValue
        }
    }
    public var betaColor = UIColor.colorWithHexString(hexColor: "#58B9E0") {
        willSet {
            markerView?.dotArray[1].backgroundColor = newValue
            colors[1] = newValue
        }
    }
    public var alphaColor = UIColor.colorWithHexString(hexColor: "#F7C77E") {
        willSet {
            markerView?.dotArray[2].backgroundColor = newValue
            colors[2] = newValue
        }
    }
    public var thetaColor = UIColor.colorWithHexString(hexColor: "#5FC695") {
        willSet {
            markerView?.dotArray[3].backgroundColor = newValue
            colors[3] = newValue
        }
    }
    public var deltaColor = UIColor.colorWithHexString(hexColor: "#5E75FF") {
        willSet {
            markerView?.dotArray[4].backgroundColor = newValue
            colors[4] = newValue
        }
    }
    
    /// Marker 的背景色
    public var markerBackgroundColor = UIColor.white {
        willSet {
            markerView?.backgroundColor = newValue
        }
    }
    
    /// highlight 颜色
    public var highlightLineColor = UIColor.systemGray {
        willSet {
            markerView?.lineColor = newValue
        }
    }
    public var alphaArray: [Float]? = []
    public var betaArray: [Float]? = []
    public var gamaArray: [Float]? = []
    public var deltaArray: [Float]? = []
    public var thetaArray: [Float]? = []

    
    
    private var interval = 1.8
    private var timeStamp = 0
    private var sample = 3
    private lazy var colors: [UIColor] = [gamaColor, betaColor, alphaColor, thetaColor, deltaColor]
    
    private var markerView: FiveDBValueMarkerView?
    
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
        
        self.backgroundColor = .clear
        self.gridBackgroundColor = .clear
        self.drawBordersEnabled = false
        self.chartDescription?.enabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.legend.enabled = false
        self.isUserInteractionEnabled = false
        //self.animate(xAxisDuration: 0.5)
        self.extraTopOffset = 60
        self.highlightPerTapEnabled = false
        self.highlightPerDragEnabled = false
        
        let leftAxis = self.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.gridColor = lowPercentColor
        leftAxis.gridLineWidth = 1
        leftAxis.gridLineDashPhase = 1
        leftAxis.gridLineDashLengths = [3,2]
        leftAxis.setLabelCount(5, force: true)
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
        
        markerView = FiveDBValueMarkerView(frame: CGRect(x: 0, y: 0, width: 332, height: 47))
        markerView?.chartView = self
        markerView?.titleLabelArray[0].text = "γ"
        markerView?.titleLabelArray[1].text = "β"
        markerView?.titleLabelArray[2].text = "α"
        markerView?.titleLabelArray[3].text = "θ"
        markerView?.titleLabelArray[4].text = "δ"
        markerView?.dotArray[0].backgroundColor = gamaColor
        markerView?.dotArray[1].backgroundColor = betaColor
        markerView?.dotArray[2].backgroundColor = alphaColor
        markerView?.dotArray[3].backgroundColor = thetaColor
        markerView?.dotArray[4].backgroundColor = deltaColor
        self.marker = markerView
    }
    
    private var brainwave: Array2D<Float>?
    /// 设置图标数值
    /// - Parameters:
    ///   - gama: gama description
    ///   - beta: beta description
    ///   - alpha: alpha description
    ///   - theta: theta description
    ///   - delta: delta description
    ///   - timestamp: 起始时间戳
    public func setData(gama: [Float]?, beta: [Float]?, alpha: [Float]?,theta: [Float]?, delta: [Float]?, timestamp: Int? = nil) {
        
        if let timestamp = timestamp {
            timeStamp = timestamp
        }
        self.gamaArray = gama
        self.deltaArray = delta
        self.thetaArray = theta
        self.alphaArray = alpha
        self.betaArray = beta
        brainwave = brainwaveMapping()
        //setDataCount(brainwave)
        mapDataList(array2D: brainwave)
    }
    
    private func brainwaveMapping() -> Array2D<Float>? {
        if let gList = gamaArray,
           let bList = betaArray,
           let aList = alphaArray,
           let tList = thetaArray,
           let dList = deltaArray,
           let listCount = gamaArray?.count, listCount > 0 {
            sample = listCount / maxDataCount == 0 ? 1 : listCount / maxDataCount
            var tmpArray = Array2D(columns: listCount, rows: 5, initialValue: Float(0.0))
            for i in 0..<listCount {
                tmpArray[i, 0] = gList[i]
                tmpArray[i, 1] = bList[i]
                tmpArray[i, 2] = aList[i]
                tmpArray[i, 3] = tList[i]
                tmpArray[i, 4] = dList[i]
            }
            return tmpArray
        }

        
        return nil
    }
    
    
    /// 把数据映射到图表上
    /// - Parameter waveArray: 数据
    private func mapDataList(array2D: Array2D<Float>?) {
        guard let waveArray = array2D else {
            return
        }

        var sets: [LineChartDataSet] = []
        for j in 0..<waveArray.rows {
            var initValue = 0
            var initIndex = 0
            for i in stride(from: 0, to: waveArray.columns, by: sample) {
                if waveArray[i, j] > 0 {
                    initValue = Int(waveArray[i, j])
                    initIndex = i
                    break
                }
            }
            var minValue = 120
            var maxValue = 0
            var yVals: [ChartDataEntry] = []
            var notZero: Int = 0
            for i in stride(from: 0, to: waveArray.columns, by: sample) {
                if i < initIndex{  //为0的为无效数据
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
                } else {
                    if waveArray[i, j] == 0 {//为0的为无效数据
                        yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                    } else {
                        if minValue > Int(waveArray[i, j]) {
                            minValue = Int(waveArray[i, j])
                        }
                        if maxValue < Int(waveArray[i, j]) {
                            maxValue = Int(waveArray[i, j])
                        }
                        notZero = Int(waveArray[i, j])
                      
                        yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i, j])))
                    }
                    
                }
                
            }
            // 设置chart set
            let set = LineChartDataSet(entries: yVals, label: "")
            set.mode = .linear
            set.drawCirclesEnabled = false
            set.drawCircleHoleEnabled = false
            set.drawFilledEnabled = false
            set.lineWidth = 2
            switch j {
            case 0:
                if enableGama {
                    set.setColor(gamaColor)
                } else {
                    set.setColor(.clear)
                }
                
            case 1:
                if enableBeta {
                    
                    set.setColor(betaColor)
                } else {
                    set.setColor(.clear)
                }
            case 2:
                if enableAlpha {
                    set.setColor(alphaColor)
                } else {
                    set.setColor(.clear)
                }
            case 3:
                if enableTheta {
                    
                    set.setColor(thetaColor)
                } else {
                    set.setColor(.clear)
                }
            case 4:
                if enableDelta {
                    
                    set.setColor(deltaColor)
                } else {
                    set.setColor(.clear)
                }
            default:
                set.setColor(gamaColor)
            }
            set.drawIconsEnabled = true
            set.highlightEnabled = true
            set.highlightLineWidth = 2
            set.highlightColor = highlightLineColor
            set.drawHorizontalHighlightIndicatorEnabled = false
            set.drawValuesEnabled = false
            sets.append(set)
        }
        let data = LineChartData(dataSets: sets)
        self.data = data
        // 设置坐标轴
        if sets.count > 0 {
            
            setLimitLine(sets[0].count)
        }
    }
    
    
    private var timeApart: [Int] = []
    private func setLimitLine(_ valueCount: Int) {
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
        self.maxVisibleCount = maxScreenCount != 0 ? maxScreenCount*5 : valueCount*5 + 1
        //self.chartView?.leftAxis.valueFormatter = YValueFormatter(values: yLabels)
        self.xAxis.valueFormatter = HRVXValueFormatter(timeApart, timeStamp)
    }

}
