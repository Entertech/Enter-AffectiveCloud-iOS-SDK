//
//  AffectiveRhythmsView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/4.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts


public class AffectiveCharts3RhythmsPowerTrendView: UIView, ChartViewDelegate {
    
    /// 数据上传周期，用于计算图表x轴间隔
    public var uploadCycle: UInt = 0 {
        willSet {
            chartView.uploadCycle = newValue
        }
    }
    
    public weak var delegate: RhythmsViewDelegate?
    
    public var buttonBackgroundColor = UIColor.white {
        willSet {
            gamaBtn.backgroundColor = newValue
            betaBtn.backgroundColor = newValue
            alphaBtn.backgroundColor = newValue
            thetaBtn.backgroundColor = newValue
            deltaBtn.backgroundColor = newValue
        }
    }
    
    public var bgColor = UIColor.white {
        willSet {
            self.backgroundColor = newValue
        }
    }
    
    public var gamaColor = UIColor.colorWithHexString(hexColor: "#FF6682") {
        willSet {
            gamaBtn.setTitleColor(newValue, for: .selected)
            chartView.gamaColor = newValue
        }
    }
    public var betaColor = UIColor.colorWithHexString(hexColor: "#58B9E0") {
        willSet {
            betaBtn.setTitleColor(newValue, for: .selected)
            chartView.betaColor = newValue
        }
    }
    public var alphaColor = UIColor.colorWithHexString(hexColor: "#F7C77E") {
        willSet {
            alphaBtn.setTitleColor(newValue, for: .selected)
            chartView.alphaColor = newValue
        }
    }
    public var thetaColor = UIColor.colorWithHexString(hexColor: "#5FC695") {
        willSet {
            thetaBtn.setTitleColor(newValue, for: .selected)
            chartView.thetaColor = newValue
        }
    }
    public var deltaColor = UIColor.colorWithHexString(hexColor: "#5E75FF") {
        willSet {
            deltaBtn.setTitleColor(newValue, for: .selected)
            chartView.deltaColor = newValue
        }
    }
    
    
    public var disableColor = UIColor.colorWithHexString(hexColor: "#FF6682") {
        willSet {
            
            gamaBtn.setTitleColor(newValue, for: .normal)
            betaBtn.setTitleColor(newValue, for: .normal)
            alphaBtn.setTitleColor(newValue, for: .normal)
            thetaBtn.setTitleColor(newValue, for: .normal)
            deltaBtn.setTitleColor(newValue, for: .normal)
        }
    }

    
    public var axisColor = ColorExtension.textLv1 {
        willSet {
            chartView.axisColor = newValue
        }
    }
    
    public var gridColor = ColorExtension.textLv1 {
        willSet {
            chartView.leftAxis.gridColor = newValue
        }
    }
    
    public var textColor = ColorExtension.textLv1 {
        willSet {
            chartView.xAxis.labelTextColor = newValue
        }
    }
    
    ///伽马线是否可用
    public lazy var gamaEnable: Bool = true {
        willSet {
            if newValue {
                gamaBtn.isSelected = true
                chartView.enableGama = true
                delegate?.setRhythmsEnable(value: 1<<1)
            } else {
                gamaBtn.isSelected = false
                chartView.enableGama = false
                delegate?.setRhythmsEnable(value: 1)
            }
        }
    }
    ///beta线是否可用
    public lazy var betaEnable: Bool = true {
        willSet {
            if newValue {
                betaBtn.isSelected = true
                chartView.enableBeta = true
                delegate?.setRhythmsEnable(value: 1<<3)
            } else {
                betaBtn.isSelected = false
                chartView.enableBeta = false
                delegate?.setRhythmsEnable(value: 1<<2)
            }
        }
    }
    ///alpha线是否可用
    public lazy var alphaEnable: Bool = true {
        willSet {
            if newValue {
                alphaBtn.isSelected = true
                chartView.enableAlpha = true
                delegate?.setRhythmsEnable(value: 1<<5)
            } else {
                alphaBtn.isSelected = false
                chartView.enableAlpha = false
                delegate?.setRhythmsEnable(value: 1<<4)
            }
        }
    }
    ///theta线是否可用
    public lazy var thetaEnable: Bool = true {
        willSet {
            if newValue {
                thetaBtn.isSelected = true
                chartView.enableTheta = true
                delegate?.setRhythmsEnable(value: 1<<7)
            } else {
                thetaBtn.isSelected = false
                chartView.enableTheta = false
                delegate?.setRhythmsEnable(value: 1<<6)
            }
        }
    }
    ///delta线是否可用
    public lazy var deltaEnable: Bool = true {
        willSet {
            if newValue {
                deltaBtn.isSelected = true
                chartView.enableDelta = true
                delegate?.setRhythmsEnable(value: 1<<9)
            } else {
                deltaBtn.isSelected = false
                chartView.enableDelta = false
                delegate?.setRhythmsEnable(value: 1<<8)
            }
        }
    }
    

    
    /// 标题
    public var title: String = "Rhythms Power Trend" {
        willSet {
            chartHead.titleText = newValue
        }
    }
    
