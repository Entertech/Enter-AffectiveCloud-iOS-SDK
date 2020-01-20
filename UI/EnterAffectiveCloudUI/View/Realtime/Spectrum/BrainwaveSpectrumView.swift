//
//  BrainwaveSpectrumView.swift
//  Flowtime
//
//  Created by Enter on 2019/5/16.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

enum SpectrumType {
    case α
    case β
    case γ
    case θ
    case δ
}

class BrainwaveSpectrumView: BaseView {
    
    var isSample: Bool = false
    var infoButton: UIButton = UIButton()
    var titleLabel: UILabel = UILabel()
    var alphaBar: UILabel = UILabel()
    var alphaLabel: UILabel = UILabel()
    var betaBar: UILabel = UILabel()
    var betaLabel: UILabel = UILabel()
    var thetaBar: UILabel = UILabel()
    var thetaLabel: UILabel = UILabel()
    var deltaBar: UILabel = UILabel()
    var deltaLabel: UILabel = UILabel()
    var gamaBar: UILabel = UILabel()
    var gamaLabel: UILabel = UILabel()
    var alphaValueLabel: UILabel = UILabel()
    var betaValueLabel: UILabel = UILabel()
    var thetaValueLabel: UILabel = UILabel()
    var deltaValueLabel: UILabel = UILabel()
    var gamaValueLabel: UILabel = UILabel()
    
    private var maxPercentLength: CGFloat = 210
    private let minPercentLength: CGFloat = 4
    
    init() {
        super.init(frame:CGRect.zero)
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //sampleValue(isSample)
        maxPercentLength = self.bounds.width / 1.5
    }
    
