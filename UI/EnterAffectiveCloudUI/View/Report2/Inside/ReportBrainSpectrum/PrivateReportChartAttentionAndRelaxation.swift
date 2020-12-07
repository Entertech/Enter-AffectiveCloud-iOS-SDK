//
//  PrivateReportChartAttentionAndRelaxation.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/26.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class PrivateReportChartAttentionAndRelaxation: UIView, ChartViewDelegate, UIGestureRecognizerDelegate {
    
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
    
    
    /// 注意力和放松度
    public enum AttentionOrRelaxation: String {
        case attention
        case relaxation
    }
    
    /// 注意力线条颜色
    public var attentionColor: UIColor = UIColor.colorWithHexString(hexColor: "#5FC695") {
        willSet {
            marker?.dot?.backgroundColor = newValue
        }
    }
    
    /// 放松度线条颜色
    public var relaxationColor: UIColor = UIColor.colorWithHexString(hexColor: "#4B5DCC") {
        willSet {
            marker?.dot2?.backgroundColor = newValue
        }
    }
    
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
    
    /// highlight 颜色
    public var highlightLineColor = UIColor.systemGray {
        willSet {
            marker?.lineColor = newValue
        }
    }
    /// x坐标说明文字
    public var xLabelText = "Time(min)" {
        willSet {
            xLabel?.text = newValue
        }
    }
    
    public var zoomText = "Zoom in on the curve and slide to view it."
    
    public var attentionLabelText = "Attention" {
        willSet {
            attentionLabel?.text = newValue
        }
    }
    
    public var relaxationLabelText = "Relaxation" {
        willSet {
            relaxationLabel?.text = newValue
        }
    }
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithHexString(hexColor: "333333") {
        didSet  {
            let changedColor = textColor.changeAlpha(to: 0.6)
            let secondColor = textColor.changeAlpha(to: 0.2)
            xLabel?.textColor = textColor
            
            chartView?.leftAxis.labelTextColor = changedColor
            chartView?.leftAxis.gridColor = secondColor
            chartView?.xAxis.labelTextColor = changedColor
            chartView?.xAxis.gridColor = changedColor
            chartView?.xAxis.axisLineColor = changedColor
            attentionLabel?.textColor = textColor
            relaxationLabel?.textColor = textColor
            r0Label.textColor = changedColor
            r30Label.textColor = changedColor
            r60Label.textColor = changedColor
            r90Label.textColor = changedColor
            a0Label.textColor = changedColor
            a30Label.textColor = changedColor
            a60Label.textColor = changedColor
            a100Label.textColor = changedColor
            marker?.label?.textColor = self.textColor
            marker?.label2?.textColor = self.textColor
            marker?.titleLabel?.textColor = changedColor
            marker?.title2Label?.textColor = changedColor
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
    
    
    /// 平均值的文案
    public var averageText = "Average"
    /// 放松度平均值
    public var relaxationAvg: Int = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue), label: "\(averageText): \(newValue)")
            if newValue > 70 {
                avgLine.labelPosition = .bottomRight
            }
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [4, 2]
            avgLine.lineColor = textColor
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            avgLine.lineWidth = 1
            avgLine.valueTextColor = textColor
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    /// 注意力放松度
    public var attentionAvg: Int = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue+130), label: "\(averageText): \(newValue)")
            if newValue > 70 {
                avgLine.labelPosition = .bottomRight
            }
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [4, 2]
            avgLine.lineWidth = 1
            avgLine.lineColor = textColor
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            avgLine.valueTextColor = textColor
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    
    /// Marker 的背景色
     public var markerBackgroundColor = UIColor.white {
         willSet {
             marker?.backgroundColor = newValue
         }
     }
    
    private var sample = 3
    //MARK:- Private UI
    private var maxDataCount = 100
    private let mainFont = "PingFangSC-Semibold"
    private var interval = 1.8
    private var timeStamp = 0
    private var attentionArray: [Int]?
    private var relaxationArray: [Int]?
    private var yRender: LimitYAxisRenderer?
    private var attentionSet: LineChartDataSet?
    private var relaxationSet: LineChartDataSet?
    private var chartHead: PrivateChartViewHead?
    private var titleLabel: UILabel?
    private var chartView: LineChartView?
    private var xLabel: UILabel?
    private var nShowChartView: UIView?
    private var attentionDot: UIView?
    private var relaxationDot: UIView?
    private var attentionLabel: UILabel?
    private var relaxationLabel: UILabel?
    private let r0Label = UILabel()
    private let r30Label = UILabel()
    private let r60Label = UILabel()
    private let r90Label = UILabel()
    private let a0Label = UILabel()
    private let a30Label = UILabel()
    private let a60Label = UILabel()
    private let a100Label = UILabel()
    private var marker: TwoValueMarkerView?
    private lazy var aIcon = UIImage.highlightIcon(centerColor: self.attentionColor)
    private lazy var rIcon = UIImage.highlightIcon(centerColor: self.relaxationColor)
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
            $0.top.equalTo(chartHead!.snp.bottom).offset(10)
            $0.right.equalTo(attentionLabel!.snp.left).offset(-5)
        }
        
        attentionLabel!.snp.makeConstraints {
            $0.right.equalTo(relaxationDot!.snp.left).offset(-24)
            $0.centerY.equalTo(attentionDot!.snp.centerY)
        }
        
        relaxationDot?.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.top.equalTo(chartHead!.snp.bottom).offset(10)
            $0.right.equalTo(relaxationLabel!.snp.left).offset(-5)
        }
        
        relaxationLabel?.snp.makeConstraints {
            //$0.right.equalToSuperview().offset(-24)
            $0.left.equalToSuperview().offset(123)
            $0.centerY.equalTo(relaxationDot!.snp.centerY)
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        chartView?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-8)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-35)
        }
        
        
        r0Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(320)
        }
        
        r30Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(287)
        }
        
        r60Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(244)
        }
        
        r90Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(212)
        }
        
        a0Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(179)
        }
        
        a30Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(147)
        }
        a60Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(105)
        }
        a100Label.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(23)
            $0.top.equalToSuperview().offset(72)
        }
        
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(380)
        }
    }
    
    func initFunction() {
        let alphaColor = textColor.changeAlpha(to: 0.6)
        let secondColor = textColor.changeAlpha(to: 0.2)
        
        self.layer.cornerRadius = cornerRadius
        
        xLabel = UILabel()
        xLabel?.text = "Time(min)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = textColor
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
        attentionLabel?.textColor = textColor
        attentionLabel?.text = "Attention"
        self.addSubview(attentionLabel!)
        relaxationLabel = UILabel()
        relaxationLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        relaxationLabel?.textColor = textColor
        relaxationLabel?.text = "Relaxation"
        self.addSubview(relaxationLabel!)
        
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
        chartView?.extraTopOffset = 80
        chartView?.highlightPerTapEnabled = false
        chartView?.highlightPerDragEnabled = false
        chartView?.animate(xAxisDuration: 0.5)
        let press = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        chartView?.addGestureRecognizer(press)//添加长按事件
        chartView?.extraLeftOffset = 26
        
        marker = TwoValueMarkerView(frame: CGRect(x: 0, y: 0, width: 155, height: 47))
        marker?.chartView = chartView
        marker?.titleLabel?.text = "Attention"
        marker?.title2Label?.text = "Relaxation"
        marker?.titleLabel?.textColor = alphaColor
        marker?.title2Label?.textColor = alphaColor
        marker?.dot?.backgroundColor = self.attentionColor
        marker?.dot2?.backgroundColor = self.relaxationColor
        chartView?.marker = marker
        
        let leftAxis = chartView!.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = alphaColor
        leftAxis.axisMaximum = 230
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.axisLineColor = secondColor
        leftAxis.gridColor = secondColor
        leftAxis.gridLineDashLengths = [3,2]
        leftAxis.gridLineWidth = 1
        leftAxis.gridLineDashPhase = 1
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.axisLineWidth = 1
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = alphaColor
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.axisLineColor = alphaColor
        self.addSubview(chartView!)
        
        chartView?.addSubview(r0Label)
        chartView?.addSubview(r30Label)
        chartView?.addSubview(r60Label)
        chartView?.addSubview(r90Label)
        chartView?.addSubview(a0Label)
        chartView?.addSubview(a30Label)
        chartView?.addSubview(a60Label)
        chartView?.addSubview(a100Label)
        r0Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        r30Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        r60Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        r90Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        a0Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        a30Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        a60Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        a100Label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        r0Label.textAlignment = .right
        r30Label.textAlignment = .right
        r60Label.textAlignment = .right
        r90Label.textAlignment = .right
        a0Label.textAlignment = .right
        a30Label.textAlignment = .right
        a60Label.textAlignment = .right
        a100Label.textAlignment = .right
        r0Label.text = "0"
        r30Label.text = "30"
        r60Label.text = "70"
        r90Label.text = "100"
        a0Label.text = "0"
        a30Label.text = "30"
        a60Label.text = "70"
        a100Label.text = "100"
        r0Label.textColor = alphaColor
        r30Label.textColor = alphaColor
        r60Label.textColor = alphaColor
        r90Label.textColor = alphaColor
        a0Label.textColor = alphaColor
        a30Label.textColor = alphaColor
        a60Label.textColor = alphaColor
        a100Label.textColor = alphaColor
        
        chartHead = PrivateChartViewHead()
        chartHead?.titleText = "Changes During Meditation"
        chartHead?.expandBtn.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        self.addSubview(chartHead!)
    }
    
    
    /// 输入数据
    /// - Parameters:
    ///   - array: 数组
    ///   - state: 注意力或放松度
    ///   - timestamp: 时间戳，可不传
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
                initValue = state == .attention ? waveArray[i] + 130 : waveArray[i]
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

                    notZero = state == .attention ? waveArray[i]+130 : waveArray[i]
                    
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
        set.setColor(lineColor)
        set.drawIconsEnabled = true
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = highlightLineColor
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        if state == .attention {
            attentionSet = set
        } else {
            relaxationSet = set
        }
        chartData(valCount: yVals.count)
        yRender?.entries = [30, 70, 100, 160, 200, 230]
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
        
        let centerLine = ChartLimitLine(limit: 130)
        centerLine.lineColor = textColor.changeAlpha(to: 0.6)
        centerLine.lineWidth = 1
        chartView?.leftAxis.addLimitLine(centerLine)
        
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            timeApart.append(i)
        }
        
        chartView?.xAxis.axisMinimum = 0
        chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(100)//限制屏幕最少显示100个点
        chartView?.maxVisibleCount = valueCount*2 + 1
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
            let chart = PrivateReportChartAttentionAndRelaxation()
            nShowChartView.addSubview(chart)
            chart.bgColor = self.bgColor
            chart.cornerRadius = self.cornerRadius
            chart.maxDataCount = 500
            chart.textColor = self.textColor
            chart.isChartScale = true
            chart.attentionColor = self.attentionColor
            chart.relaxationColor = self.relaxationColor
            chart.highlightLineColor = self.highlightLineColor
            chart.markerBackgroundColor = self.markerBackgroundColor
            chart.chartView?.highlightPerTapEnabled = false
            chart.chartView?.highlightPerDragEnabled = false
            chart.setDataFromModel(array: self.attentionArray, state: .attention)
            chart.setDataFromModel(array: self.relaxationArray, state: .relaxation)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.chartHead?.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            chart.isZoomed = true
            chart.isHiddenNavigationBar = isHiddenNavigationBar
            chart.attentionAvg = self.attentionAvg
            chart.relaxationAvg = self.relaxationAvg
            let label = UILabel()
            label.text = zoomText
            label.font = UIFont.systemFont(ofSize: 12)
            chart.chartHead?.addSubview(label)
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
    
    @objc
    private func tapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let h = chartView?.getHighlightByTouchPoint(sender.location(in: self))
            if h === nil || h == chartView?.lastHighlighted {
                chartView?.lastHighlighted = nil
                chartView?.highlightValue(nil)
                chartHead?.isHidden = true
                chartView?.delegate?.chartViewDidEndPanning?(chartView!)
            } else {
                chartView?.lastHighlighted = h
                chartView?.highlightValue(h)
                setUiHidden(isHidden: true)
                chartView?.delegate?.chartValueSelected?(chartView!, entry: chartView!.data!.entryForHighlight(h!)!, highlight: h!)
            }
        } else if sender.state == .changed {
            let h = chartView?.getHighlightByTouchPoint(sender.location(in: self))
            if let h = h {
                chartView?.lastHighlighted = h
                chartView?.highlightValue(h)
                setUiHidden(isHidden: true)
                chartView?.delegate?.chartValueSelected?(chartView!, entry: chartView!.data!.entryForHighlight(h)!, highlight: h)
            }
        } else if sender.state == .ended {
            chartView?.lastHighlighted = nil
            chartView?.highlightValue(nil)
            setUiHidden(isHidden: true)
            chartView?.delegate?.chartViewDidEndPanning?(chartView!)
        }

    }
    //MARK: - 设置chart点击的代理
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        chartView.lastHighlighted = nil
        chartView.highlightValue(nil)
        setUiHidden(isHidden: false)
        
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[1].entryForIndex(i)?.icon = nil
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if !chartHead!.isHidden {
            setUiHidden(isHidden: true)
        }
        
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[1].entryForIndex(i)?.icon = nil
        }
        var index = chartView.data?.dataSets[0].entryIndex(entry: entry)
        if index == nil || index == -1 {
            index = chartView.data?.dataSets[1].entryIndex(entry: entry)
        }
        if let index = index {

            chartView.data?.dataSets[0].entryForIndex(index)?.icon = aIcon
            chartView.data?.dataSets[1].entryForIndex(index)?.icon = rIcon
            

        }
        
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        setUiHidden(isHidden: true)
    }
    
    private func setUiHidden(isHidden: Bool) {
        chartHead?.isHidden = isHidden
        attentionDot?.isHidden = isHidden
        relaxationDot?.isHidden = isHidden
        attentionLabel?.isHidden = isHidden
        relaxationLabel?.isHidden = isHidden
    }
    
}
