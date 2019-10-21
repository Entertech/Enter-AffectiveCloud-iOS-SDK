//
//  HeartRateVariablityReportView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/17.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SafariServices
import SnapKit

public class HeartRateVariablityReportView: BaseView, ChartViewDelegate  {

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
            infoBtn?.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    
    public var isShowInfoIcon: Bool = false {
        didSet {
            infoBtn?.isHidden = !self.isShowInfoIcon
        }
    }
    
    /// 按钮点击显示的网页
    public var infoUrlString = "https://www.notion.so/HRV-Graph-6f93225bf7934cb8a16eb6ba55da52cb"
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
            let changedColor = textColor.changeAlpha(to: 0.7)
            let secondColor = textColor.changeAlpha(to: 0.5)
            yLabel?.textColor = changedColor
            xLabel?.textColor = changedColor
            
            avgLabel?.textColor = changedColor
            msLabel?.textColor = secondColor
            chartView?.leftAxis.labelTextColor = changedColor
            chartView?.xAxis.labelTextColor = changedColor
            chartView?.xAxis.gridColor = secondColor
        }
    }
    
    public var lineColor: UIColor = UIColor.colorWithInt(r: 255, g: 72, b: 82, alpha: 1)
    
    //MARK:- Private UI
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.4
    private var timeStamp = 0
    
    //MARK:- Private UI
    private var bgView: UIView?
    private var titleLabel: UILabel?
    private var infoBtn: UIButton?
    private var chartView: LineChartView?
    private var yLabel: UILabel?
    private var xLabel: UILabel?
    private var avgLabel: UILabel?
    private var msLabel: UILabel?
    
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
        titleLabel?.text = "心率变异性"
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = mainColor
        bgView?.addSubview(titleLabel!)
        
        infoBtn = UIButton(type: .custom)
        infoBtn?.setImage(UIImage.init(named: "icon_info_black", in: Bundle.init(identifier: "cn.entertech.EnterAffectiveCloudUI"), with: .none), for: .normal)
        infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        bgView?.addSubview(infoBtn!)
        
        yLabel = UILabel.init()
        yLabel?.text = "HRV (ms)"
        yLabel?.font = UIFont.systemFont(ofSize: 12)
        yLabel?.textColor = alphaColor
        yLabel?.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        yLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*3/2))
        bgView?.addSubview(yLabel!)
        
        xLabel = UILabel()
        xLabel?.text = "时间(分钟)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = alphaColor
        bgView?.addSubview(xLabel!)
        
        chartView = LineChartView()
        chartView?.delegate = self
        chartView?.backgroundColor = .clear
        chartView?.gridBackgroundColor = .clear
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription?.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.setScaleEnabled(false)
        chartView?.legend.enabled = false
        chartView?.isUserInteractionEnabled = false
        
        let leftAxis = chartView!.leftAxis
        leftAxis.axisMaximum = 150
        leftAxis.axisMinimum = 0
        leftAxis.labelPosition = .insideChart
        leftAxis.labelTextColor = alphaColor
        leftAxis.drawGridLinesEnabled = false
        leftAxis.labelCount = 16
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.gridLineWidth = 0.3
        xAxis.labelPosition = .bottom
        xAxis.gridColor = secondColor
        xAxis.labelTextColor = alphaColor
        bgView?.addSubview(chartView!)
        
        avgLabel = UILabel()
        avgLabel?.font = UIFont.systemFont(ofSize: 14)
        avgLabel?.textColor = alphaColor
        bgView?.addSubview(avgLabel!)
        
        msLabel = UILabel()
        msLabel?.text = "ms"
        msLabel?.font = UIFont.systemFont(ofSize: 12)
        msLabel?.textColor = secondColor
        bgView?.addSubview(msLabel!)
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
            $0.top.equalToSuperview().offset(80)
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        chartView?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(135)
            $0.top.equalToSuperview().offset(56)
        }
        
        avgLabel?.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.right.equalTo(msLabel!.snp.left).offset(-5)
        }
        
        msLabel?.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
    func setDataFromModel(timestamp: Int?, hrv: [Int]?, hrvAvg: Int?) {
        
        if let timestamp = timestamp {
            timeStamp = timestamp
        }
        
        if let hrv = hrv {
            setDataCount(hrv)
        }
        
        if let hrvAvg = hrvAvg {
            avgLabel?.text = "平均：\(hrvAvg)"
        } else {
            avgLabel?.isHidden = true
            msLabel?.isHidden = true
        }
        
    }
    
    
    //MARK:- Chart delegate
    private func setDataCount(_ waveArray: [Int]) {
        var colors: [UIColor] = []
        var initValue = 0
        var initIndex = 0
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if waveArray[i] > 0 {
                initValue = waveArray[i]
                initIndex = i
                break
            }
        }

        var yVals: [ChartDataEntry] = []
        var notZero: Int = 0
        for i in stride(from: 0, to: waveArray.count, by: sample) {
            if i < initIndex{
                colors.append(#colorLiteral(red: 0.9, green: 0.90, blue: 0.90, alpha: 0.7))
                yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
            } else {
                if waveArray[i] == 0 {
                    colors.append(#colorLiteral(red: 0.9, green: 0.90, blue: 0.90, alpha: 0.7))
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                } else {
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
        chartView?.extraLeftOffset = 20
        chartView?.data = data
        setLimitLine(yVals.count)
        
    }
    
    private func setLimitLine(_ valueCount: Int) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        var time: [Int] = []
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            time.append(i)
        }
        
        if isAbsoluteTimeAxis {
            self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(time, timeStamp)
        } else {
            self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(time)
        }
        
        self.chartView?.leftAxis.valueFormatter = HRVValueFormatter()

        
    }
}

/// Y轴描述
public class HRVValueFormatter: NSObject, IAxisValueFormatter {
    private var labels: [Int : String] = [50: "50", 100: "100", 150: "150"];
    
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
public class HRVXValueFormatter: NSObject, IAxisValueFormatter {
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