    override func setUI() {
        self.addSubview(infoButton)
        self.addSubview(titleLabel)
        self.addSubview(alphaBar)
        self.addSubview(alphaLabel)
        self.addSubview(alphaValueLabel)
        self.addSubview(betaBar)
        self.addSubview(betaLabel)
        self.addSubview(betaValueLabel)
        self.addSubview(gamaBar)
        self.addSubview(gamaLabel)
        self.addSubview(gamaValueLabel)
        self.addSubview(thetaBar)
        self.addSubview(thetaLabel)
        self.addSubview(thetaValueLabel)
        self.addSubview(deltaBar)
        self.addSubview(deltaLabel)
        self.addSubview(deltaValueLabel)
        
        infoButton.setImage(UIImage.loadImage(name: "icon_info_black", any: classForCoder), for: .normal)
        
        alphaLabel.text = "α 波"
        alphaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        betaLabel.text = "β 波"
        betaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        thetaLabel.text = "θ 波"
        thetaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        deltaLabel.text = "δ 波"
        deltaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        gamaLabel.text = "γ 波"
        gamaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        
        alphaBar.layer.cornerRadius = 2
        alphaBar.layer.masksToBounds = true

        betaBar.layer.cornerRadius = 2
        betaBar.layer.masksToBounds = true
 
        gamaBar.layer.cornerRadius = 2
        gamaBar.layer.masksToBounds = true
        
        deltaBar.layer.cornerRadius = 2
        deltaBar.layer.masksToBounds = true

        thetaBar.layer.cornerRadius = 2
        thetaBar.layer.masksToBounds = true

        
        alphaValueLabel.text = "00%"
        betaValueLabel.text = "00%"
        gamaValueLabel.text = "00%"
        deltaValueLabel.text = "00%"
        thetaValueLabel.text = "00%"
        
        alphaValueLabel.font = UIFont.systemFont(ofSize: 12)
        betaValueLabel.font = UIFont.systemFont(ofSize: 12)
        gamaValueLabel.font = UIFont.systemFont(ofSize: 12)
        deltaValueLabel.font = UIFont.systemFont(ofSize: 12)
        thetaValueLabel.font = UIFont.systemFont(ofSize: 12)

        
    }
    
    
    override func setLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(17)
        }

        infoButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        gamaLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            //$0.top.equalToSuperview().offset(66)
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.3)
        }
        
        gamaBar.snp.makeConstraints {
            $0.left.equalTo(gamaLabel.snp.right).offset(12)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.centerY.equalTo(gamaLabel.snp.centerY).offset(2)
        }
        
        gamaValueLabel.snp.makeConstraints {
            $0.left.equalTo(gamaBar.snp.right).offset(8)
            $0.centerY.equalTo(gamaLabel.snp.centerY)
        }
        
        betaLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            //$0.top.equalToSuperview().offset(96)
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.45)
        }
        
        betaBar.snp.makeConstraints {
            $0.left.equalTo(betaLabel.snp.right).offset(12)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.centerY.equalTo(betaLabel.snp.centerY   ).offset(2)
        }
        
        betaValueLabel.snp.makeConstraints {
            $0.left.equalTo(betaBar.snp.right).offset(8)
            $0.centerY.equalTo(betaLabel.snp.centerY)
        }
        
        alphaLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            //$0.top.equalToSuperview().offset(128)
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.6)
        }
        
        alphaBar.snp.makeConstraints {
            $0.left.equalTo(alphaLabel.snp.right).offset(12)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.centerY.equalTo(alphaLabel.snp.centerY).offset(2)
        }
        
        alphaValueLabel.snp.makeConstraints {
            $0.left.equalTo(alphaBar.snp.right).offset(8)
            $0.centerY.equalTo(alphaLabel.snp.centerY)
        }
        
        thetaLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            //$0.top.equalToSuperview().offset(160)
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.75)
        }
        
        thetaBar.snp.makeConstraints {
            $0.left.equalTo(thetaLabel.snp.right).offset(12)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.centerY.equalTo(thetaLabel.snp.centerY   ).offset(2)
        }
        
        thetaValueLabel.snp.makeConstraints {
            $0.left.equalTo(thetaBar.snp.right).offset(8)
            $0.centerY.equalTo(thetaLabel.snp.centerY)
        }
        
        
        deltaLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            //$0.top.equalToSuperview().offset(192)
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.90)
        }
        
        deltaBar.snp.makeConstraints {
            $0.left.equalTo(deltaLabel.snp.right).offset(12)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.centerY.equalTo(deltaLabel.snp.centerY   ).offset(2)
        }
        
        deltaValueLabel.snp.makeConstraints {
            $0.left.equalTo(deltaBar.snp.right).offset(8)
            $0.centerY.equalTo(deltaLabel.snp.centerY)
        }
        
        
    }
    
    
    
    
    // Demo value
    func sampleValue(_ isSample: Bool) {
        let alphaValue = isSample ? 0.32 : 0.0
        let betaValue = isSample ? 0.64 : 0.0
        let gamaValue = isSample ? 0.16 : 0.0
        let deltaValue = isSample ? 0.24 : 0.0
        let thetaValue = isSample ? 0.17 : 0.0
        alphaValueLabel.text = String(format: "%.1f%%", alphaValue * 100)
        alphaBar.snp.updateConstraints{
            $0.width.equalTo((0.02 + CGFloat(alphaValue / 0.8)) * self.maxPercentLength)
        }
        betaValueLabel.text = String(format: "%.1f%%", betaValue * 100)
        betaBar.snp.updateConstraints{
            $0.width.equalTo((0.02 + CGFloat(betaValue / 1)) * self.maxPercentLength)
        }
        gamaValueLabel.text = String(format: "%.1f%%", gamaValue * 100)
        gamaBar.snp.updateConstraints{
            $0.width.equalTo((0.02 + CGFloat(gamaValue / 0.6)) * self.maxPercentLength)
        }
        deltaValueLabel.text = String(format: "%.1f%%", deltaValue * 100)
        deltaBar.snp.updateConstraints{
            $0.width.equalTo((0.02 + CGFloat(deltaValue / 0.8)) * self.maxPercentLength)
        }
        thetaValueLabel.text = String(format: "%.1f%%", thetaValue * 100)
        thetaBar.snp.updateConstraints{
            $0.width.equalTo((0.02 + CGFloat(thetaValue / 0.8)) * self.maxPercentLength)
        }
    }
    
    func setSpectrum(_ value: Float, _ type: SpectrumType) {

        let barLength = value
        
        switch type {
        case .α:
            alphaValueLabel.text = String(format: "%.1f%%", value * 100)
            if isSample  {
                self.alphaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                }
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.alphaBar.snp.updateConstraints{
                        $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                    }
                    self.layoutIfNeeded()
                })
            }
                
        case .β:
            betaValueLabel.text = String(format: "%.1f%%", value * 100)
            if isSample  {
                self.betaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength)) * self.maxPercentLength)
                }
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.betaBar.snp.updateConstraints{
                        $0.width.equalTo((0.01 + CGFloat(barLength)) * self.maxPercentLength)
                    }
                    self.layoutIfNeeded()
                }) { (b) in
                    
                }
            }
        case .γ:
            gamaValueLabel.text = String(format: "%.1f%%", value * 100)
            if isSample  {
                self.gamaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength / 0.6)) * self.maxPercentLength)
                }
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.gamaBar.snp.updateConstraints{
                        $0.width.equalTo((0.01 + CGFloat(barLength / 0.6)) * self.maxPercentLength)
                    }
                    self.layoutIfNeeded()
                }) { (b) in
                    
                }
                
            }
        case .θ:
            thetaValueLabel.text = String(format: "%.1f%%", value * 100)
            if isSample  {
                self.thetaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                }
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.thetaBar.snp.updateConstraints{
                        $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                    }
                    self.layoutIfNeeded()
                }) { (b) in
                    
                }
            }
        case .δ:
            deltaValueLabel.text = String(format: "%.1f%%", value * 100)
            if isSample  {
                self.deltaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                }
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.deltaBar.snp.updateConstraints{
                        $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                    }
                    self.layoutIfNeeded()
                }) { (b) in
                    
                }
            }
        }
    }
}
