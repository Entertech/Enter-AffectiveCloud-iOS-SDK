//
//  AffectiveRhythmsView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/4.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

protocol RhythmsViewDelegate: class {
    func setRhythmsEnable(value: Int)
}

public class AffectiveRhythmsView: UIView, ChartViewDelegate {
    
    /// 数据上传周期，用于计算图表x轴间隔
    public var uploadCycle: UInt = 0 {
        willSet {
            chartView.uploadCycle = newValue
        }
    }
    
    public var gamaColor = UIColor.colorWithHexString(hexColor: "#FF6682") {
        willSet {
            gamaBtn.backgroundColor = newValue.changeAlpha(to: 0.2)
            gamaBtn.setTitleColor(newValue, for: .normal)
            chartView.gamaColor = newValue
        }
    }
    public var betaColor = UIColor.colorWithHexString(hexColor: "#58B9E0") {
        willSet {
            betaBtn.backgroundColor = newValue.changeAlpha(to: 0.2)
            betaBtn.setTitleColor(newValue, for: .normal)
            chartView.betaColor = newValue
        }
    }
    public var alphaColor = UIColor.colorWithHexString(hexColor: "#F7C77E") {
        willSet {
            alphaBtn.backgroundColor = newValue.changeAlpha(to: 0.2)
            alphaBtn.setTitleColor(newValue, for: .normal)
            chartView.alphaColor = newValue
        }
    }
    public var thetaColor = UIColor.colorWithHexString(hexColor: "#5FC695") {
        willSet {
            thetaBtn.backgroundColor = newValue.changeAlpha(to: 0.2)
            thetaBtn.setTitleColor(newValue, for: .normal)
            chartView.thetaColor = newValue
        }
    }
    public var deltaColor = UIColor.colorWithHexString(hexColor: "#5E75FF") {
        willSet {
            deltaBtn.backgroundColor = newValue.changeAlpha(to: 0.2)
            deltaBtn.setTitleColor(newValue, for: .normal)
            chartView.deltaColor = newValue
        }
    }
    
    public var textColor = ColorExtension.textLv1 {
        willSet {
            minLabel.textColor = newValue
            chartView.axisColor = newValue
        }
    }
    
    ///伽马线是否可用
    public lazy var gamaEnable: Bool = true {
        willSet {
            if newValue {
                gamaBtn.setImage(UIImage.loadImage(name: "icon_choose_red", any: classForCoder), for: .normal)
                chartView.enableGama = true
                delegate?.setRhythmsEnable(value: 1<<1)
            } else {
                gamaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_red", any: classForCoder), for: .normal)
                chartView.enableGama = false
                delegate?.setRhythmsEnable(value: 1)
            }
        }
    }
    ///beta线是否可用
    public lazy var betaEnable: Bool = true {
        willSet {
            if newValue {
                betaBtn.setImage(UIImage.loadImage(name: "icon_choose_cyan", any: classForCoder), for: .normal)
                chartView.enableBeta = true
                delegate?.setRhythmsEnable(value: 1<<3)
            } else {
                betaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_cyan", any: classForCoder), for: .normal)
                chartView.enableBeta = false
                delegate?.setRhythmsEnable(value: 1<<2)
            }
        }
    }
    ///alpha线是否可用
    public lazy var alphaEnable: Bool = true {
        willSet {
            if newValue {
                alphaBtn.setImage(UIImage.loadImage(name: "icon_choose_yellow", any: classForCoder), for: .normal)
                chartView.enableAlpha = true
                delegate?.setRhythmsEnable(value: 1<<5)
            } else {
                alphaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_yellow", any: classForCoder), for: .normal)
                chartView.enableAlpha = false
                delegate?.setRhythmsEnable(value: 1<<4)
            }
        }
    }
    ///theta线是否可用
    public lazy var thetaEnable: Bool = true {
        willSet {
            if newValue {
                thetaBtn.setImage(UIImage.loadImage(name: "icon_choose_green", any: classForCoder), for: .normal)
                chartView.enableTheta = true
                delegate?.setRhythmsEnable(value: 1<<7)
            } else {
                thetaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_green", any: classForCoder), for: .normal)
                chartView.enableTheta = false
                delegate?.setRhythmsEnable(value: 1<<6)
            }
        }
    }
    ///delta线是否可用
    public lazy var deltaEnable: Bool = true {
        willSet {
            if newValue {
                deltaBtn.setImage(UIImage.loadImage(name: "icon_choose_blue", any: classForCoder), for: .normal)
                chartView.enableDelta = true
                delegate?.setRhythmsEnable(value: 1<<9)
            } else {
                deltaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_blue", any: classForCoder), for: .normal)
                chartView.enableDelta = false
                delegate?.setRhythmsEnable(value: 1<<8)
            }
        }
    }
    
