//
//  PrivateReportChartAttentionAndRelaxation.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/26.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class PrivateReportChartAttentionAndRelaxation: UIView, ChartViewDelegate {
    public enum AttentionOrRelaxation: String {
        case attention
        case relaxation
    }
    
    public var attentionColor: UIColor = UIColor.colorWithHexString(hexColor: "#5FC695")
    public var relaxationColor: UIColor = UIColor.colorWithHexString(hexColor: "#4B5DCC")
    
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
    
    public var title: String = "Changes During Meditation" {
        willSet {
            chartHead?.titleText = newValue
        }
    }
    
    private var sample = 3
    
    public var relaxationAvg: Int = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue + 100), label: "AVG: \(newValue)")
            if newValue > 70 {
                avgLine.labelPosition = .bottomRight
            }
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [8, 4]
            avgLine.lineColor = textColor.changeAlpha(to: 0.5)
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            avgLine.lineWidth = 1
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    
    public var attentionAvg: Int = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue), label: "AVG: \(newValue)")
            if newValue > 70 {
                avgLine.labelPosition = .bottomRight
            }
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [8, 4]
            avgLine.lineWidth = 1
            avgLine.lineColor = textColor.changeAlpha(to: 0.5)
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    
    //MARK:- Private UI
    private var maxDataCount = 100
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.8
    private var timeStamp = 0
    private var attentionArray: [Int]?
    private var relaxationArray: [Int]?
    private var yRender: LimitYAxisRenderer?
    private var attentionSet: LineChartDataSet?
    private var relaxationSet: LineChartDataSet?
    //MARK:- Private UI
    private var chartHead: PrivateChartViewHead?
    private var titleLabel: UILabel?
    private var chartView: LineChartView?
    private var xLabel: UILabel?
    private var nShowChartView: UIView?
    private var attentionDot: UIView?
    private var relaxationDot: UIView?
    private var attentionLabel: UILabel?
    private var relaxationLabel: UILabel?
    private var attention0: UILabel?
    private var attention100: UILabel?
    private var relaxation0: UILabel?
    private var relaxation100: UILabel?
    private var lineView: UIView?
    
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
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else {
            return
        }
        
        attentionDot?.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.top.equalTo(chartHead!.snp.bottom).offset(14)
            $0.right.equalTo(attentionLabel!.snp.left).offset(-5)
        }
        
        attentionLabel!.snp.makeConstraints {
            $0.right.equalTo(relaxationDot!.snp.left).offset(-24)
            $0.centerY.equalTo(attentionDot!.snp.centerY)
        }
        
        relaxationDot?.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.top.equalTo(chartHead!.snp.bottom).offset(14)
            $0.right.equalTo(relaxationLabel!.snp.left).offset(-5)
        }
        
        relaxationLabel?.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalTo(relaxationDot!.snp.centerY)
        }
        
        attention0?.snp.makeConstraints {
            $0.right.equalTo(chartView!.snp.left).offset(4)
            $0.bottom.equalTo(chartView!.snp.bottom).offset(-16)
        }
        
        attention100?.snp.makeConstraints {
            $0.right.equalTo(chartView!.snp.left).offset(4)
            $0.centerY.equalTo(chartView!.snp.centerY).offset(4)
        }
        
        relaxation100?.snp.makeConstraints {
            $0.right.equalTo(chartView!.snp.left).offset(4)
            $0.top.equalTo(chartHead!.snp.bottom).offset(33)
        }
        
        relaxation0?.snp.makeConstraints {
            $0.right.equalTo(chartView!.snp.left).offset(4)
            $0.centerY.equalTo(chartView!.snp.centerY).offset(-12)
        }
        
        lineView?.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(chartView!.snp.centerY).offset(-5)
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        chartView?.snp.makeConstraints {
            $0.top.equalTo(chartHead!.snp.bottom).offset(25)
            $0.right.equalToSuperview().offset(-8)
            $0.left.equalToSuperview().offset(35)
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(283)
        }
    }
    
    func initFunction() {
        let alphaColor = textColor.changeAlpha(to: 0.7)
        let secondColor = textColor.changeAlpha(to: 0.5)
        let thirdColor = textColor.changeAlpha(to: 0.3)
        
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
        
        attentionDot = UIView()
        attentionDot?.backgroundColor = attentionColor
        attentionDot?.layer.cornerRadius = 4
        self.addSubview(attentionDot!)
        
        relaxationDot = UIView()
        relaxationDot?.backgroundColor = relaxationColor
        relaxationDot?.layer.cornerRadius = 4
        self.addSubview(relaxationDot!)
        
        attentionLabel = UILabel()
        attentionLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        attentionLabel?.textColor = alphaColor
        attentionLabel?.text = "Attention"
        self.addSubview(attentionLabel!)
        relaxationLabel = UILabel()
        relaxationLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        relaxationLabel?.textColor = alphaColor
        relaxationLabel?.text = "Relaxation"
        self.addSubview(relaxationLabel!)
        
        attention0 = UILabel()
        attention0?.font = UIFont.systemFont(ofSize: 12)
        attention0?.textColor = secondColor
        attention0?.text = "0"
        attention0?.textAlignment = .right
        self.addSubview(attention0!)
        attention100 = UILabel()
        attention100?.font = UIFont.systemFont(ofSize: 12)
        attention100?.textColor = secondColor
        attention100?.text = "100"
        attention100?.textAlignment = .right
        self.addSubview(attention100!)
        relaxation0 = UILabel()
        relaxation0?.font = UIFont.systemFont(ofSize: 12)
        relaxation0?.textColor = secondColor
        relaxation0?.text = "0"
        relaxation0?.textAlignment = .right
        self.addSubview(relaxation0!)
        relaxation100 = UILabel()
        relaxation100?.font = UIFont.systemFont(ofSize: 12)
        relaxation100?.textColor = secondColor
        relaxation100?.text = "100"
        relaxation100?.textAlignment = .right
        self.addSubview(relaxation100!)
        
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
        leftAxis.labelTextColor = secondColor
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.axisLineColor = thirdColor
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.gridLineWidth = 1
        xAxis.labelPosition = .bottom
        xAxis.gridColor = thirdColor
        xAxis.labelTextColor = secondColor
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)

        self.addSubview(chartView!)
        
        lineView = UIView()
        lineView?.backgroundColor = thirdColor
        lineView?.layer.cornerRadius = 0.5
        self.addSubview(lineView!)
    }
    
    public func setDataFromModel(array: [Int]?, state: AttentionOrRelaxation,  timestamp: Int? = nil) {
        
        if let timestamp = timestamp, timestamp != 0 {
            timeStamp = timestamp
            
            xLabel?.isHidden = true
        }
        
        if let array = array {
            sample = array.count / maxDataCount
            sample = array.count / maxDataCount == 0 ? 1 : array.count / maxDataCount
            switch state {
            case .attention:
                attentionArray = array
                
            case .relaxation:
                relaxationArray = array
            }
            setDataCount(array, state: state)
        }
        
    }
    
    //MARK:- Chart delegate
    private func setDataCount(_ waveArray: [Int], state: AttentionOrRelaxation) {
        var colors: [UIColor] = []
        var initValue = 0
        var initIndex = 0
        
        let checkNum = 0
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if waveArray[i] > checkNum {
                initValue = state == .attention ? waveArray[i] : waveArray[i] + 100
                initIndex = i
                break
            }
        }

        var yVals: [ChartDataEntry] = []
        var notZero: Int = 0
        let lineColor = state == .attention ? attentionColor : relaxationColor
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if i < initIndex{
                colors.append(lineColor)
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if waveArray[i] == checkNum {
                    colors.append(lineColor)
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                } else {

                    notZero = state == .attention ? waveArray[i] : waveArray[i] + 100
                    
                    colors.append(lineColor)
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                }
            }
        }
        
        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.colors = colors
        set.drawValuesEnabled = false
        if state == .attention {
            attentionSet = set
        } else {
            relaxationSet = set
        }
        chartData(valCount: yVals.count)
        
    }
    
    private func chartData(valCount: Int) {
        guard let attention = self.attentionSet, let relaxation = self.relaxationSet else {
            return
        }
        let data = LineChartData(dataSets: [attention, relaxation])
        chartView?.data = data
        
        setLimitLine(valCount)
    }
    
    private var timeApart: [Int] = []
    private func setLimitLine(_ valueCount: Int) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            timeApart.append(i)
        }
        
        chartView?.xAxis.axisMinimum = 0
        chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(100) //限制屏幕最少显示100个点
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
            
            let chart = PrivateReportChartAttentionAndRelaxation()
            nShowChartView.addSubview(chart)
            chart.bgColor = self.bgColor
            chart.cornerRadius = self.cornerRadius
            chart.maxDataCount = 500
            chart.textColor = self.textColor
            chart.isChartScale = true
            chart.attentionColor = self.attentionColor
            chart.relaxationColor = self.relaxationColor
            chart.setDataFromModel(array: self.attentionArray, state: .attention)
            chart.setDataFromModel(array: self.relaxationArray, state: .relaxation)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.chartHead?.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            chart.isZoomed = true
            chart.isHiddenNavigationBar = isHiddenNavigationBar
            chart.attentionAvg = self.attentionAvg
            chart.relaxationAvg = self.relaxationAvg
            let label = UILabel()
            label.text = "Zoom in on the curve and slide to view it."
            label.font = UIFont.systemFont(ofSize: 12)
            chart.addSubview(label)
            label.snp.makeConstraints {
                $0.right.equalTo(chart.chartHead!.expandBtn.snp.left).offset(-12)
                $0.centerY.equalTo(chart.chartHead!.expandBtn.snp.centerY)
            }
            nShowChartView.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(view!.safeAreaLayoutGuide)
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
