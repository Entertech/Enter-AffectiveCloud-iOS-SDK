//
//  AffectiveChartRelaxationView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/2/4.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class AffectiveChartRelaxationView: UIView, ChartViewDelegate {
    /// 数据上传周期，用于计算图表x轴间隔
    public var uploadCycle: UInt = 3 {
        willSet {
            if newValue == 0 {
                interval = 0.8
            } else {
                interval = 0.6 * Double(newValue)
            }
        }
    }
    
    /// 图表线颜色
    public var lineColor: UIColor = UIColor.colorWithInt(r: 0, g: 100, b: 255, alpha: 1)
    
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
    
    /// x坐标说明文字
    public var xLabelText = "Time(min)" {
        willSet {
            xLabel?.text = newValue
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
    public var zoomText = "Zoom in on the curve and slide to view it."
    
    /// 下方单位字体颜色
    public var unitTextColor: UIColor = .black {
        willSet {
            xLabel?.textColor = newValue
        }
    }
    
    private var isChartScale = false {
        willSet {
            chartView?.scaleXEnabled = newValue
            chartHead?.expandBtn.isHidden = !newValue
        }
    }
    
    private var sample = 3
    
    /// 平均值的文案
    public var averageText = "Average"
    
    /// 平均值
    public var avg: Int = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue), label: "AVG: \(newValue)")
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [8, 4]
            avgLine.lineColor = textColor.changeAlpha(to: 0.5)
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            avgLine.lineWidth = 1
            avgLine.valueTextColor = unitTextColor
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    
    public var title: String = "放松度" {
        willSet {
            chartHead?.titleText = newValue
        }
    }
    
    //MARK:- Private UI
    private var maxDataCount = 100
    private let mainFont = "PingFangSC-Semibold"
    private var interval = 1.8
    private var timeStamp = 0
    private var relaxationArray: [Int]?
    private var yRender: LimitYAxisRenderer?
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
        chartHead?.titleText = title
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
        chartView?.highlightPerDragEnabled = false
        
        let leftAxis = chartView!.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = alphaColor
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMaxLabels = 4
        leftAxis.axisLineColor = secondColor
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.gridLineWidth = 0.5
        xAxis.labelPosition = .bottom
        xAxis.gridColor = secondColor
        xAxis.labelTextColor = alphaColor
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)

        self.addSubview(chartView!)
    }
    
    public func setDataFromModel(relaxation: [Int]?, timestamp: Int? = nil) {
        
        if let timestamp = timestamp, timestamp != 0 {
            timeStamp = timestamp
            
            xLabel?.isHidden = true
        }
        
        if let relaxation = relaxation {
            sample = relaxation.count / maxDataCount == 0 ? 1 : relaxation.count / maxDataCount
            relaxationArray = relaxation
            setDataCount(relaxation)
        }
        
    }
    //MARK:- Chart delegate
    private func setDataCount(_ waveArray: [Int]) {
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
            if i < initIndex{
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if waveArray[i] == 0 {
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                } else {
                    if minValue > waveArray[i] {
                        minValue = waveArray[i]
                    }
                    if maxValue < waveArray[i] {
                        maxValue = waveArray[i]
                    }
                    notZero = waveArray[i]
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i])))
                }
                
            }
            
        }
        var red:CGFloat   = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat  = 0.0
        var alpha:CGFloat = 0.0
        lineColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let components:[CGFloat] = [ red, green, blue, 1,
                                     red, green, blue, 0.75,
                                     red, green, blue, 0.5]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.2, 0.5, 1.0]
        let chartFillColor = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 3)
        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = true
        set.lineWidth = 1
        set.setColor(.clear)
        set.fill = Fill(linearGradient: chartFillColor!, angle: 270)
        set.fillAlpha = 1.0
        set.drawValuesEnabled = false
        
        let data = LineChartData(dataSet: set)
        chartView?.data = data
        
        let labelArray: [Int] = [0, 50, 100]
        let maxLabel = 100
        let minLabel = 0
        
        chartView?.leftAxis.axisMaximum = Double(maxLabel)
        chartView?.leftAxis.axisMinimum = Double(minLabel)
        
        yRender?.entries = labelArray
        setLimitLine(yVals.count, labelArray)
    }
    
    private var timeApart: [Int] = []
    private func setLimitLine(_ valueCount: Int, _ yLabels: [Int]) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            timeApart.append(i)
        }
        
        chartView?.xAxis.axisMinimum = 0
        chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(20) //限制屏幕最少显示100个点
        //self.chartView?.leftAxis.valueFormatter = YValueFormatter(values: yLabels)
        self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(timeApart, timeStamp)
        
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
    var isHiddenNavigationBar = false
    @objc
    private func zoomBtnTouchUpInside(sender: UIButton) {

        if !isZoomed {
            let vc = self.parentViewController()!
            if let navi = vc.navigationController {
                 if !navi.navigationBar.isHidden {
                     isHiddenNavigationBar = true
                     vc.navigationController?.setNavigationBarHidden(true, animated: true)
                 }
             }
            let view = vc.view
            let nShowChartView = UIView()
            nShowChartView.backgroundColor = UIColor.colorWithHexString(hexColor: "#E5E5E5")
            view?.addSubview(nShowChartView)
            if #available(iOS 13.0, *) {
                nShowChartView.backgroundColor = UIColor.systemBackground
            } else {
                // Fallback on earlier versions
                
            }
            let chart = AffectiveChartRelaxationView()
            nShowChartView.addSubview(chart)
            chart.chartHead?.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            chart.bgColor = self.bgColor
            chart.cornerRadius = self.cornerRadius
            chart.title = self.title
            chart.maxDataCount = 1000
            chart.uploadCycle = self.uploadCycle
            chart.textColor = self.textColor
            chart.lineColor = self.lineColor
            chart.isChartScale = true
            chart.setDataFromModel(relaxation: relaxationArray)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.isZoomed = true
            chart.isHiddenNavigationBar = isHiddenNavigationBar
            chart.avg = self.avg
            let label = UILabel()
            label.text = zoomText
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
                $0.center.equalTo(view!.snp.center)
            }
            
        } else {
            
            let view = self.superview!
            if isHiddenNavigationBar {
                view.parentViewController()?.navigationController?.setNavigationBarHidden(false, animated: true)
            }
            for e in view.subviews {
                e.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
        
    }


}
