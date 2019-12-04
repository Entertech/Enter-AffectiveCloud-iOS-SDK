//
//  BrainSpecturmReport.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/15.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SafariServices
import SnapKit

public class BrainSpecturmReportView: BaseView, ChartViewDelegate {
    
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
    public var infoUrlString = "https://www.notion.so/Brainwave-Power-Graph-6f2a784b347d4d7d98b9fd0da89de454"
    /// 采样
    public var sample: Int = 3
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithInt(r: 23, g: 23, b: 38, alpha: 0.7) {
        didSet  {
            let changedColor = textColor.changeAlpha(to: 0.7)
            yLabel?.textColor = changedColor
            xLabel?.textColor = changedColor
            gamaLabel?.textColor = changedColor
            betaLabel?.textColor = changedColor
            alphaLabel?.textColor = changedColor
            thetaLabel?.textColor = changedColor
            deltaLabel?.textColor = changedColor
            chartView?.xAxis.labelTextColor = changedColor
        }
    }
    
    /// 5段脑波频谱的颜色
    public var spectrumColors: [UIColor] = [UIColor.colorWithInt(r: 9, g: 33, b: 221, alpha: 1),
                                            UIColor.colorWithInt(r: 81, g: 103, b: 248, alpha: 1),
                                            UIColor.colorWithInt(r: 133, g: 138, b: 255, alpha: 1),
                                            UIColor.colorWithInt(r: 191, g: 173, b: 255, alpha: 1),
                                            UIColor.colorWithInt(r: 246, g: 230, b: 255, alpha: 1)] {
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
            
            chartView?.gridBackgroundColor = spectrumColors[4]
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
    private var yLabel: UILabel?
    private var xLabel: UILabel?
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
        
        bgView = UIView()
        bgView?.backgroundColor = bgColor
        bgView?.layer.cornerRadius = cornerRadius
        bgView?.layer.masksToBounds = true
        self.addSubview(bgView!)
        
        titleLabel = UILabel()
        titleLabel?.text = "脑电波频谱"
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = mainColor
        bgView?.addSubview(titleLabel!)
        
        infoBtn = UIButton(type: .custom)
        infoBtn?.setImage(UIImage.loadImage(name: "icon_info_black", any: classForCoder), for: .normal)
        infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        bgView?.addSubview(infoBtn!)
        
        yLabel = UILabel.init()
        yLabel?.text = "各个频段脑电波占比 (%)"
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
        chartView?.gridBackgroundColor = spectrumColors[4]
        chartView?.drawGridBackgroundEnabled = true
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription?.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.isUserInteractionEnabled = false
        chartView?.setScaleEnabled(false)
        chartView?.legend.enabled = false
        bgView?.addSubview(chartView!)
        
        let leftAxis = chartView!.leftAxis
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawGridLinesEnabled = false
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = alphaColor
        
        gamaDot = UIView()
        gamaDot?.backgroundColor = spectrumColors[0]
        gamaDot?.layer.cornerRadius = 4
        gamaDot?.layer.masksToBounds = true
        bgView?.addSubview(gamaDot!)
        
        betaDot = UIView()
        betaDot?.backgroundColor = spectrumColors[1]
        betaDot?.layer.cornerRadius = 4
        betaDot?.layer.masksToBounds = true
        bgView?.addSubview(betaDot!)
        
        alphaDot = UIView()
        alphaDot?.backgroundColor = spectrumColors[2]
        alphaDot?.layer.cornerRadius = 4
        alphaDot?.layer.masksToBounds = true
        bgView?.addSubview(alphaDot!)
        
        thetaDot = UIView()
        thetaDot?.backgroundColor = spectrumColors[3]
        thetaDot?.layer.cornerRadius = 4
        thetaDot?.layer.masksToBounds = true
        bgView?.addSubview(thetaDot!)
        
        deltaDot = UIView()
        deltaDot?.backgroundColor = spectrumColors[4]
        deltaDot?.layer.cornerRadius = 4
        deltaDot?.layer.masksToBounds = true
        bgView?.addSubview(deltaDot!)
        
        gamaLabel = UILabel()
        gamaLabel?.text = "γ 波"
        gamaLabel?.textColor = alphaColor
        gamaLabel?.textAlignment = .left
        gamaLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView?.addSubview(gamaLabel!)
        
        betaLabel = UILabel()
        betaLabel?.text = "β 波"
        betaLabel?.textColor = alphaColor
        betaLabel?.textAlignment = .left
        betaLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView?.addSubview(betaLabel!)
        
        alphaLabel = UILabel()
        alphaLabel?.text = "α 波"
        alphaLabel?.textColor = alphaColor
        alphaLabel?.textAlignment = .left
        alphaLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView?.addSubview(alphaLabel!)
        
        thetaLabel = UILabel()
        thetaLabel?.text = "θ 波"
        thetaLabel?.textColor = alphaColor
        thetaLabel?.textAlignment = .left
        thetaLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView?.addSubview(thetaLabel!)
        
        deltaLabel = UILabel()
        deltaLabel?.text = "δ 波"
        deltaLabel?.textColor = alphaColor
        deltaLabel?.textAlignment = .left
        deltaLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView?.addSubview(deltaLabel!)
        
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
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        chartView?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(184)
            $0.top.equalToSuperview().offset(80)
        }
        