    /// 标题
    public var title: String = "Changes during meditation" {
        willSet {
            chartHead.titleText = newValue
        }
    }
    
    public var minText: String = "Time(min)" {
        willSet {
            minLabel.text = newValue
        }
    }
    
    public var zoomText = "Zoom in on the curve and slide to view it."
    
    //MARK:- Private UI
    private var isChartScale = false {
        willSet {
            chartView.scaleXEnabled = newValue
            chartHead.expandBtn.isHidden = !newValue
        }
    }
    private weak var delegate: RhythmsViewDelegate?
    private let gamaBtn = UIButton()
    private let betaBtn = UIButton()
    private let alphaBtn = UIButton()
    private let thetaBtn = UIButton()
    private let deltaBtn = UIButton()
    private let minLabel = UILabel()
    private let chartView = RhythmsChart()
    private let btnContentView = UIStackView()
    private let chartHead = PrivateChartViewHead()
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
    
    private func setUI() {
        self.backgroundColor = .clear
        gamaBtn.backgroundColor = gamaColor.changeAlpha(to: 0.2)
        gamaBtn.setTitle("γ", for: .normal)
        gamaBtn.setTitleColor(gamaColor, for: .normal)
        gamaBtn.layer.cornerRadius = 12
        gamaBtn.adjustsImageWhenHighlighted = false
        gamaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        gamaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        gamaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        betaBtn.backgroundColor = gamaColor.changeAlpha(to: 0.2)
        betaBtn.setTitle("β", for: .normal)
        betaBtn.setTitleColor(betaColor, for: .normal)
        betaBtn.layer.cornerRadius = 12
        betaBtn.adjustsImageWhenHighlighted = false
        betaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        betaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        betaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        alphaBtn.backgroundColor = alphaColor.changeAlpha(to: 0.2)
        alphaBtn.setTitle("α", for: .normal)
        alphaBtn.setTitleColor(alphaColor, for: .normal)
        alphaBtn.layer.cornerRadius = 12
        alphaBtn.adjustsImageWhenHighlighted = false
        alphaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        alphaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        alphaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        thetaBtn.backgroundColor = thetaColor.changeAlpha(to: 0.2)
        thetaBtn.setTitle("θ", for: .normal)
        thetaBtn.setTitleColor(thetaColor, for: .normal)
        thetaBtn.layer.cornerRadius = 12
        thetaBtn.adjustsImageWhenHighlighted = false
        thetaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        thetaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        thetaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        deltaBtn.backgroundColor = deltaColor.changeAlpha(to: 0.2)
        deltaBtn.setTitle("δ", for: .normal)
        deltaBtn.setTitleColor(deltaColor, for: .normal)
        deltaBtn.layer.cornerRadius = 12
        deltaBtn.adjustsImageWhenHighlighted = false
        deltaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        deltaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        deltaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        minLabel.textColor = textColor
        minLabel.font = UIFont.systemFont(ofSize: 12)
        minLabel.textAlignment = .center
        minLabel.text = minText
        
        chartView.delegate = self
        chartView.maxDataCount = 1000
        chartView.isUserInteractionEnabled = true
        
        btnContentView.alignment = .center
        btnContentView.addArrangedSubview(gamaBtn)
        btnContentView.addArrangedSubview(betaBtn)
        btnContentView.addArrangedSubview(alphaBtn)
        btnContentView.addArrangedSubview(thetaBtn)
        btnContentView.addArrangedSubview(deltaBtn)
        btnContentView.axis = .horizontal
        btnContentView.backgroundColor = .clear
        btnContentView.distribution = .fillEqually
        btnContentView.spacing = 16
        
        chartHead.titleText = title
        chartHead.expandBtn.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        
//        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
//        chartView.addGestureRecognizer(pressGesture)//添加长按事件
        
        self.addSubview(chartView)
        self.addSubview(btnContentView)
        self.addSubview(minLabel)
        self.addSubview(chartHead)
        setLayout()
    }
    
    
    private func setLayout() {
        
        btnContentView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(8)
            $0.height.equalTo(32)
        }
        
        chartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalTo(minLabel.snp.top).offset(-6)
        }
        
        minLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
    public func setData(gamaList: [Float], betaList: [Float], alphaList: [Float], thetaList: [Float], deltaList: [Float]) {
        chartView.setData(gama: gamaList, beta: betaList, alpha: alphaList, theta: thetaList, delta: deltaList)
    }
    
    @objc
    private func gamaAction(_ sender: UIButton) {
        gamaEnable = !gamaEnable
    }
    
    @objc
    private func betaAction(_ sender: UIButton) {
        betaEnable = !betaEnable
    }
    @objc
    private func alphaAction(_ sender: UIButton) {
        alphaEnable = !alphaEnable
    }
    @objc
    private func thetaAction(_ sender: UIButton) {
        thetaEnable = !thetaEnable
    }
    @objc
    private func deltaAction(_ sender: UIButton) {
        deltaEnable = !deltaEnable
    }
    
    fileprivate var isZoomed = false
    fileprivate var isHiddenNavigationBar = false
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
            nShowChartView.backgroundColor = ColorExtension.bgZ1
            view?.addSubview(nShowChartView)
            if #available(iOS 13.0, *) {
                nShowChartView.backgroundColor = UIColor.systemBackground
            } else {
                // Fallback on earlier versions
                
            }
            let chart = AffectiveRhythmsView()
            nShowChartView.addSubview(chart)
            chart.chartHead.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            //chart.interval = self.interval
            //chart.bgColor = self.bgColor
            //chart.lineColor = self.lineColor
            //chart.cornerRadius = self.cornerRadius
            chart.chartView.maxDataCount = 1000
            chart.textColor = self.textColor
            chart.isChartScale = true
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.isZoomed = true
            chart.isHiddenNavigationBar = isHiddenNavigationBar
            chart.chartView.highlightPerTapEnabled = false
            chart.chartView.highlightPerDragEnabled = false
            chart.title = self.title
            chart.chartView.setData(gama: self.chartView.gamaArray, beta: self.chartView.betaArray, alpha: self.chartView.alphaArray, theta: self.chartView.thetaArray, delta: self.chartView.deltaArray)
            let label = UILabel()
            label.text = zoomText
            label.font = UIFont.systemFont(ofSize: 12)
            chart.chartHead.addSubview(label)
            label.snp.makeConstraints {
                $0.right.equalTo(chart.chartHead.expandBtn.snp.left).offset(-12)
                $0.centerY.equalTo(chart.chartHead.expandBtn.snp.centerY)
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
                chartView.delegate?.chartValueSelected?(chartView, entry: chartView.data!.entryForHighlight(h!)!, highlight: h!)
            }
        } else if sender.state == .changed {
            let h = chartView.getHighlightByTouchPoint(sender.location(in: self))
            if let h = h {
                chartView.lastHighlighted = h
                chartView.highlightValue(h)
                //chartHead.isHidden = true
                setItemHidden(true)
                chartView.delegate?.chartValueSelected?(chartView, entry: chartView.data!.entryForHighlight(h)!, highlight: h)
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
        for j in 0...4 {
            
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
        for j in 0...4 {
            
            for i in 0..<chartView.data!.dataSets[j].entryCount {
                chartView.data?.dataSets[j].entryForIndex(i)?.icon = nil
            }
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
        //chartHead.isHidden = false
        for j in 0...4 {
            
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