    public var headerBtnImage: UIImage? {
        willSet {
            chartHead.barButton.setImage(newValue, for: .normal)
            chartHead.barButton.addTarget(self, action: #selector(expandAction(_:)), for: .touchUpInside)
        }
    }

    public var zoomText = "Zoom in on the curve and slide to view it."
    private var btnEnableCount: Int {
        get {
            var count = 0
            if gamaEnable {
                count += 1
            }
            if betaEnable {
                count += 1
            }
            if alphaEnable {
                count += 1
            }
            if thetaEnable {
                count += 1
            }
            if deltaEnable {
                count += 1
            }
            return count
        }
    }

    private let gamaBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 44, height: 24))
    private let betaBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 44, height: 24))
    private let alphaBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 44, height: 24))
    private let thetaBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 44, height: 24))
    private let deltaBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 44, height: 24))
    private let chartView = RhythmsChart()
    private let btnContentView = UIStackView()
    private let chartHead = PrivateReportViewHead()
    private let headImage = UIImageView()
    private lazy var gamaIcon = UIImage.highlightIcon(centerColor: gamaColor)
    private lazy var betaIcon = UIImage.highlightIcon(centerColor: betaColor)
    private lazy var alphaIcon = UIImage.highlightIcon(centerColor: alphaColor)
    private lazy var thetaIcon = UIImage.highlightIcon(centerColor: thetaColor)
    private lazy var deltaIcon = UIImage.highlightIcon(centerColor: deltaColor)
    public init() {
        super.init(frame: CGRect.zero)
        setUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if btnContentView.arrangedSubviews.count == 0 {
            btnContentView.addArrangedSubview(gamaBtn)
            btnContentView.addArrangedSubview(betaBtn)
            btnContentView.addArrangedSubview(alphaBtn)
            btnContentView.addArrangedSubview(thetaBtn)
            btnContentView.addArrangedSubview(deltaBtn)
            
        }
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        self.addSubview(headImage)
        self.addSubview(chartView)
        self.addSubview(btnContentView)
        self.addSubview(chartHead)
        self.headImage.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        btnContentView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(48)
            $0.height.equalTo(24)
        }
        
        chartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-16)
        }

        gamaBtn.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(24)
        }
        betaBtn.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(24)
        }
        alphaBtn.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(24)
        }
        thetaBtn.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(24)
        }
        deltaBtn.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(24)
        }
        
        gamaBtn.setTitle("γ", for: .normal)
        gamaBtn.setTitleColor(gamaColor, for: .normal)
        gamaBtn.layer.cornerRadius = 12
        gamaBtn.adjustsImageWhenHighlighted = false
        gamaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        gamaBtn.addTarget(self, action: #selector(gamaAction(_:)), for: .touchUpInside)
        
        betaBtn.setTitle("β", for: .normal)
        betaBtn.setTitleColor(betaColor, for: .normal)
        betaBtn.layer.cornerRadius = 12
        betaBtn.adjustsImageWhenHighlighted = false
        betaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        betaBtn.addTarget(self, action: #selector(betaAction(_:)), for: .touchUpInside)
        
        alphaBtn.setTitle("α", for: .normal)
        alphaBtn.setTitleColor(alphaColor, for: .normal)
        alphaBtn.layer.cornerRadius = 12
        alphaBtn.adjustsImageWhenHighlighted = false
        alphaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        alphaBtn.addTarget(self, action: #selector(alphaAction(_:)), for: .touchUpInside)
        
        thetaBtn.setTitle("θ", for: .normal)
        thetaBtn.setTitleColor(thetaColor, for: .normal)
        thetaBtn.layer.cornerRadius = 12
        thetaBtn.adjustsImageWhenHighlighted = false
        thetaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        thetaBtn.addTarget(self, action: #selector(thetaAction(_:)), for: .touchUpInside)
        
        deltaBtn.setTitle("δ", for: .normal)
        deltaBtn.setTitleColor(deltaColor, for: .normal)
        deltaBtn.layer.cornerRadius = 12
        deltaBtn.adjustsImageWhenHighlighted = false
        deltaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        deltaBtn.addTarget(self, action: #selector(deltaAction(_:)), for: .touchUpInside)
        
        chartView.delegate = self
        chartView.maxDataCount = 300
        chartView.isUserInteractionEnabled = true
       
        btnContentView.alignment = .fill
        btnContentView.axis = .horizontal
        btnContentView.distribution = .equalSpacing
        //btnContentView.translatesAutoresizingMaskIntoConstraints = false
        chartHead.titleText = title
        chartHead.image = UIImage.loadImage(name: "brainwave", any: classForCoder)
        chartHead.btnImage = nil
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        chartView.addGestureRecognizer(pressGesture)//添加长按事件



    }
    

    
    public func setData(gamaList: [Float], betaList: [Float], alphaList: [Float], thetaList: [Float], deltaList: [Float]) {
        chartView.setData(gama: gamaList, beta: betaList, alpha: alphaList, theta: thetaList, delta: deltaList)
    }
    
    @objc
    private func gamaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && gamaEnable  {
            return
        }
        gamaEnable = !gamaEnable
    }
    
    @objc
    private func betaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && betaEnable  {
            return
        }
        betaEnable = !betaEnable
    }
    @objc
    private func alphaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && alphaEnable  {
            return
        }
        alphaEnable = !alphaEnable
    }
    @objc
    private func thetaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && thetaEnable  {
            return
        }
        thetaEnable = !thetaEnable
    }
    @objc
    private func deltaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && deltaEnable  {
            return
        }
        deltaEnable = !deltaEnable
    }
    
    @objc
    private func expandAction(_ sender: UIButton) {
        self.delegate?.expandAction()
    }
 
    @objc
    private func tapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let h = chartView.getHighlightByTouchPoint(sender.location(in: self))
            if h === nil || h == chartView.lastHighlighted {
                chartView.lastHighlighted = nil
                chartView.highlightValue(nil)
                //chartHead.isHidden = true
                setItemHidden(true)
                chartView.delegate?.chartViewDidEndPanning?(chartView)
            } else {
                chartView.lastHighlighted = h
                chartView.highlightValue(h)
                //chartHead.isHidden = true
                setItemHidden(true)
                chartView.delegate?.chartValueSelected?(chartView, entry: chartView.data!.entry(for: h!)!, highlight: h!)
            }
        } else if sender.state == .changed {
            let h = chartView.getHighlightByTouchPoint(sender.location(in: self))
            if let h = h {
                chartView.lastHighlighted = h
                chartView.highlightValue(h)
                //chartHead.isHidden = true
                setItemHidden(true)
                chartView.delegate?.chartValueSelected?(chartView, entry: chartView.data!.entry(for: h)!, highlight: h)
            }
        } else if sender.state == .ended {
            chartView.lastHighlighted = nil
            chartView.highlightValue(nil)
            //chartHead.isHidden = false
            setItemHidden(false)
            chartView.delegate?.chartViewDidEndPanning?(chartView)
        }
    }
    
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        chartView.lastHighlighted = nil
        chartView.highlightValue(nil)
        //chartHead.isHidden = false
        setItemHidden(false)
        for j in 0..<btnEnableCount {
            
            for i in 0..<chartView.data!.dataSets[j].entryCount {
                chartView.data?.dataSets[j].entryForIndex(i)?.icon = nil
            }
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if !chartHead.isHidden {
            //chartHead.isHidden = true
            setItemHidden(true)
        }
        
        var lineEable = [Int]()
        if gamaEnable {
            lineEable.append(0)
        }
        if betaEnable {
            lineEable.append(1)
        }
        if alphaEnable {
            lineEable.append(2)
        }
        if thetaEnable {
            lineEable.append(3)
        }
        if deltaEnable {
            lineEable.append(4)
        }
        
        for j in 0..<lineEable.count {
            
            for i in 0..<chartView.data!.dataSets[j].entryCount {
                chartView.data?.dataSets[j].entryForIndex(i)?.icon = nil
            }
        }
        var index = chartView.data?.dataSets[0].entryIndex(entry: entry)
        if index == nil || index == -1 {
            if let dataCount = chartView.data?.dataSets.count, dataCount > 1 {
                index = chartView.data?.dataSets[1].entryIndex(entry: entry)
            }
        }
        if index == nil || index == -1 {
            if let dataCount = chartView.data?.dataSets.count, dataCount > 2 {
                index = chartView.data?.dataSets[2].entryIndex(entry: entry)
            }
        }
        if index == nil || index == -1 {
            if let dataCount = chartView.data?.dataSets.count, dataCount > 3 {
                index = chartView.data?.dataSets[3].entryIndex(entry: entry)
            }
        }
        if index == nil || index == -1 {
            if let dataCount = chartView.data?.dataSets.count, dataCount > 4 {
                index = chartView.data?.dataSets[4].entryIndex(entry: entry)
            }
        }
        
        if let index = index {
            for (i,e) in lineEable.enumerated() {
                switch e {
                case 0:
                    chartView.data?.dataSets[i].entryForIndex(index)?.icon = gamaIcon
                case 1:
                    chartView.data?.dataSets[i].entryForIndex(index)?.icon = betaIcon
                case 2:
                    chartView.data?.dataSets[i].entryForIndex(index)?.icon = alphaIcon
                case 3:
                    chartView.data?.dataSets[i].entryForIndex(index)?.icon = thetaIcon
                case 4:
                    chartView.data?.dataSets[i].entryForIndex(index)?.icon = deltaIcon
                default:
                    break
                }
            }
            
        }
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //chartHead.isHidden = false
        for j in 0..<btnEnableCount {
            
            for i in 0..<chartView.data!.dataSets[j].entryCount {
                chartView.data?.dataSets[j].entryForIndex(i)?.icon = nil
            }
        }
        setItemHidden(false)
    }
    
    private func setItemHidden(_ bIsHidden: Bool) {
        self.btnContentView.isHidden = bIsHidden
        
    }
    
    

}

