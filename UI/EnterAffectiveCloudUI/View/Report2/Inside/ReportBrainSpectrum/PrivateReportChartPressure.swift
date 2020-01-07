//
//  PrivateReportChartPressure.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/25.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class PrivateReportChartPressure: UIView, ChartViewDelegate {

    
    public var lineColor: UIColor = UIColor.colorWithHexString(hexColor: "#FF6682")
    
    /// 背景颜色
    public var bgColor: UIColor = .white {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    /// 圆角
    public var cornerRadius: CGFloat = 8 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithHexString(hexColor: "333333") {
        didSet  {
            let changedColor = textColor.changeAlpha(to: 0.7)
            let secondColor = textColor.changeAlpha(to: 0.5)
            xLabel?.textColor = changedColor
            
            chartView?.leftAxis.labelTextColor = changedColor
            chartView?.xAxis.labelTextColor = changedColor
            chartView?.xAxis.gridColor = secondColor
        }
    }
    
    public var isChartScale = false {
        willSet {
            chartView?.scaleXEnabled = newValue
            chartHead?.expandBtn.isHidden = !newValue
        }
    }
    
    public var sample = 3
    
    public var pressureAvg: Int = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue), label: "AVG: \(newValue)")
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [8, 4]
            avgLine.lineColor = textColor.changeAlpha(to: 0.5)
            avgLine.lineWidth = 1
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    
    //MARK:- Private UI
    private var maxDataCount = 100
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.8
    private var timeStamp = 0
    private var pressureArray: [Float]?
    private var yRender: LimitYAxisRenderer?
    //MARK:- Private UI
    private var chartHead: PrivateChartViewHead?
    private var titleLabel: UILabel?
    private var chartView: LineChartView?
    private var xLabel: UILabel?
    private var msLabel: UILabel?
    private var nShowChartView: UIView?
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let _ = self.superview else {
            return
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        chartView?.snp.makeConstraints {
            $0.top.equalTo(chartHead!.snp.bottom).offset(0)
            $0.right.equalToSuperview().offset(-8)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    func initFunction() {
        let alphaColor = textColor.changeAlpha(to: 0.7)
        let secondColor = textColor.changeAlpha(to: 0.3)
        
        self.layer.cornerRadius = cornerRadius
        
        chartHead = PrivateChartViewHead()
        chartHead?.titleText = "Changes During Meditation"
        chartHead?.expandBtn.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        self.addSubview(chartHead!)
        
        xLabel = UILabel()
        xLabel?.text = "Time(min)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = alphaColor
        self.addSubview(xLabel!)
        chartView = LineChartView()
        yRender = LimitYAxisRenderer(viewPortHandler: chartView!.viewPortHandler, yAxis: chartView?.leftAxis, transformer: chartView?.getTransformer(forAxis: .left))

        chartView?.leftYAxisRenderer = yRender!
        chartView?.delegate = self
        chartView?.backgroundColor = .clear
        chartView?.gridBackgroundColor = .clear
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription?.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.scaleXEnabled = false
        chartView?.scaleYEnabled = false
        chartView?.legend.enabled = false
        chartView?.highlightPerTapEnabled = false
        
        let leftAxis = chartView!.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = alphaColor
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMaxLabels = 4
        leftAxis.axisMinLabels = 3
        leftAxis.axisLineColor = secondColor
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.gridLineWidth = 1
        xAxis.labelPosition = .bottom
        xAxis.gridColor = secondColor
        xAxis.labelTextColor = alphaColor
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        
        self.addSubview(chartView!)
    }
    
    public func setDataFromModel(pressure: [Float]?, timestamp: Int? = nil) {
        
        if let timestamp = timestamp, timestamp != 0 {
            timeStamp = timestamp
            
        }
        
        if let pressure = pressure {
            let intArray = pressure.map { (value) -> Int in
                return Int(value)
            }
            
            sample = pressure.count / maxDataCount == 0 ? 1 : pressure.count / maxDataCount
            pressureArray = pressure
            setDataCount(intArray)
        }
        
    }
    //MARK:- Chart delegate
    private func setDataCount(_ waveArray: [Int]) {
        var colors: [UIColor] = []
        var initValue = 0
        var initIndex = 0
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if waveArray[i] > 10 {
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
            if i < initIndex{
                colors.append(#colorLiteral(red: 0.9, green: 0.90, blue: 0.90, alpha: 0.7))
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if waveArray[i] <= 10 {
                    colors.append(#colorLiteral(red: 0.9, green: 0.90, blue: 0.90, alpha: 0.7))
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                } else {
                    if minValue > waveArray[i] {
                        minValue = waveArray[i]
                    }
                    if maxValue < waveArray[i] {
                        maxValue = waveArray[i]
                    }
                    notZero = waveArray[i]
                    colors.append(lineColor)
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i])))
                }
                
            }
            
        }
        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 3
        set.colors = colors
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView?.data = data
        
        var labelArray: [Int] = []
        let maxLabel = (maxValue / 5 + 1) * 5 > 100 ? 100 : (maxValue / 5 + 1) * 5
        let minLabel = (minValue / 5) * 5 < 0 ? 0 : (minValue / 5) * 5
        chartView?.leftAxis.axisMaximum = Double(maxLabel)
        chartView?.leftAxis.axisMinimum = Double(minLabel)
        if (maxLabel - minLabel) % 3 == 0 {
            labelArray.append(minLabel)
            labelArray.append(maxLabel-(maxLabel-minLabel)*2/3)
            labelArray.append(maxLabel-(maxLabel-minLabel)/3)
            labelArray.append(maxLabel)

        } else if (maxLabel - minLabel) % 2 == 0 {
            labelArray.append(minLabel)
            labelArray.append(maxLabel-(maxLabel-minLabel)/2)
            labelArray.append(maxLabel)
        } else {
            if (maxLabel - (minLabel+5)) % 3 == 0 {
                labelArray.append(minLabel+5)
                labelArray.append(maxLabel-(maxLabel-minLabel-5)*2/3)
                labelArray.append(maxLabel-(maxLabel-minLabel-5)/3)
                labelArray.append(maxLabel)

            } else if (maxLabel - minLabel-5) % 2 == 0 {
                labelArray.append(minLabel-5)
                labelArray.append(maxLabel-(maxLabel-minLabel-5)/2)
                labelArray.append(maxLabel)
            }
        }
        yRender?.entries = labelArray
        setLimitLine(yVals.count, labelArray)
        
    }
    
    private var timeApart: [Int] = []
    private func setLimitLine(_ valueCount: Int, _ yLables: [Int]) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            timeApart.append(i)
        }
        
        chartView?.xAxis.axisMinimum = 0
        chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(100) //限制屏幕最少显示100个点
        
        self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(timeApart, timeStamp)
        
        //self.chartView?.leftAxis.valueFormatter = YValueFormatter(values: yLables)
        
    }
    
    private var isScaled = false
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        let lineChart = chartView as! LineChartView
        if lineChart.scaleX > 1.1{
            if !isScaled {
                self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(timeStamp, true)
                isScaled = true
                
            }
        } else {
            if isScaled {
                self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(timeApart, timeStamp)
                isScaled = false
            }
        }
    }
    
    fileprivate var isZoomed = false
    @objc
    private func zoomBtnTouchUpInside(sender: UIButton) {
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            sender.isEnabled = true
        }
        if !isZoomed {
            let vc = self.parentViewController()!
            vc.navigationController?.setNavigationBarHidden(true, animated: true)
            let view = vc.view
            let nShowChartView = UIView()
            nShowChartView.backgroundColor = UIColor.colorWithHexString(hexColor: "#E5E5E5")
            view?.addSubview(nShowChartView)
            
            let chart = PrivateReportChartPressure()
            nShowChartView.addSubview(chart)
            chart.chartHead?.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            chart.bgColor = self.bgColor
            chart.cornerRadius = self.cornerRadius
            chart.maxDataCount = 500
            chart.textColor = self.textColor
            chart.isChartScale = true
            chart.setDataFromModel(pressure: pressureArray)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*3/2))
            chart.isZoomed = true
            chart.pressureAvg = self.pressureAvg
            let label = UILabel()
            label.text = "Zoom in on the curve and slide to view it."
            label.font = UIFont.systemFont(ofSize: 12)
            chart.addSubview(label)
            label.snp.makeConstraints {
                $0.right.equalTo(chart.chartHead!.expandBtn.snp.left).offset(-12)
                $0.centerY.equalTo(chart.chartHead!.expandBtn.snp.centerY)
            }
            nShowChartView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            chart.snp.remakeConstraints {
                $0.width.equalTo(nShowChartView.snp.height).offset(-88)
                $0.height.equalTo(nShowChartView.snp.width).offset(-42)
                $0.center.equalToSuperview()
            }
            
        } else {
            let view = self.superview!
            view.parentViewController()?.navigationController?.setNavigationBarHidden(false, animated: true)
            for e in view.subviews {
                e.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
        
    }
}
