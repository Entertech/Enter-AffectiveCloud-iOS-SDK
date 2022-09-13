//
//  AttentionReportView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/17.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SafariServices
import SnapKit

public class AttentionReportView: BaseView, ChartViewDelegate{

    //MARK:- Public param
    /// 标题等主色
    public var mainColor: UIColor = UIColor.colorWithHexString(hexColor: "0064ff") {
        didSet  {
            titleLabel?.textColor = mainColor
        }
    }
    /// 背景颜色
    public var bgColor: UIColor = .white {
        didSet {
            bgView?.backgroundColor = bgColor
        }
    }
    /// 圆角
    public var cornerRadius: CGFloat = 8 {
        didSet {
            bgView?.layer.cornerRadius = cornerRadius
            bgView?.layer.masksToBounds = true
        }
    }
    
    /// 按钮图片
    public var buttonImageName: String = "" {
        didSet {
            if buttonImageName != "" {
                infoBtn?.setImage(UIImage(named: buttonImageName), for: .normal)
            }
        }
    }
    
    public var isShowInfoIcon: Bool = true {
        didSet {
            infoBtn?.isHidden = !self.isShowInfoIcon
        }
    }
    
    /// 按钮点击显示的网页
    public var infoUrlString = "https://www.notion.so/Attention-Graph-8f9fa5017ba74a34866c1977a323960a"
    /// 采样
    public var sample: Int = 3
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithInt(r: 23, g: 23, b: 38, alpha: 0.7) {
        didSet  {
            let changedColor = textColor.changeAlpha(to: 0.7)
            let secondColor = textColor.changeAlpha(to: 0.5)
            yLabel?.textColor = changedColor
            xLabel?.textColor = changedColor
            avgLabel?.textColor = changedColor
            minLabel?.textColor = changedColor
            maxLabel?.textColor = changedColor
            chartView?.xAxis.labelTextColor = changedColor
            chartView?.leftAxis.labelTextColor = changedColor
            chartView?.xAxis.gridColor = secondColor
        }
    }
    
    public var maxValue: Int = 0 {
        didSet {
            maxLabel?.text = "Max: \(maxValue)"
            
        }
    }
    
    public var minValue: Int = 0 {
        didSet {
            minLabel?.text = "Min: \(minValue)"
        }
    }
    
    public var avgValue: Int = 0 {
        didSet {
            avgLabel?.text = "Avg: \(avgValue)"
        }
    }

    
    /// 线段和填充的颜色
    public var fillColor: UIColor = UIColor.colorWithInt(r: 0, g: 217, b: 147, alpha: 1)
    
    public var isChartScale = false {
        willSet {
            chartView?.scaleXEnabled = newValue
            zoomBtn?.isHidden = !newValue
        }
    }
    