        gamaDot?.snp.makeConstraints {
            $0.right.equalTo(gamaLabel!.snp.left).offset(-4)
            $0.height.width.equalTo(8)
            $0.top.equalToSuperview().offset(62)
        }
        
        gamaLabel?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalTo(betaDot!.snp.left).offset(-35)
        }
        
        betaDot?.snp.makeConstraints {
            $0.right.equalTo(betaLabel!.snp.left).offset(-4)
            $0.height.width.equalTo(8)
            $0.top.equalToSuperview().offset(62)
        }
        
        betaLabel?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalTo(alphaDot!.snp.left).offset(-35)
        }
        
        alphaDot?.snp.makeConstraints {
            $0.right.equalTo(alphaLabel!.snp.left).offset(-4)
            $0.height.width.equalTo(8)
            $0.top.equalToSuperview().offset(62)
        }
        alphaLabel?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalTo(thetaDot!.snp.left).offset(-35)
        }
        
        thetaDot?.snp.makeConstraints {
            $0.right.equalTo(thetaLabel!.snp.left).offset(-4)
            $0.height.width.equalTo(8)
            $0.top.equalToSuperview().offset(62)
        }
        thetaLabel?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalTo(deltaDot!.snp.left).offset(-35)
        }
        
        deltaDot?.snp.makeConstraints {
            $0.right.equalTo(deltaLabel!.snp.left).offset(-4)
            $0.height.width.equalTo(8)
            $0.top.equalToSuperview().offset(62)
        }
        deltaLabel?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-30)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
    public func setDataFromModel(gama: [Float], delta: [Float], theta: [Float], alpha: [Float], beta: [Float], timestamp: Int? = nil) {
        
        if let timestamp = timestamp {
            timeStamp = timestamp
            xLabel?.isHidden = true
        }
        
        let brainwave = brainwaveMapping(gama, delta, theta, alpha, beta)
        setDataCount(brainwave)
        
    }
    
    func brainwaveMapping(_ gama: [Float], _ delta: [Float], _ theta: [Float], _ alpha: [Float], _ beta: [Float]) -> Array2D<Float> {
        let arrayCount = gama.count
        var tmpArray = Array2D(columns: arrayCount, rows: 4, initialValue: Float(0.0))
        for i in 0..<arrayCount {
            let total = gama[i] + theta[i] + delta[i] + alpha[i] + beta[i]
            let set1 = delta[i] / total
            let set2 = (delta[i] + theta[i]) / total
            let set3 = (delta[i] + alpha[i] + theta[i]) / total
            let set4 = (total - gama[i]) / total
            tmpArray[i, 0] = set1 * 100
            tmpArray[i, 1] = set2 * 100
            tmpArray[i, 2] = set3 * 100
            tmpArray[i, 3] = set4 * 100
        }
        
        return tmpArray
    }
    
    //MARK:- Chart Delegate
    public func setDataCount(_ waveArray: Array2D<Float>) {
        let yVals1 = setEntry(waveArray, 0)
        let yVals2 = setEntry(waveArray, 1)
        let yVals3 = setEntry(waveArray, 2)
        let yVals4 = setEntry(waveArray, 3)
        
        let set1 = setDataSet(yVals1, 0)
        let set2 = setDataSet(yVals2, 1)
        let set3 = setDataSet(yVals3, 2)
        let set4 = setDataSet(yVals4, 3)
        
        let chartData = LineChartData(dataSets: [set1, set2, set3, set4])
        chartData.setDrawValues(false)
        chartView?.extraLeftOffset = 20
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
            color = spectrumColors[3]
        case 1:
            color = spectrumColors[2]
        case 2:
            color = spectrumColors[1]
        case 3:
            color = spectrumColors[0]
        default:
            color = UIColor.clear
        }
        let text = "DataSet \(index)"
        let set = LineChartDataSet.init(entries: entry, label: text)
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = true
        set.drawValuesEnabled = false
        set.lineWidth = 1
        set.setColor(color)
        set.fillAlpha = 1
        set.fillColor = color

        set.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(self.chartView!.leftAxis.axisMaximum)
        }
        return set
    }
    
    private func setLimitLine(_ valueCount: Int) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60
        
        var time: [Int] = []
        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
            time.append(i)
            if i != 0 {
                let limit = ChartLimitLine(limit: Double(i), label: "")
                limit.drawLabelEnabled = false
                limit.lineColor = textColor.changeAlpha(to: 0.5)
                limit.lineWidth = 0.3
                self.chartView?.xAxis.addLimitLine(limit)
            }
            
        }
        
        self.chartView?.xAxis.valueFormatter = DateValueFormatter(time, timeStamp)
        
    }
}


/// X轴描述
class DateValueFormatter: NSObject, IAxisValueFormatter {
    private var values: [Double] = []
    private var timestamp: Int = 0
    private let dateFormatter = DateFormatter()
    /// 初始化
    ///
    /// - Parameters:
    ///   - timeStamps: 时间列表
    init(_ time:[Int], _ timestamp: Int = 0) {
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
