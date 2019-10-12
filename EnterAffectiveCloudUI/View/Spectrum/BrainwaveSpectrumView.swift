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

class BrainwaveSpectrumView: UIView, NibLoadable {

    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var alphaBar: UILabel!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var betaBar: UILabel!
    @IBOutlet weak var betaLabel: UILabel!
    @IBOutlet weak var thetaBar: UILabel!
    @IBOutlet weak var thetaLabel: UILabel!
    @IBOutlet weak var deltaBar: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var gamaBar: UILabel!
    @IBOutlet weak var gamaLabel: UILabel!
    @IBOutlet weak var alphaValueLabel: UILabel!
    @IBOutlet weak var betaValueLabel: UILabel!
    @IBOutlet weak var thetaValueLabel: UILabel!
    @IBOutlet weak var deltaValueLabel: UILabel!
    @IBOutlet weak var gamaValueLabel: UILabel!
    
    let maxPercentLength: CGFloat = 210
    let minPercentLength: CGFloat = 1
    
    init() {
        super.init(frame:CGRect.zero)
        let view = BrainwaveSpectrumView.loadFromNib()
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
        sampleValue(false)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = BrainwaveSpectrumView.loadFromNib()
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
        sampleValue(false)
    }
    
    func sampleValue(_ isSample: Bool) {
        let alphaValue = isSample ? 0.32 : 0.0
        let betaValue = isSample ? 0.64 : 0.0
        let gamaValue = isSample ? 0.16 : 0.0
        let deltaValue = isSample ? 0.24 : 0.0
        let thetaValue = isSample ? 0.17 : 0.0
        alphaValueLabel.text = String(format: "%.1f%%", alphaValue * 100)
        alphaBar.snp.updateConstraints{
            $0.width.equalTo((0.01 + CGFloat(alphaValue / 0.8)) * self.maxPercentLength)
        }
        betaValueLabel.text = String(format: "%.1f%%", betaValue * 100)
        betaBar.snp.updateConstraints{
            $0.width.equalTo((0.01 + CGFloat(betaValue / 1)) * self.maxPercentLength)
        }
        gamaValueLabel.text = String(format: "%.1f%%", gamaValue * 100)
        gamaBar.snp.updateConstraints{
            $0.width.equalTo((0.01 + CGFloat(gamaValue / 0.6)) * self.maxPercentLength)
        }
        deltaValueLabel.text = String(format: "%.1f%%", deltaValue * 100)
        deltaBar.snp.updateConstraints{
            $0.width.equalTo((0.01 + CGFloat(deltaValue / 0.8)) * self.maxPercentLength)
        }
        thetaValueLabel.text = String(format: "%.1f%%", thetaValue * 100)
        thetaBar.snp.updateConstraints{
            $0.width.equalTo((0.01 + CGFloat(thetaValue / 0.8)) * self.maxPercentLength)
        }
    }
    
    func setSpectrum(_ value: Float, _ type: SpectrumType) {

        let barLength = value
        switch type {
        case .α:
            alphaValueLabel.text = String(format: "%.1f%%", value * 100)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.alphaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                }
                self.layoutIfNeeded()
            })     
        case .β:
            betaValueLabel.text = String(format: "%.1f%%", value * 100)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.betaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength)) * self.maxPercentLength)
                }
                self.layoutIfNeeded()
            }) { (b) in
                
            }
        case .γ:
            gamaValueLabel.text = String(format: "%.1f%%", value * 100)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.gamaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength / 0.6)) * self.maxPercentLength)
                }
                self.layoutIfNeeded()
            }) { (b) in
                
            }
        case .θ:
            thetaValueLabel.text = String(format: "%.1f%%", value * 100)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.thetaBar.snp.updateConstraints{
                    $0.width.equalTo((0.01 + CGFloat(barLength / 0.8)) * self.maxPercentLength)
                }
                self.layoutIfNeeded()
            }) { (b) in
                
            }
        case .δ:
            deltaValueLabel.text = String(format: "%.1f%%", value * 100)
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