    //MARK:- Private UI
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.8
    private var timeStamp = 0
    private var attentionArray: [Int]?
    //MARK:- Private UI
    private var bgView: UIView?
    private var titleLabel: UILabel?
    private var infoBtn: UIButton?
    private var chartView: LineChartView?
    private var yLabel: UILabel?
    private var xLabel: UILabel?
    private var avgLabel: UILabel?
    private var maxLabel: UILabel?
    private var minLabel: UILabel?
    private var zoomBtn: UIButton?
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setUI() {
        self.backgroundColor = .clear
        let alphaColor = textColor.changeAlpha(to: 0.7)
        let secondColor = textColor.changeAlpha(to: 0.5)
        
        bgView = UIView()
        bgView?.backgroundColor = bgColor
        bgView?.layer.cornerRadius = cornerRadius
        bgView?.layer.masksToBounds = true
        self.addSubview(bgView!)
        
        titleLabel = UILabel()
        titleLabel?.text = "Attention"
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = mainColor
        bgView?.addSubview(titleLabel!)
        
        infoBtn = UIButton(type: .custom)
        infoBtn?.setImage(UIImage.loadImage(name: "icon_info_black", any: classForCoder), for: .normal)
        infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        bgView?.addSubview(infoBtn!)
        
        yLabel = UILabel.init()
        yLabel?.text = "Attention"
        yLabel?.font = UIFont.systemFont(ofSize: 12)
        yLabel?.textColor = alphaColor
        yLabel?.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        yLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*3/2))
        bgView?.addSubview(yLabel!)
        
        xLabel = UILabel()
        xLabel?.text = "Time(min)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = alphaColor
        bgView?.addSubview(xLabel!)
        
        chartView = LineChartView()
        chartView?.delegate = self
        chartView?.backgroundColor = .clear
        chartView?.gridBackgroundColor = .white
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.scaleXEnabled = false
        chartView?.scaleYEnabled = false
        chartView?.legend.enabled = false
        chartView?.highlightPerTapEnabled = false
        
        let leftAxis = chartView!.leftAxis
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        leftAxis.labelCount = 11
        leftAxis.labelPosition = .insideChart
        leftAxis.labelTextColor = alphaColor
        
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.gridLineWidth = 0.3
        xAxis.labelPosition = .bottom
        xAxis.gridColor = secondColor
        xAxis.labelTextColor = alphaColor
        xAxis.axisMaxLabels = 8
        bgView?.addSubview(chartView!)
        
        avgLabel = UILabel()
        avgLabel?.font = UIFont.systemFont(ofSize: 14)
        avgLabel?.textColor = alphaColor
        bgView?.addSubview(avgLabel!)
        
        maxLabel = UILabel()
        maxLabel?.font = UIFont.systemFont(ofSize: 14)
        maxLabel?.textColor = alphaColor
        bgView?.addSubview(maxLabel!)
        
        minLabel = UILabel()
        minLabel?.font = UIFont.systemFont(ofSize: 14)
        minLabel?.textColor = alphaColor
        bgView?.addSubview(minLabel!)
        
        zoomBtn = UIButton(type: .custom)
        zoomBtn?.setImage(UIImage.loadImage(name: "icon_info_black", any: classForCoder), for: .normal)
        zoomBtn?.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        zoomBtn?.isHidden = true
        bgView?.addSubview(zoomBtn!)
    }
    
    override func setLayout() {
        bgView?.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        titleLabel?.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(16)
        }
        
        infoBtn?.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel!.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
        }
        
        zoomBtn?.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel!.snp.centerY)
            $0.right.equalToSuperview().offset(-60)
        }
        
        yLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview().multipliedBy(0.11)
            $0.top.equalToSuperview().offset(80)
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        chartView?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(180)
            $0.top.equalToSuperview().offset(56)
        }
        
        avgLabel?.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.left.equalToSuperview().offset(16)
        }
        
        maxLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        minLabel?.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
    private var isZoomed = false
    @objc
    private func zoomBtnTouchUpInside(sender: UIButton) {
        if !isZoomed {
            let vc = self.parentViewController()!
            vc.navigationController?.setNavigationBarHidden(true, animated: true)
            let view = vc.view
            let nShowChartView = UIView()
            nShowChartView.backgroundColor = .white
            view?.addSubview(nShowChartView)
            
            
            let chart = self.copyView() as! AttentionReportView
            nShowChartView.addSubview(chart)
            chart.mainColor = self.mainColor
            chart.bgColor = self.bgColor
            chart.cornerRadius = self.cornerRadius
            chart.buttonImageName = self.buttonImageName
            chart.isShowInfoIcon = self.isShowInfoIcon
            chart.infoUrlString = self.infoUrlString
            chart.sample = self.sample
            chart.textColor = self.textColor
            chart.avgValue = self.avgValue
            chart.fillColor = self.fillColor
            chart.isChartScale = self.isChartScale
            chart.setDataFromModel(attention: attentionArray, timestamp: timeStamp)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*3/2))
            chart.avgValue = self.avgValue
            chart.minValue = self.minValue
            chart.maxValue = self.maxValue
            chart.isZoomed = true
            
            nShowChartView.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(view!.safeAreaLayoutGuide)
            }
            
            chart.snp.remakeConstraints {
                $0.width.equalTo(nShowChartView.snp.height)
                $0.height.equalTo(nShowChartView.snp.width)
                $0.center.equalToSuperview()
            }
            
            chart.infoBtn?.snp.remakeConstraints {
                $0.centerY.equalTo(chart.titleLabel!.snp.centerY)
                $0.right.equalToSuperview().offset(-32)
            }
            
            chart.zoomBtn?.snp.remakeConstraints {
                $0.centerY.equalTo(chart.titleLabel!.snp.centerY)
                $0.right.equalToSuperview().offset(-80)
            }
            
            chart.titleLabel?.snp.remakeConstraints{
                $0.left.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset(36)
            }
            
            chart.chartView?.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(36)
                $0.right.equalToSuperview().offset(-36)
                $0.top.equalToSuperview().offset(80)
                $0.bottom.equalToSuperview().offset(-80)
            }
            
            chart.yLabel?.snp.remakeConstraints {
                $0.centerX.equalToSuperview().multipliedBy(0.1)
                $0.centerY.equalToSuperview().multipliedBy(0.9)
            }
            
            chart.xLabel?.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-50)
            }
            
            chart.avgLabel?.snp.remakeConstraints {
                $0.bottom.equalToSuperview().offset(-24)
                $0.left.equalToSuperview().offset(32)
            }
            
            chart.maxLabel?.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-24)
            }
            
            chart.minLabel?.snp.remakeConstraints {
                $0.right.equalToSuperview().offset(-40)
                $0.bottom.equalToSuperview().offset(-24)
            }
            

            
        } else {
            isZoomed = false
            self.superview?.removeFromSuperview()
        }
        
    }
    
    public func setDataFromModel(attention: [Int]?, timestamp: Int? = nil) {

        if let timestamp = timestamp {
            timeStamp = timestamp
            xLabel?.isHidden = true
        }
        
        if let hr = attention {
            self.attentionArray = hr
            setDataCount(hr)
        }

        
    }
    
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
        var uselessVals: [ChartDataEntry] = []
        for i in stride(from: 0, to: initIndex+1, by: sample) {
            uselessVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
        }
        var yVals: [ChartDataEntry] = []
        for i in stride(from: initIndex, to: waveArray.count, by: sample) {
            
            yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i])))
            
        }
        var red:CGFloat   = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat  = 0.0
        var alpha:CGFloat = 0.0
        fillColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
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
        set.drawValuesEnabled = false
        set.lineWidth = 0.5
        set.setColor(.clear)
        set.fill = LinearGradientFill(gradient: chartFillColor!, angle: 270)
        
        set.fillAlpha = 1.0
        
        let uselessSet = LineChartDataSet(entries: uselessVals, label: "")
        uselessSet.drawCirclesEnabled = false
        uselessSet.drawCircleHoleEnabled = false
        uselessSet.drawFilledEnabled = true
        uselessSet.drawValuesEnabled = false
        uselessSet.lineWidth = 0.5
        uselessSet.setColor(.clear)
        let whiteComponents:[CGFloat] = [ 245.0/255.0, 244.0/255.0, 245.0/255.0, 0.7,
                                     ]
        let whiteColorSpace = CGColorSpaceCreateDeviceRGB()
        let whiteLocations:[CGFloat] = [1.0]
        let grayColor = CGGradient(colorSpace: whiteColorSpace, colorComponents: whiteComponents, locations: whiteLocations, count: 1)
        uselessSet.fill = LinearGradientFill(gradient: grayColor!, angle: 270)
        uselessSet.fillAlpha = 1.0
        
        let data = LineChartData(dataSets: [uselessSet, set])
        chartView?.extraLeftOffset = 20
        chartView?.data = data
        setLimitLine(yVals.count+uselessVals.count)
        
    }
    
    private var time: [Int] = []
    private func setLimitLine(_ valueCount: Int) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60

        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            time.append(i)
        }
        // chartView?.xAxis.axisMinimum = 0
        // chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(20) //限制屏幕最少显示100个点

        self.chartView?.xAxis.valueFormatter = OtherXValueFormatter(time, timeStamp)
        self.chartView?.leftAxis.valueFormatter = OtherValueFormatter()
        
    }
    
    private var isScaled = false
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        let lineChart = chartView as! LineChartView
        if lineChart.scaleX > 1.1{
            if !isScaled {
                self.chartView?.xAxis.valueFormatter = OtherXValueFormatter(timeStamp, true)
                isScaled = true
                
            }
        } else {
            if isScaled {
                self.chartView?.xAxis.valueFormatter = OtherXValueFormatter(time, timeStamp)
                isScaled = false
            }
        }
    }
}

