//
//  HeartRateReportView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/17.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SafariServices
import SnapKit

public class HeartRateReportView: BaseView, ChartViewDelegate {
    
    /// MARK:- Public param
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
            infoBtn?.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    
    public var isShowInfoIcon: Bool = false {
        didSet {
            infoBtn?.isHidden = !self.isShowInfoIcon
        }
    }
    
    /// 按钮点击显示的网页
    public var infoUrlString = "https://www.notion.so/Heart-Rate-Graph-fa83da8528694fd1a265882db31d3778"
    /// 采样
    public var sample: Int = 3
    
    /// 是否将时间坐标轴转化为对应时间
    public var isAbsoluteTimeAxis: Bool = false {
        didSet {
            if self.isAbsoluteTimeAxis {
                xLabel?.isHidden = true
            }
        }
    }
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithInt(r: 23, g: 23, b: 38, alpha: 0.7) {
        didSet  {
            let firstColor = textColor.changeAlpha(to: 0.7)
            let secondColor = textColor.changeAlpha(to: 0.5)
            lowLabel?.textColor = firstColor
            middleLabel?.textColor = firstColor
            highLabel?.textColor = firstColor
            yLabel?.textColor = firstColor
            xLabel?.textColor = firstColor
            avgLabel?.textColor = firstColor
            maxLabel?.textColor = firstColor
            minLabel?.textColor = firstColor
            avgBpmLabel?.textColor = secondColor
            minBpmLabel?.textColor = secondColor
            maxBpmLabel?.textColor = secondColor
            
            topChart?.leftAxis.labelTextColor = firstColor
            topChart?.xAxis.labelTextColor = firstColor
            topChart?.xAxis.gridColor = secondColor
        }
    }
    
    /// 3层心率的颜色
    public var heartRateLineColors: [UIColor] = [UIColor.colorWithInt(r: 0, g: 217, b: 147, alpha: 1),
                                            UIColor.colorWithInt(r: 255, g: 194, b: 0, alpha: 1),
                                            UIColor.colorWithInt(r: 255, g: 72, b: 82, alpha: 1)] {
        didSet {
            guard heartRateLineColors.count == 3 else {
                print("WARNING: The array 'heartRateLineColors' needs 3 params")
                return
            }
            lowDot?.backgroundColor = heartRateLineColors[0]
            middleDot?.backgroundColor = heartRateLineColors[1]
            highDot?.backgroundColor = heartRateLineColors[2]
        }
    }
    
    public var isShowAvg: Bool = true {
        didSet {
            avgBpmLabel?.isHidden = !isShowAvg
            avgLabel?.isHidden = !isShowAvg
        }
    }
    
    public var isShowMax: Bool = true {
        didSet {
            maxLabel?.isHidden = !self.isShowMax
            avgBpmLabel?.isHidden = !self.isShowMax
        }
    }
    
    public var isShowMin: Bool = true {
        didSet {
            minLabel?.isHidden = !self.isShowMin
            minBpmLabel?.isHidden = !self.isShowMin
        }
    }
    
    //MARK:- Private UI
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.4
    private var timeStamp = 0
    
    //MARK:- Private UI
    private var bgView: UIView?
    private var titleLabel: UILabel?
    private var infoBtn: UIButton?
    private var chartView: LineChartView?
    private var topChart: LineChartView?
    private var yLabel: UILabel?
    private var xLabel: UILabel?
    private var lowDot: UIView?
    private var lowLabel: UILabel?
    private var middleDot: UIView?
    private var middleLabel: UILabel?
    private var highDot: UIView?
    private var highLabel: UILabel?
    var avgLabel: UILabel?
    private var avgBpmLabel: UILabel?
    var maxLabel: UILabel?
    private var maxBpmLabel: UILabel?
    var minLabel: UILabel?
    private var minBpmLabel: UILabel?
    private var chartBackgroundView: UIView?
    
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
        let firstTextColor = textColor.changeAlpha(to: 0.7)
        let secondTextColor = textColor.changeAlpha(to: 0.5)
        
