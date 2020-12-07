//
//  ReportBrainSpectrum.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/24.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SnapKit

public class AffectiveChartBrainSpectrumView: UIView, ChartViewDelegate, UIGestureRecognizerDelegate{
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
            let changedColor = textColor.changeAlpha(to: 0.6)
            xLabel?.textColor = textColor
            gamaLabel?.textColor = changedColor
            betaLabel?.textColor = changedColor
            alphaLabel?.textColor = changedColor
            thetaLabel?.textColor = changedColor
            deltaLabel?.textColor = changedColor
            chartView?.xAxis.labelTextColor = changedColor
            chartView?.leftAxis.labelTextColor = changedColor
            
            for i in 0..<5 {
                marker?.labelArray[i].textColor = textColor
                marker?.titleLabelArray[i].textColor = changedColor
            }
        }
    }
    /// x坐标说明文字
    public var xLabelText = "Time(min)" {
        willSet {
            xLabel?.text = newValue
        }
    }
    
    /// Marker 的背景色
     public var markerBackgroundColor = UIColor.white {
         willSet {
             marker?.backgroundColor = newValue
         }
     }
    
    /// highlight 颜色
    public var highlightLineColor = UIColor.systemGray {
        willSet {
            marker?.lineColor = newValue
        }
    }
    public var zoomText = "Zoom in on the curve and slide to view it."
    
    /// 5段脑波频谱的颜色
    public var spectrumColors: [UIColor] = [UIColor.colorWithHexString(hexColor: "#FF6682"),
                                            UIColor.colorWithHexString(hexColor: "#FB9C98"),
                                            UIColor.colorWithHexString(hexColor: "#F7C77E"),
                                            UIColor.colorWithHexString(hexColor: "#5FC695"),
                                            UIColor.colorWithHexString(hexColor: "#5E75FF")] {
        didSet {
            guard spectrumColors.count == 5 else {
                print("WARNING: The array 'spectrumColors' needs 5 params")
                return
            }
            gamaDot?.backgroundColor = spectrumColors[0]
            betaDot?.backgroundColor = spectrumColors[1]
            alphaDot?.backgroundColor = spectrumColors[2]
            thetaDot?.backgroundColor = spectrumColors[3]
            deltaDot?.backgroundColor = spectrumColors[4]
            
            marker?.dotArray[0].backgroundColor = spectrumColors[0]
            marker?.dotArray[1].backgroundColor = spectrumColors[1]
            marker?.dotArray[2].backgroundColor = spectrumColors[2]
            marker?.dotArray[3].backgroundColor = spectrumColors[3]
            marker?.dotArray[4].backgroundColor = spectrumColors[4]

            chartView?.gridBackgroundColor = .clear
        }
    }
    
    private var isChartScale = false {
        willSet {
            chartView?.scaleXEnabled = newValue
            chartHead?.expandBtn.isHidden = !newValue
        }
    }
    
    public var title: String = "脑波频谱" {
        willSet {
            chartHead?.titleText = newValue
        }
    }
    
    private var sample = 3
    
    //MARK:- Private
    private var maxDataCount = 100
    private let mainFont = "PingFangSC-Semibold"
    private var interval = 1.8
    private var timeStamp = 0
    private var alphaArray: [Float]? = []
    private var betaArray: [Float]? = []
    private var gamaArray: [Float]? = []
    private var deltaArray: [Float]? = []
    private var thetaArray: [Float]? = []

    //MARK:- Private UI
    fileprivate var chartView: LineChartView?
    private var chartHead: PrivateChartViewHead?
    private var gamaDot: UIView?
    private var gamaLabel: UILabel?
    private var betaDot: UIView?
    private var betaLabel: UILabel?
    private var alphaDot: UIView?
    private var alphaLabel: UILabel?
    private var thetaDot: UIView?
    private var thetaLabel: UILabel?
    private var deltaDot: UIView?
    private var deltaLabel: UILabel?
    private var xLabel: UILabel?
    private var marker: FiveValueMarkerView?
    private lazy var gamaIcon = UIImage.highlightIcon(centerColor: self.spectrumColors[0])
    private lazy var betaIcon = UIImage.highlightIcon(centerColor: self.spectrumColors[1])
    private lazy var alphaIcon = UIImage.highlightIcon(centerColor: self.spectrumColors[2])
    private lazy var thetaIcon = UIImage.highlightIcon(centerColor: self.spectrumColors[3])
    private lazy var deltaIcon = UIImage.highlightIcon(centerColor: self.spectrumColors[4])
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else {
            return
        }
        gamaDot?.snp.makeConstraints {
            $0.top.equalTo(chartHead!.snp.bottom).offset(13)
            $0.right.equalToSuperview().offset(-26)
            $0.width.height.equalTo(8)
        }
        betaDot?.snp.makeConstraints {
            $0.top.equalTo(chartHead!.snp.bottom).offset(55)
            $0.right.equalToSuperview().offset(-26)
            $0.width.height.equalTo(8)
        }
        alphaDot?.snp.makeConstraints {
            $0.top.equalTo(chartHead!.snp.bottom).offset(96)
            $0.right.equalToSuperview().offset(-26)
            $0.width.height.equalTo(8)
        }
        thetaDot?.snp.makeConstraints {
            $0.top.equalTo(chartHead!.snp.bottom).offset(140)
            $0.right.equalToSuperview().offset(-26)
            $0.width.height.equalTo(8)
        }
        deltaDot?.snp.makeConstraints {
            $0.bottom.equalTo(chartView!.snp.bottom).offset(-20)
            $0.right.equalToSuperview().offset(-26)
            $0.width.height.equalTo(8)
        }
        
        gamaLabel?.snp.makeConstraints {
            $0.centerY.equalTo(gamaDot!.snp.centerY)
            $0.left.equalTo(gamaDot!.snp.right).offset(4)
        }
        betaLabel?.snp.makeConstraints {
            $0.centerY.equalTo(betaDot!.snp.centerY)
            $0.left.equalTo(betaDot!.snp.right).offset(4)
        }
        alphaLabel?.snp.makeConstraints {
            $0.centerY.equalTo(alphaDot!.snp.centerY)
            $0.left.equalTo(alphaDot!.snp.right).offset(4)
        }
        thetaLabel?.snp.makeConstraints {
            $0.centerY.equalTo(thetaDot!.snp.centerY)
            $0.left.equalTo(thetaDot!.snp.right).offset(4)
        }
        deltaLabel?.snp.makeConstraints {
            $0.centerY.equalTo(deltaDot!.snp.centerY)
            $0.left.equalTo(deltaDot!.snp.right).offset(4)
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        chartView?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-30)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-35)
        }
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(292)
        }
    }
    
    private func initFunction() {
        self.layer.cornerRadius = cornerRadius
        
        let alphaColor = textColor.changeAlpha(to: 0.6)
        gamaDot = UIView()
        gamaDot?.backgroundColor = spectrumColors[0]
        gamaDot?.layer.cornerRadius = 4
        gamaDot?.layer.masksToBounds = true
        self.addSubview(gamaDot!)

        betaDot = UIView()
        betaDot?.backgroundColor = spectrumColors[1]
        betaDot?.layer.cornerRadius = 4
        betaDot?.layer.masksToBounds = true
        self.addSubview(betaDot!)

        alphaDot = UIView()
        alphaDot?.backgroundColor = spectrumColors[2]
        alphaDot?.layer.cornerRadius = 4
        alphaDot?.layer.masksToBounds = true
        self.addSubview(alphaDot!)

        thetaDot = UIView()
        thetaDot?.backgroundColor = spectrumColors[3]
        thetaDot?.layer.cornerRadius = 4
        thetaDot?.layer.masksToBounds = true
        self.addSubview(thetaDot!)

        deltaDot = UIView()
        deltaDot?.backgroundColor = spectrumColors[4]
        deltaDot?.layer.cornerRadius = 4
        deltaDot?.layer.masksToBounds = true
        self.addSubview(deltaDot!)

        gamaLabel = UILabel()
        gamaLabel?.text = "γ"
        gamaLabel?.textColor = alphaColor
        gamaLabel?.textAlignment = .left
        gamaLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(gamaLabel!)

        betaLabel = UILabel()
        betaLabel?.text = "β"
        betaLabel?.textColor = alphaColor
        betaLabel?.textAlignment = .left
        betaLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(betaLabel!)

        alphaLabel = UILabel()
        alphaLabel?.text = "α"
        alphaLabel?.textColor = alphaColor
        alphaLabel?.textAlignment = .left
        alphaLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(alphaLabel!)

        thetaLabel = UILabel()
        thetaLabel?.text = "θ"
        thetaLabel?.textColor = alphaColor
        thetaLabel?.textAlignment = .left
        thetaLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(thetaLabel!)

        deltaLabel = UILabel()
        deltaLabel?.text = "δ"
        deltaLabel?.textColor = alphaColor
        deltaLabel?.textAlignment = .left
        deltaLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(deltaLabel!)
        
        xLabel = UILabel()
        xLabel?.text = "Time(min)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = alphaColor
        self.addSubview(xLabel!)
        
        chartView = LineChartView()
        chartView?.delegate = self
        chartView?.backgroundColor = .clear
        chartView?.gridBackgroundColor = .clear
        chartView?.drawGridBackgroundEnabled = true
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription?.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.scaleXEnabled = false
        chartView?.scaleYEnabled = false
        chartView?.legend.enabled = false
        chartView?.extraTopOffset = 58
        chartView?.highlightPerTapEnabled = false
        chartView?.highlightPerDragEnabled = false
        chartView?.animate(xAxisDuration: 0.5)
        self.addSubview(chartView!)
        
        let leftAxis = chartView!.leftAxis
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.setLabelCount(5, force: true)
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = alphaColor
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = alphaColor
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.axisMaxLabels = 8
        xAxis.drawAxisLineEnabled = false
        
        chartHead = PrivateChartViewHead()
        chartHead?.titleText = title
        chartHead?.expandBtn.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        self.addSubview(chartHead!)
        
        marker = FiveValueMarkerView(frame: CGRect(x: 0, y: 0, width: 242, height: 47))
        marker?.chartView = chartView
        marker?.titleLabelArray[0].text = "γ"
        marker?.titleLabelArray[1].text = "β"
        marker?.titleLabelArray[2].text = "α"
        marker?.titleLabelArray[3].text = "θ"
        marker?.titleLabelArray[4].text = "δ"
        for i in 0..<5 {
            marker?.dotArray[i].backgroundColor = spectrumColors[i]
        }
        let press = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
       
        chartView?.addGestureRecognizer(press)//添加长按事件
        chartView?.marker = marker
    }
    
    public func setDataFromModel(gama: [Float], delta: [Float], theta: [Float], alpha: [Float], beta: [Float], timestamp: Int? = nil) {
        
        if let timestamp = timestamp {
            timeStamp = timestamp
        }
        self.gamaArray = gama
        self.deltaArray = delta
        self.thetaArray = theta
        self.alphaArray = alpha
        self.betaArray = beta
        let brainwave = brainwaveMapping(gama, delta, theta, alpha, beta)
        setDataCount(brainwave)
        
    }
    
    func brainwaveMapping(_ gama: [Float], _ delta: [Float], _ theta: [Float], _ alpha: [Float], _ beta: [Float]) -> Array2D<Float> {
        let arrayCount = gama.count
        sample = arrayCount / maxDataCount == 0 ? 1 : arrayCount / maxDataCount
        var tmpArray = Array2D(columns: arrayCount, rows: 5, initialValue: Float(0.0))
        for i in 0..<arrayCount {
            let total = gama[i] + theta[i] + delta[i] + alpha[i] + beta[i]
            if total < 0.1 {
                let set1 = 0.1
                let set2 = 0.3
                let set3 = 0.6
                let set4 = 0.9
                tmpArray[i, 0] = 100
                tmpArray[i, 1] = Float(set4 * 100)
                tmpArray[i, 2] = Float(set3 * 100)
                tmpArray[i, 3] = Float(set2 * 100)
                tmpArray[i, 4] = Float(set1 * 100)
            } else {
                let set1 = delta[i] / total
                let set2 = (delta[i] + theta[i]) / total
                let set3 = (delta[i] + alpha[i] + theta[i]) / total
                let set4 = (total - gama[i]) / total
                tmpArray[i, 0] = 100
                tmpArray[i, 1] = set4 * 100
                tmpArray[i, 2] = set3 * 100
                tmpArray[i, 3] = set2 * 100
                tmpArray[i, 4] = set1 * 100
            }

        }
        
        return tmpArray
    }
    
    //MARK:- Chart Delegate
    public func setDataCount(_ waveArray: Array2D<Float>) {
        let yVals1 = setEntry(waveArray, 0)
        let yVals2 = setEntry(waveArray, 1)
        let yVals3 = setEntry(waveArray, 2)
        let yVals4 = setEntry(waveArray, 3)
        let yVals5 = setEntry(waveArray, 4)
        
        let set1 = setDataSet(yVals1, 0)
        let set2 = setDataSet(yVals2, 1)
        let set3 = setDataSet(yVals3, 2)
        let set4 = setDataSet(yVals4, 3)
        let set5 = setDataSet(yVals5, 4)
        
        let chartData = LineChartData(dataSets: [set1, set2, set3, set4, set5])
        chartData.setDrawValues(false)
        self.chartView?.data = chartData
        
        setLimitLine(yVals1.count)
        
    }
    
    private func setEntry(_ waveArray: Array2D<Float>, _ index: Int) -> [ChartDataEntry]{
        let count = waveArray.columns
        var yVals: [ChartDataEntry] = []
        for i in stride(from: 0, to: count, by: sample) {
            yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i, index])))
        }

        return yVals
    }
    
    
    //MARK:- Chart Delegate
    private func setDataSet(_ entry: [ChartDataEntry]?, _ index: Int) -> LineChartDataSet {
        var color = UIColor.clear
        switch index {
        case 0:
            color = spectrumColors[0]
        case 1:
            color = spectrumColors[1]
        case 2:
            color = spectrumColors[2]
        case 3:
            color = spectrumColors[3]
        default:
            color = spectrumColors[4]
        }
        let text = "DataSet \(index)"
        let set = LineChartDataSet.init(entries: entry, label: text)
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = true
        set.drawValuesEnabled = false
        set.drawIconsEnabled = true
        set.lineWidth = 1
        set.setColor(color)
        set.fillAlpha = 1
        set.fillColor = color
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = highlightLineColor
        set.drawHorizontalHighlightIndicatorEnabled = false

        set.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(self.chartView!.leftAxis.axisMinimum)
        }
        return set
    }

    private var time: [Int] = []
    private func setLimitLine(_ valueCount: Int) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60

        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            time.append(i)

        }

        chartView?.xAxis.axisMinimum = 0
        chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(100) //限制屏幕最少显示100个点
        chartView?.maxVisibleCount = valueCount * 5 + 1
        self.chartView?.xAxis.valueFormatter = DateValueFormatter(time, timeStamp)
        self.chartView?.leftAxis.valueFormatter = YValueFormatter()
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

            let chart = AffectiveChartBrainSpectrumView()
            nShowChartView.addSubview(chart)
            chart.chartHead?.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            chart.bgColor = self.bgColor
            chart.cornerRadius = self.cornerRadius
            chart.sample = self.sample
            chart.maxDataCount = 500
            chart.textColor = self.textColor
            chart.spectrumColors = self.spectrumColors
            chart.isChartScale = true
            chart.isHiddenNavigationBar = isHiddenNavigationBar
            chart.chartView?.highlightPerTapEnabled = false
            chart.chartView?.highlightPerDragEnabled = false
            chart.highlightLineColor = self.highlightLineColor
            chart.markerBackgroundColor = self.markerBackgroundColor
            chart.title = self.title
            chart.setDataFromModel(gama: gamaArray!, delta: deltaArray!, theta: thetaArray!, alpha: alphaArray!, beta: betaArray!, timestamp: timeStamp)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.isZoomed = true
            
            chart.betaDot?.snp.updateConstraints {
                $0.top.equalTo(chart.chartHead!.snp.bottom).offset(72)
            }
            chart.alphaDot?.snp.updateConstraints {
                $0.top.equalTo(chart.chartHead!.snp.bottom).offset(133)

            }
            chart.thetaDot?.snp.updateConstraints {
                $0.top.equalTo(chart.chartHead!.snp.bottom).offset(193)
            }
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
    //MARK: - 设置chart点击的代理
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        chartView.lastHighlighted = nil
        chartView.highlightValue(nil)
        chartHead?.isHidden = false
        
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[1].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[2].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[3].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[4].entryForIndex(i)?.icon = nil
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if !chartHead!.isHidden {
            chartHead?.isHidden = true
        }
        
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[1].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[2].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[3].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[4].entryForIndex(i)?.icon = nil
        }
        var index = chartView.data?.dataSets[0].entryIndex(entry: entry)
        if index == nil || index == -1 {
            index = chartView.data?.dataSets[1].entryIndex(entry: entry)
        }
        if index == nil || index == -1 {
            index = chartView.data?.dataSets[2].entryIndex(entry: entry)
        }
        if index == nil || index == -1 {
            index = chartView.data?.dataSets[3].entryIndex(entry: entry)
        }
        if index == nil || index == -1 {
            index = chartView.data?.dataSets[4].entryIndex(entry: entry)
        }
        
        if let index = index {
            chartView.data?.dataSets[0].entryForIndex(index)?.icon = gamaIcon
            chartView.data?.dataSets[1].entryForIndex(index)?.icon = betaIcon
            chartView.data?.dataSets[2].entryForIndex(index)?.icon = alphaIcon
            chartView.data?.dataSets[3].entryForIndex(index)?.icon = thetaIcon
            chartView.data?.dataSets[4].entryForIndex(index)?.icon = deltaIcon
        }
        
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[1].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[2].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[3].entryForIndex(i)?.icon = nil
            chartView.data?.dataSets[4].entryForIndex(i)?.icon = nil
        }
    }
    

}