/// Y轴描述
public class OtherValueFormatter: NSObject, AxisValueFormatter {
    private var labels: [Int : String] = [25: "25", 50: "50", 75: "75", 100: "100"];
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - timeStamps: 列表
    public override init() {
        super.init()
        
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = labels[Int((value).rounded())] ?? ""
        
        
        return date
    }
}

/// X轴描述
public class OtherXValueFormatter: NSObject, AxisValueFormatter {
    private var values: [Double] = [];
    private var timestamp: Int = 0
    private let dateFormatter = DateFormatter()
    private var isScaled = false
    /// 初始化
    ///
    /// - Parameters:
    ///   - timeStamps: 时间列表
    public init(_ time:[Int], _ timestamp: Int = 0) {
        super.init()
        
        for e in time {
            values.append(Double(e))
        }
        
        self.timestamp = timestamp
        isScaled = false
        dateFormatter.dateFormat = "HH:mm"
    }
        
    public init(_ timestamp: Int = 0, _ isScaled: Bool = false) {
        self.isScaled = isScaled
        self.timestamp = timestamp
               
        dateFormatter.dateFormat = "HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if timestamp == 0 {
            var date = ""
            if isScaled {
                date = String(format: "%0.1lf", value / 60.0)
            } else {
                axis?.entries = self.values
                date = "\(Int(value / 60))"
            }
            return date
        } else {
            var time = 0
            axis?.entries = self.values
            time = Int(value) + timestamp
            let date = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
            return date
        }
    }
}
