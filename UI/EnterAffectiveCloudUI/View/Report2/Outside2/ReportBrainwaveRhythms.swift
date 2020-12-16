//
//  ReportBrainwaveRhythms.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/3.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class ReportBrainwaveRhythms: UIView {

    public var uploadCycle = 0 {
        willSet {
            chartView.uploadCycle = UInt(newValue)
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
    
    public weak var delegate: RhythmsViewDelegate?
    
    ///伽马线是否可用
    public lazy var gamaEnable: Bool = true {
        willSet {
            if newValue {
                gamaBtn.setImage(UIImage.loadImage(name: "icon_choose_red", any: classForCoder), for: .normal)
                chartView.enableGama = true
                delegate?.setRhythmsEnable(value: 1 << 1)
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
    
    public var minText: String = "Time(min)" {
        willSet {
            minLabel.text = newValue
        }
    }
    
    private let gamaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let betaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let alphaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let thetaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let deltaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let minLabel = UILabel()
    private let chartView = RhythmsChart()
    private let btnContentView = UIStackView()
    
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
        gamaBtn.addTarget(self, action: #selector(gamaAction(_:)), for: .touchUpInside)
        
        betaBtn.backgroundColor = gamaColor.changeAlpha(to: 0.2)
        betaBtn.setTitle("β", for: .normal)
        betaBtn.setTitleColor(betaColor, for: .normal)
        betaBtn.layer.cornerRadius = 12
        betaBtn.adjustsImageWhenHighlighted = false
        betaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        betaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        betaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        betaBtn.addTarget(self, action: #selector(betaAction(_:)), for: .touchUpInside)
        
        alphaBtn.backgroundColor = alphaColor.changeAlpha(to: 0.2)
        alphaBtn.setTitle("α", for: .normal)
        alphaBtn.setTitleColor(alphaColor, for: .normal)
        alphaBtn.layer.cornerRadius = 12
        alphaBtn.adjustsImageWhenHighlighted = false
        alphaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        alphaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        alphaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        alphaBtn.addTarget(self, action: #selector(alphaAction(_:)), for: .touchUpInside)
        
        thetaBtn.backgroundColor = thetaColor.changeAlpha(to: 0.2)
        thetaBtn.setTitle("θ", for: .normal)
        thetaBtn.setTitleColor(thetaColor, for: .normal)
        thetaBtn.layer.cornerRadius = 12
        thetaBtn.adjustsImageWhenHighlighted = false
        thetaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        thetaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        thetaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        thetaBtn.addTarget(self, action: #selector(thetaAction(_:)), for: .touchUpInside)
        
        deltaBtn.backgroundColor = deltaColor.changeAlpha(to: 0.2)
        deltaBtn.setTitle("δ", for: .normal)
        deltaBtn.setTitleColor(deltaColor, for: .normal)
        deltaBtn.layer.cornerRadius = 12
        deltaBtn.adjustsImageWhenHighlighted = false
        deltaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        deltaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        deltaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        deltaBtn.addTarget(self, action: #selector(deltaAction(_:)), for: .touchUpInside)
        
        minLabel.textColor = textColor
        minLabel.font = UIFont.systemFont(ofSize: 12)
        minLabel.textAlignment = .center
        minLabel.text = minText
        
        chartView.maxDataCount = 1000
        
        btnContentView.alignment = .fill
        btnContentView.addArrangedSubview(gamaBtn)
        btnContentView.addArrangedSubview(betaBtn)
        btnContentView.addArrangedSubview(alphaBtn)
        btnContentView.addArrangedSubview(thetaBtn)
        btnContentView.addArrangedSubview(deltaBtn)
        btnContentView.axis = .horizontal
        btnContentView.backgroundColor = .clear
        btnContentView.distribution = .fillEqually
        btnContentView.spacing = 16
        //btnContentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(btnContentView)
        self.addSubview(minLabel)
        self.addSubview(chartView)
        
        setLayout()
    }
    
    
    private func setLayout() {
        
        btnContentView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(8)
            $0.height.equalTo(28)
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
    
}
