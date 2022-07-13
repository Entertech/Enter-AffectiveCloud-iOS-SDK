//
//  AffectiveCharts3RhythmsChart.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveCharts3RhythmsChart: LineChartView {
    
    /// 数据上传周期，用于计算图表x轴间隔
    public var uploadCycle: UInt = 1 {
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
    
    
    public var animationSpeed: Double = 0 {
        willSet {
            self.animate(xAxisDuration: TimeInterval(animationSpeed))
        }
    }
    
    public lazy var enableGama = true
    
    public lazy var enableBeta = true
    public lazy var enableAlpha = true
    
    public lazy var enableTheta = true
    
    public lazy var enableDelta = true {
        didSet {
            if self.data != nil {
                mapDataList(array2D: brainwave)
            }
        }
    }
    
    public var gamaColor = UIColor.colorWithHexString(hexColor: "#FF6682") {
        willSet {
        
            colors[0] = newValue
        }
    }
    public var betaColor = UIColor.colorWithHexString(hexColor: "#58B9E0") {
        willSet {
            
            colors[1] = newValue
        }
    }
    public var alphaColor = UIColor.colorWithHexString(hexColor: "#F7C77E") {
        willSet {
            
            colors[2] = newValue
        }
    }
    public var thetaColor = UIColor.colorWithHexString(hexColor: "#5FC695") {
        willSet {
           
            colors[3] = newValue
        }
    }
    public var deltaColor = UIColor.colorWithHexString(hexColor: "#5E75FF") {
        willSet {
            
            colors[4] = newValue
        }
    }
    
    public var enableScale: Bool = false {
        willSet {
            self.scaleXEnabled = newValue
        }
    }
    
    public var alphaArray: [Double]? = []
    public var betaArray: [Double]? = []
    public var gamaArray: [Double]? = []
    public var deltaArray: [Double]? = []
    public var thetaArray: [Double]? = []

    internal var interval = 0.6
    internal var sample = 3
    internal lazy var colors: [UIColor] = [gamaColor, betaColor, alphaColor, thetaColor, deltaColor]
    
    init() {
        super.init(frame: CGRect.zero)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
   
    }
    
    internal func initChart() {
        
        self.backgroundColor = .clear
        self.gridBackgroundColor = .clear
        self.drawBordersEnabled = false
        self.chartDescription.enabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.legend.enabled = false
        self.extraTopOffset = 129
        self.highlightPerTapEnabled = false
        self.highlightPerDragEnabled = false
        self.dragDecelerationEnabled = false
        let leftAxis = self.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.gridColor = ColorExtension.lineLight
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridLineDashPhase = 1
        leftAxis.gridLineDashLengths = [3, 2]
        leftAxis.setLabelCount(5, force: true)
        self.rightAxis.enabled = false
        
        let xAxis = self.xAxis
        xAxis.gridLineWidth = 0.5
        xAxis.labelPosition = .bottom
        xAxis.gridColor = ColorExtension.lineLight
        xAxis.labelTextColor = ColorExtension.textLv2
        xAxis.axisLineColor = ColorExtension.lineHard
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.drawGridLinesEnabled = true
        xAxis.drawAxisLineEnabled = true
        xAxis.gridLineWidth = 0.5
        xAxis.gridLineDashPhase = 1
        xAxis.gridLineDashLengths = [3, 2]
        xAxis.axisLineWidth = 1
        xAxis.valueFormatter = AffectiveCharts3HourValueFormatter()

    }
    
    internal var brainwave: Array2D<Double>?
    /// 设置图标数值
    /// - Parameters:
    ///   - gama: gama description
    ///   - beta: beta description
    ///   - alpha: alpha description
    ///   - theta: theta description
    ///   - delta: delta description
    ///   - timestamp: 起始时间戳
    public func setData(value: Array2D<Double>) {
        brainwave = value
        //setDataCount(brainwave)
        mapDataList(array2D: value)
    }
    
    internal func brainwaveMapping() -> Array2D<Double>? {
        if let gList = gamaArray,
           let bList = betaArray,
           let aList = alphaArray,
           let tList = thetaArray,
           let dList = deltaArray,
           let listCount = gamaArray?.count, listCount > 0 {
            sample = listCount / maxDataCount == 0 ? 1 : listCount / maxDataCount
            var tmpArray = Array2D(columns: listCount, rows: 5, initialValue: Double(0.0))
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
    internal func mapDataList(array2D: Array2D<Double>?) {
        guard let waveArray = array2D else {
            return
        }
        var waveNum = [Double]()
        var sets: [LineChartDataSet] = []
        for j in 0..<waveArray.rows {
            switch j {
            case 0:
                if !enableGama {
                    continue
                } else {
                    waveNum.append(0)
                }
            case 1:
                if !enableBeta {
                    continue
                } else {
                    waveNum.append(1)
                }
            case 2:
                if !enableAlpha {
                    continue
                }else {
                    waveNum.append(2)
                }
            case 3:
                if !enableTheta {
                    continue
                } else {
                    waveNum.append(3)
                }
            case 4:
                if !enableDelta {
                    continue
                } else {
                    waveNum.append(4)
                }
            default:
                break
            }
            
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
            set.lineWidth = 1.5
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
            set.highlightColor = ColorExtension.lineLight
            set.drawHorizontalHighlightIndicatorEnabled = false
            set.drawValuesEnabled = false
            sets.append(set)
        }
        let data = LineChartData(dataSets: sets)
        self.data = data
        let lineEnables = (enableGama ? 1 : 0) + (enableBeta ? 2 : 0) + (enableAlpha ? 4 : 0) + (enableTheta ? 8 : 0) + (enableDelta ? 16 : 0)
//        let markerView = AffectiveCharts3RhythmsMarker(title: "Rhythms Power", enableLines: lineEnables)
//            .setTime(start: startTime, format: "MMM d, yyyy H:mm a")
//            .setProperty(sample: sample, interval: interval, usePercent: false)
//        
//        self.marker = markerView
//        markerView.chartView = self

    }
    


}