        bgView = UIView()
        bgView?.backgroundColor = bgColor
        bgView?.layer.cornerRadius = cornerRadius
        bgView?.layer.masksToBounds = true
        self.addSubview(bgView!)
        
        chartBackgroundView = UIView()
        chartBackgroundView?.backgroundColor  = .clear
        bgView?.addSubview(chartBackgroundView!)
        
        titleLabel = UILabel()
        titleLabel?.text = "心率"
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = mainColor
        bgView?.addSubview(titleLabel!)
        
        infoBtn = UIButton(type: .custom)
        infoBtn?.setImage(UIImage.init(named: "icon_info_black", in: Bundle.init(identifier: "cn.entertech.EnterAffectiveCloudUI"), compatibleWith: nil), for: .normal)
        infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        bgView?.addSubview(infoBtn!)
        
        yLabel = UILabel.init()
        yLabel?.text = "心率(bpm)"
        yLabel?.font = UIFont.systemFont(ofSize: 12)
        yLabel?.textColor = firstTextColor
        yLabel?.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        yLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*3/2))
        bgView?.addSubview(yLabel!)
        
        xLabel = UILabel()
        xLabel?.text = "时间(分钟)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = firstTextColor
        bgView?.addSubview(xLabel!)
        
        //负责彩色
        chartView = LineChartView()
        chartView?.backgroundColor = .clear
        chartView?.gridBackgroundColor = .clear
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription?.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.isUserInteractionEnabled = false
        chartView?.setScaleEnabled(false)
        chartView?.legend.enabled = false

        let leftAxis = chartView!.leftAxis
        leftAxis.axisMaximum = 120
        leftAxis.axisMinimum = 30
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisLineWidth = 3.0
        leftAxis.drawLabelsEnabled = false
        chartView?.rightAxis.enabled = false

        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.labelTextColor = .clear
        xAxis.labelPosition = .bottom
        chartBackgroundView?.addSubview(chartView!)
        
        topChart = LineChartView()
        topChart?.backgroundColor = .clear
        topChart?.gridBackgroundColor = .clear
        topChart?.drawBordersEnabled = false
        topChart?.chartDescription?.enabled = false
        topChart?.pinchZoomEnabled = false
        topChart?.isUserInteractionEnabled = false
        topChart?.legend.enabled = false
        
        let leftAxisTop = topChart!.leftAxis
        leftAxisTop.axisMaximum = 120
        leftAxisTop.axisMinimum = 30
        leftAxisTop.axisLineColor = .clear
        leftAxisTop.labelCount = 11
        leftAxisTop.drawGridLinesEnabled = false
        leftAxisTop.labelPosition = .insideChart
        leftAxisTop.labelTextColor = firstTextColor
        topChart?.rightAxis.enabled = false
        
        let xAxisTop = topChart!.xAxis
        xAxisTop.drawAxisLineEnabled = false
        xAxisTop.gridLineWidth = 0.3
        xAxisTop.gridColor = secondTextColor
        xAxisTop.labelPosition = .bottom
        xAxisTop.labelTextColor = firstTextColor
        chartBackgroundView?.addSubview(topChart!)
        
        lowDot = UIView()
        lowDot?.layer.cornerRadius = 4
        lowDot?.layer.masksToBounds = true
        lowDot?.backgroundColor = heartRateLineColors[0]
        bgView?.addSubview(lowDot!)
        
        middleDot = UIView()
        middleDot?.layer.cornerRadius = 4
        middleDot?.layer.masksToBounds = true
        middleDot?.backgroundColor = heartRateLineColors[1]
        bgView?.addSubview(middleDot!)
        
        highDot = UIView()
        highDot?.layer.cornerRadius = 4
        highDot?.layer.masksToBounds = true
        highDot?.backgroundColor = heartRateLineColors[2]
        bgView?.addSubview(highDot!)
        
        lowLabel = UILabel()
        lowLabel?.text = "低"
        lowLabel?.font = UIFont.systemFont(ofSize: 12)
        lowLabel?.textColor = firstTextColor
        bgView?.addSubview(lowLabel!)
        
        middleLabel = UILabel()
        middleLabel?.text = "中"
        middleLabel?.font = UIFont.systemFont(ofSize: 12)
        middleLabel?.textColor = firstTextColor
        bgView?.addSubview(middleLabel!)
        
        highLabel = UILabel()
        highLabel?.text = "高"
        highLabel?.font = UIFont.systemFont(ofSize: 12)
        highLabel?.textColor = firstTextColor
        bgView?.addSubview(highLabel!)
        
        avgLabel = UILabel()
        avgLabel?.font = UIFont.systemFont(ofSize: 14)
        avgLabel?.textColor = firstTextColor
        bgView?.addSubview(avgLabel!)
        
        avgBpmLabel = UILabel()
        avgBpmLabel?.font = UIFont.systemFont(ofSize: 12)
        avgBpmLabel?.text = "bpm"
        avgBpmLabel?.textColor = secondTextColor
        bgView?.addSubview(avgBpmLabel!)
        
        maxLabel = UILabel()
        maxLabel?.font = UIFont.systemFont(ofSize: 14)
        maxLabel?.textColor = firstTextColor
        bgView?.addSubview(maxLabel!)
        
        maxBpmLabel = UILabel()
        maxBpmLabel?.font = UIFont.systemFont(ofSize: 12)
        maxBpmLabel?.text = "bpm"
        maxBpmLabel?.textColor = secondTextColor
        bgView?.addSubview(maxBpmLabel!)
        
        minLabel = UILabel()
        minLabel?.font = UIFont.systemFont(ofSize: 14)
        minLabel?.textColor = firstTextColor
        bgView?.addSubview(minLabel!)
        
        minBpmLabel = UILabel()
        minBpmLabel?.font = UIFont.systemFont(ofSize: 12)
        minBpmLabel?.text = "bpm"
        minBpmLabel?.textColor = secondTextColor
        bgView?.addSubview(minBpmLabel!)
        
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
        
        yLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview().multipliedBy(0.11)
            $0.top.equalToSuperview().offset(100)
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-47)
        }
        
        chartBackgroundView?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(140)
            $0.top.equalToSuperview().offset(80)
        }
        
        chartView?.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.left.top.equalToSuperview()
        }
        
        topChart?.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.left.top.equalToSuperview()
        }
        
        highLabel?.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(infoBtn!.snp.bottom).offset(16)
        }
        
        highDot?.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.right.equalTo(highLabel!.snp.left).offset(-4)
            $0.centerY.equalTo(highLabel!.snp.centerY)
        }
        
        middleLabel?.snp.makeConstraints {
            $0.right.equalTo(highDot!.snp.left).offset(-24)
            $0.top.equalTo(infoBtn!.snp.bottom).offset(16)
        }
        
        middleDot?.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.right.equalTo(middleLabel!.snp.left).offset(-4)
            $0.centerY.equalTo(highLabel!.snp.centerY)
        }
        
        lowLabel?.snp.makeConstraints {
            $0.right.equalTo(middleDot!.snp.left).offset(-24)
            $0.top.equalTo(infoBtn!.snp.bottom).offset(16)
        }
        
        lowDot?.snp.makeConstraints {
            $0.width.height.equalTo(8)
            $0.right.equalTo(lowLabel!.snp.left).offset(-4)
            $0.centerY.equalTo(highLabel!.snp.centerY)
        }
        
        avgLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        avgBpmLabel?.snp.makeConstraints {
            $0.left.equalTo(avgLabel!.snp.right).offset(4)
            $0.bottom.equalToSuperview().offset(-17)
        }
        
        maxLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        maxBpmLabel?.snp.makeConstraints {
            $0.left.equalTo(maxLabel!.snp.right).offset(4)
            $0.bottom.equalToSuperview().offset(-17)
        }
        
        minLabel?.snp.makeConstraints {
            $0.right.equalTo(minBpmLabel!.snp.left).offset(-4)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        minBpmLabel?.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-17)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
    func setDataFromModel(timestamp: Int?, hr: [Int]?, hrAvg: Int?, hrMin: Int?, hrMax: Int?) {

        if let timestamp = timestamp {
            timeStamp = timestamp
        }
        
        if let hr = hr {
            setDataCount(hr)
        }
        
        if let hrAvg = hrAvg {
            avgLabel?.text = "平均：\(hrAvg)"
        } else {
            avgLabel?.isHidden = true
            avgBpmLabel?.isHidden = true
        }
        
        if let hrMin = hrMin {
            minLabel?.text = "最小：\(hrMin)"
        } else {
            minLabel?.isHidden = true
            minBpmLabel?.isHidden = true
        }
        
        if let hrMax = hrMax {
            maxLabel?.text = "最大：\(hrMax)"
        } else {
            maxLabel?.isHidden = true
            maxBpmLabel?.isHidden = true
        }
        
    }
    
    
    //MARK:- Chart Delegate
    private func setDataCount(_ waveArray: [Int]) {
        var initValue = 0
        var initIndex = 0
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if waveArray[i] > 30 {
                initValue = waveArray[i]
                initIndex = i
                break
            }
        }
        var yVals: [ChartDataEntry] = []
        var yTop: [ChartDataEntry] = []
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if i <= initIndex {
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
                yTop.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            }
            if i > initIndex{
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i])))
                yTop.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i])))
            }
            
        }
        
        let set = LineChartDataSet(entries: yVals, label: "")
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.drawIconsEnabled = false
        set.drawValuesEnabled = false
        set.lineWidth = 2
        
        let data = LineChartData(dataSet: set)
        chartView?.data = data
        
        let set1 = LineChartDataSet(entries: yTop, label: "")
        set.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.drawFilledEnabled = false
        set1.drawIconsEnabled = false
        set1.drawValuesEnabled = false
        set1.lineWidth = 1
        set1.setColor(.clear)
        let data1 = LineChartData(dataSet: set1)
        chartView?.extraLeftOffset = 20
        topChart?.extraLeftOffset = 20
        topChart?.data = data1
        setLimitLine(yVals.count)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = chartView!.bounds
        if gradientLayer.frame.height == 0 {
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 380, height: 140)
        }
        gradientLayer.colors = [heartRateLineColors[2].cgColor,
                               heartRateLineColors[1].cgColor,
                               heartRateLineColors[1].cgColor,
                               heartRateLineColors[0].cgColor]
        gradientLayer.locations = [0.34, 0.35, 0.60, 0.61]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x:0, y:1)
        chartBackgroundView?.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.mask = chartView!.layer
    }
    
    private func setLimitLine(_ valueCount: Int) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        var time: [Int] = []
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            time.append(i)
        }
        
        if isAbsoluteTimeAxis {
            self.topChart?.xAxis.valueFormatter = HeartValueFormatter(time, timeStamp)
        } else {
            self.topChart?.xAxis.valueFormatter = HeartValueFormatter(time)
        }
        
        self.topChart?.leftAxis.valueFormatter = HRValueFormatter()
        
    }
    

}

/// Y轴描述
public class HRValueFormatter: NSObject, IAxisValueFormatter {
    private var labels: [Int : String] = [60: "60", 90: "90"];
    
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
public class HeartValueFormatter: NSObject, IAxisValueFormatter {
    private var values: [Double] = [];
    private var timestamp: Int = 0
    private let dateFormatter = DateFormatter()
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
        
        dateFormatter.dateFormat = "HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if timestamp == 0 {
            var date = ""
            axis?.entries = self.values
            date = "\(Int(value / 60))"
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
