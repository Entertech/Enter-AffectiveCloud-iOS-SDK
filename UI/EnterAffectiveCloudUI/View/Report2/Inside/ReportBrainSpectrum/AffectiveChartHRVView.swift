//
//  ReportChartHRV.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/25.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class AffectiveChartHRVView: UIView, ChartViewDelegate, UIGestureRecognizerDelegate {
    
    public var lineColor: UIColor = UIColor.colorWithHexString(hexColor: "#FFC56F") {
        willSet {
            marker?.dot?.backgroundColor = newValue
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
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithHexString(hexColor: "11152e") {
        didSet  {
            let changedColor = textColor.changeAlpha(to: 0.6)
            let secondColor = textColor.changeAlpha(to: 0.2)
            xLabel?.textColor = self.textColor
            
            chartView?.leftAxis.labelTextColor = changedColor
            chartView?.xAxis.labelTextColor = changedColor
            chartView?.xAxis.gridColor = secondColor
            chartView?.leftAxis.gridColor = secondColor
            chartView?.xAxis.axisLineColor = changedColor
            chartView?.leftAxis.axisLineColor = changedColor
            
            marker?.label?.textColor = self.textColor
            marker?.titleLabel?.textColor = changedColor
        }
    }
    
    /// 平均值的文案
    public var averageText = "Average"

    /// 设置平均值
    public var hrvAvg: Float = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue), label: String.init(format: "%@: %.1f", averageText, newValue))
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [4, 2]
            avgLine.lineColor = textColor
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            avgLine.valueTextColor = textColor
            avgLine.lineWidth = 1
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    /// Marker 的背景色
    public var markerBackgroundColor = UIColor.white {
        willSet {
            marker?.backgroundColor = newValue
        }
    }
    /// 标题
    public var title: String = "心率变异性（HRV）" {
        willSet {
            chartHead?.titleText = newValue
        }
    }
    /// x坐标说明文字
    public var xLabelText = "Time(min)" {
        willSet {
            xLabel?.text = newValue
        }
    }
    /// highlight 颜色
    public var highlightLineColor = UIColor.systemGray {
        willSet {
            marker?.lineColor = newValue
        }
    }
    
    public var zoomText = "Zoom in on the curve and slide to view it."
    
    //MARK:- Private UI
    private var isChartScale = false {
        willSet {
            chartView?.scaleXEnabled = newValue
            chartHead?.expandBtn.isHidden = !newValue
        }
    }
    
    private var sample = 3
    private var maxDataCount = 100
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.4
    private var timeStamp = 0
    private var hrvArray: [Int]?
    private var yRender: LimitYAxisRenderer?
    private var chartHead: PrivateChartViewHead?
    private var titleLabel: UILabel?
    private var chartView: LineChartView?
    private var xLabel: UILabel?
    private var msLabel: UILabel?
    private var nShowChartView: UIView?
    private var marker: ValueMarkerView?
    private var panGesture: UIPanGestureRecognizer?
    private lazy var dotIcon = UIImage.highlightIcon(centerColor: self.lineColor)
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
            $0.top.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-8)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-35)
        }
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(250)
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
        chartView?.animate(xAxisDuration: 0.5)
        chartView?.extraTopOffset = 60
        chartView?.highlightPerTapEnabled = false
        chartView?.highlightPerDragEnabled = false
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        //pressGesture.delegate = self
        chartView?.addGestureRecognizer(pressGesture)//添加长按事件
        
        //chartView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
        marker = ValueMarkerView(frame: CGRect(x: 0, y: 0, width: 50, height: 47))
        marker?.chartView = chartView
        marker?.titleLabel?.text = "HRV"
        marker?.titleLabel?.textColor = alphaColor
        marker?.dot?.backgroundColor = lineColor
        chartView?.marker = marker
        
        let leftAxis = chartView!.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = alphaColor
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.gridColor = secondColor
        leftAxis.gridLineWidth = 1
        leftAxis.gridLineDashPhase = 1
        leftAxis.gridLineDashLengths = [3,2]
        leftAxis.axisMaxLabels = 5
        leftAxis.axisLineColor = secondColor
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.gridLineWidth = 0.5
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = alphaColor
        xAxis.labelTextColor = alphaColor
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.axisLineWidth = 1

        self.addSubview(chartView!)
        
        chartHead = PrivateChartViewHead()
        chartHead?.titleText = title
        chartHead?.expandBtn.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        self.addSubview(chartHead!)
    }
    
    public func setDataFromModel(hrv: [Int]?, timestamp: Int? = nil) {
        
        if let timestamp = timestamp, timestamp != 0 {
            timeStamp = timestamp
            
            xLabel?.isHidden = true
        }
        
        if let hrv = hrv {
            sample = hrv.count / maxDataCount == 0 ? 1 : hrv.count / maxDataCount
            hrvArray = hrv
            setDataCount(hrv)
        }
        
    }
    //MARK:- Chart delegate
    private func setDataCount(_ waveArray: [Int]) {
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
                colors.append(.clear) //后期更改需求，不需要分别无效数据颜色
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if waveArray[i] == 0 {//为0的为无效数据
                    colors.append(.clear)
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                } else { 
                    if minValue > waveArray[i] {
                        minValue = waveArray[i]
                    }
                    if maxValue < waveArray[i] {
                        maxValue = waveArray[i]
                    }
                    notZero = waveArray[i]
                    colors.append(.clear)
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
        set.lineWidth = 2
        set.setColor(lineColor)
        set.drawIconsEnabled = true
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = highlightLineColor
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView?.data = data
        
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
                        chartView?.leftAxis.axisMaximum = Double(maxLabel+scale)
                        chartView?.leftAxis.axisMinimum = Double(minLabel)
                        labelArray.append(minLabel)
                        labelArray.append((maxLabel+scale)-(maxLabel-minLabel+scale)*3/4)
                        labelArray.append((maxLabel+scale)-(maxLabel-minLabel+scale)*2/4)
                        labelArray.append((maxLabel+scale)-(maxLabel-minLabel+scale)*1/4)
                        labelArray.append(maxLabel+scale)
                        break
                    }
                } else {
                    if (maxLabel - (minLabel-scale)) % 4 == 0 {
                        chartView?.leftAxis.axisMaximum = Double(maxLabel)
                        chartView?.leftAxis.axisMinimum = Double(minLabel-scale)
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
            chartView?.leftAxis.axisMaximum = Double(minLabel+8)
            chartView?.leftAxis.axisMinimum = Double(minLabel)
            labelArray.append(minLabel)
            labelArray.append(minLabel+2)
            labelArray.append(minLabel+4)
            labelArray.append(minLabel+6)
            labelArray.append(minLabel+8)
        }
        yRender?.entries = labelArray
        setLimitLine(yVals.count, labelArray)
    }
    
    private var timeApart: [Int] = []
    private func setLimitLine(_ valueCount: Int, _ yLabels: [Int]) {
        guard valueCount > 1 else {
            return
        }
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            timeApart.append(i)
        }
        
        chartView?.xAxis.axisMinimum = 0
        chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(100) //限制屏幕最少显示100个点
        chartView?.maxVisibleCount = valueCount + 1
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
            let chart = AffectiveChartHRVView()
            nShowChartView.addSubview(chart)
            chart.chartHead?.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            chart.bgColor = self.bgColor
            chart.lineColor = self.lineColor
            chart.cornerRadius = self.cornerRadius
            chart.maxDataCount = 1000
            chart.textColor = self.textColor
            chart.isChartScale = true
            chart.setDataFromModel(hrv: hrvArray)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.isZoomed = true
            chart.isHiddenNavigationBar = isHiddenNavigationBar
            chart.chartView?.highlightPerTapEnabled = false
            chart.chartView?.highlightPerDragEnabled = false
            chart.highlightLineColor = self.highlightLineColor
            chart.markerBackgroundColor = self.markerBackgroundColor
            chart.hrvAvg = self.hrvAvg
            chart.title = self.title
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
                chartHead?.isHidden = true
                chartView?.delegate?.chartValueSelected?(chartView!, entry: chartView!.data!.entryForHighlight(h!)!, highlight: h!)
            }
        } else if sender.state == .changed {
            let h = chartView?.getHighlightByTouchPoint(sender.location(in: self))
            if let h = h {
                chartView?.lastHighlighted = h
                chartView?.highlightValue(h)
                chartHead?.isHidden = true
                chartView?.delegate?.chartValueSelected?(chartView!, entry: chartView!.data!.entryForHighlight(h)!, highlight: h)
            }
        } else if sender.state == .ended {
            chartView?.lastHighlighted = nil
            chartView?.highlightValue(nil)
            chartHead?.isHidden = false
            chartView?.delegate?.chartViewDidEndPanning?(chartView!)
        }
    }
    
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        chartView.lastHighlighted = nil
        chartView.highlightValue(nil)
        chartHead?.isHidden = false
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if !chartHead!.isHidden {
            chartHead?.isHidden = true
        }
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
        }
        entry.icon = dotIcon
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartHead?.isHidden = false
    }
    
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

//        return (gestureRecognizer.isKind(of: UILongPressGestureRecognizer.classForCoder()) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder())) || (gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) && otherGestureRecognizer.isKind(of: UITapGestureRecognizer.classForCoder()))
    //}

}
