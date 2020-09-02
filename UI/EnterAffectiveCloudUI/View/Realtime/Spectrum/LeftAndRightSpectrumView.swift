//
//  LeftAndRightSpectrumView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/9/1.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class LeftAndRightSpectrumView: UIView {

    var infoButton: UIButton = UIButton()
    var titleLabel: UILabel = UILabel()
    var alphaLabel: UILabel = UILabel()
    var betaLabel: UILabel = UILabel()
    var thetaLabel: UILabel = UILabel()
    var deltaLabel: UILabel = UILabel()
    var gamaLabel: UILabel = UILabel()
    var lalphaBar: UILabel = UILabel()
    var lbetaBar: UILabel = UILabel()
    var lthetaBar: UILabel = UILabel()
    var ldeltaBar: UILabel = UILabel()
    var lgamaBar: UILabel = UILabel()
    var lalphaValueLabel: UILabel = UILabel()
    var lbetaValueLabel: UILabel = UILabel()
    var lthetaValueLabel: UILabel = UILabel()
    var ldeltaValueLabel: UILabel = UILabel()
    var lgamaValueLabel: UILabel = UILabel()
    var ralphaBar: UILabel = UILabel()
    var rbetaBar: UILabel = UILabel()
    var rthetaBar: UILabel = UILabel()
    var rdeltaBar: UILabel = UILabel()
    var rgamaBar: UILabel = UILabel()
    var ralphaValueLabel: UILabel = UILabel()
    var rbetaValueLabel: UILabel = UILabel()
    var rthetaValueLabel: UILabel = UILabel()
    var rdeltaValueLabel: UILabel = UILabel()
    var rgamaValueLabel: UILabel = UILabel()
    
    private let maxPercentLength: CGFloat = (UIScreen.main.bounds.width - 80.0) / 2.0
    private let minPercentLength: CGFloat = 4
    private let scale:CGFloat = 0.7
    
    init() {
        super.init(frame:CGRect.zero)
        setUI()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
        setLayout()
    }
    
    private func setUI() {
        self.addSubview(infoButton)
        self.addSubview(titleLabel)
        self.addSubview(alphaLabel)
        self.addSubview(betaLabel)
        self.addSubview(gamaLabel)
        self.addSubview(thetaLabel)
        self.addSubview(deltaLabel)
        self.addSubview(lalphaBar)
        self.addSubview(lalphaValueLabel)
        self.addSubview(lbetaBar)
        self.addSubview(lbetaValueLabel)
        self.addSubview(lgamaBar)
        self.addSubview(lgamaValueLabel)
        self.addSubview(lthetaBar)
        self.addSubview(lthetaValueLabel)
        self.addSubview(ldeltaBar)
        self.addSubview(ldeltaValueLabel)
        self.addSubview(ralphaBar)
        self.addSubview(ralphaValueLabel)
        self.addSubview(rbetaBar)
        self.addSubview(rbetaValueLabel)
        self.addSubview(rgamaBar)
        self.addSubview(rgamaValueLabel)
        self.addSubview(rthetaBar)
        self.addSubview(rthetaValueLabel)
        self.addSubview(rdeltaBar)
        self.addSubview(rdeltaValueLabel)
        
        infoButton.setImage(UIImage.loadImage(name: "icon_info_black", any: classForCoder), for: .normal)
        
        alphaLabel.text = "α"
        alphaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        alphaLabel.textAlignment = .center
        betaLabel.text = "β"
        betaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        betaLabel.textAlignment = .center
        thetaLabel.text = "θ"
        thetaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        thetaLabel.textAlignment = .center
        deltaLabel.text = "δ"
        deltaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        deltaLabel.textAlignment = .center
        gamaLabel.text = "γ"
        gamaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        gamaLabel.textAlignment = .center
        
        lalphaBar.layer.cornerRadius = 2
        lalphaBar.layer.masksToBounds = true
        
        lbetaBar.layer.cornerRadius = 2
        lbetaBar.layer.masksToBounds = true
        
        lgamaBar.layer.cornerRadius = 2
        lgamaBar.layer.masksToBounds = true
        
        ldeltaBar.layer.cornerRadius = 2
        ldeltaBar.layer.masksToBounds = true
        
        lthetaBar.layer.cornerRadius = 2
        lthetaBar.layer.masksToBounds = true
        
        lalphaValueLabel.text = "00%"
        lbetaValueLabel.text = "00%"
        lgamaValueLabel.text = "00%"
        ldeltaValueLabel.text = "00%"
        lthetaValueLabel.text = "00%"
        
        lalphaValueLabel.font = UIFont.systemFont(ofSize: 12)
        lbetaValueLabel.font = UIFont.systemFont(ofSize: 12)
        lgamaValueLabel.font = UIFont.systemFont(ofSize: 12)
        ldeltaValueLabel.font = UIFont.systemFont(ofSize: 12)
        lthetaValueLabel.font = UIFont.systemFont(ofSize: 12)
        
        ralphaBar.layer.cornerRadius = 2
        ralphaBar.layer.masksToBounds = true
        
        rbetaBar.layer.cornerRadius = 2
        rbetaBar.layer.masksToBounds = true
        
        rgamaBar.layer.cornerRadius = 2
        rgamaBar.layer.masksToBounds = true
        
        rdeltaBar.layer.cornerRadius = 2
        rdeltaBar.layer.masksToBounds = true
        
        rthetaBar.layer.cornerRadius = 2
        rthetaBar.layer.masksToBounds = true
        
        ralphaValueLabel.text = "00%"
        rbetaValueLabel.text = "00%"
        rgamaValueLabel.text = "00%"
        rdeltaValueLabel.text = "00%"
        rthetaValueLabel.text = "00%"
        
        ralphaValueLabel.font = UIFont.systemFont(ofSize: 12)
        rbetaValueLabel.font = UIFont.systemFont(ofSize: 12)
        rgamaValueLabel.font = UIFont.systemFont(ofSize: 12)
        rdeltaValueLabel.font = UIFont.systemFont(ofSize: 12)
        rthetaValueLabel.font = UIFont.systemFont(ofSize: 12)
        
        
    }
    
    
    private func setLayout() {
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
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.3)
        }
        
        betaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.45)
        }
        
        alphaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.6)
        }
        thetaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.75)
        }
        deltaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.snp.bottom).multipliedBy(0.90)
        }
        
        lgamaBar.snp.makeConstraints {
            $0.right.equalTo(self.gamaLabel.snp.left).offset(-4)
            $0.centerY.equalTo(self.gamaLabel.snp.centerY)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
        }
        
        lgamaValueLabel.snp.makeConstraints {
            $0.right.equalTo(self.lgamaBar.snp.left).offset(-4)
            $0.centerY.equalTo(self.lgamaBar.snp.centerY)
        }
        
        rgamaBar.snp.makeConstraints {
            $0.left.equalTo(self.gamaLabel.snp.right).offset(4)
            $0.centerY.equalTo(self.gamaLabel.snp.centerY)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
        }
        
        rgamaValueLabel.snp.makeConstraints {
            $0.left.equalTo(self.rgamaBar.snp.right).offset(4)
            $0.centerY.equalTo(self.rgamaBar.snp.centerY)
        }
        
        lbetaBar.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.right.equalTo(self.betaLabel.snp.left).offset(-4)
            $0.centerY.equalTo(self.betaLabel.snp.centerY)
        }
        
        lbetaValueLabel.snp.makeConstraints {
            $0.right.equalTo(self.lbetaBar.snp.left).offset(-4)
            $0.centerY.equalTo(self.lbetaBar.snp.centerY)
        }
        
        rbetaBar.snp.makeConstraints {
            $0.left.equalTo(self.betaLabel.snp.right).offset(4)
            $0.centerY.equalTo(self.betaLabel.snp.centerY)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
        }
        
        rbetaValueLabel.snp.makeConstraints {
            $0.left.equalTo(self.rbetaBar.snp.right).offset(4)
            $0.centerY.equalTo(self.rbetaBar.snp.centerY)
        }
        
        lalphaBar.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.right.equalTo(self.alphaLabel.snp.left).offset(-4)
            $0.centerY.equalTo(self.alphaLabel.snp.centerY)
        }
        
        lalphaValueLabel.snp.makeConstraints {
            $0.right.equalTo(self.lalphaBar.snp.left).offset(-4)
            $0.centerY.equalTo(self.lalphaBar.snp.centerY)
        }
        
        ralphaBar.snp.makeConstraints {
            $0.left.equalTo(self.alphaLabel.snp.right).offset(4)
            $0.centerY.equalTo(self.alphaLabel.snp.centerY)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
        }
        
        ralphaValueLabel.snp.makeConstraints {
            $0.left.equalTo(self.ralphaBar.snp.right).offset(4)
            $0.centerY.equalTo(self.ralphaBar.snp.centerY)
        }
        
        lthetaBar.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.right.equalTo(self.thetaLabel.snp.left).offset(-4)
            $0.centerY.equalTo(self.thetaLabel.snp.centerY)
        }
        
        lthetaValueLabel.snp.makeConstraints {
            $0.right.equalTo(self.lthetaBar.snp.left).offset(-4)
            $0.centerY.equalTo(self.lthetaBar.snp.centerY)
        }
        
        rthetaBar.snp.makeConstraints {
            $0.left.equalTo(self.thetaLabel.snp.right).offset(4)
            $0.centerY.equalTo(self.thetaLabel.snp.centerY)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
        }
        
        rthetaValueLabel.snp.makeConstraints {
            $0.left.equalTo(self.rthetaBar.snp.right).offset(4)
            $0.centerY.equalTo(self.rthetaBar.snp.centerY)
        }
        
        ldeltaBar.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.width.equalTo(4)
            $0.right.equalTo(self.deltaLabel.snp.left).offset(-4)
            $0.centerY.equalTo(self.deltaLabel.snp.centerY)
        }
        
        ldeltaValueLabel.snp.makeConstraints {
            $0.right.equalTo(self.ldeltaBar.snp.left).offset(-4)
            $0.centerY.equalTo(self.ldeltaBar.snp.centerY)
        }
        
        rdeltaBar.snp.makeConstraints {
            $0.left.equalTo(self.deltaLabel.snp.right).offset(4)
            $0.centerY.equalTo(self.deltaLabel.snp.centerY)
            $0.height.equalTo(4)
            $0.width.equalTo(4)
        }
        
        rdeltaValueLabel.snp.makeConstraints {
            $0.left.equalTo(self.rdeltaBar.snp.right).offset(4)
            $0.centerY.equalTo(self.rdeltaBar.snp.centerY)
        }

    }
    
    func setSpectrum(_ value: Float, _ type: SpectrumType, _ category: SpectrumCategory) {

        let barLength = CGFloat(value) * 100
        
        switch type {
        case .α:
            var length = maxPercentLength
            if barLength / 40 > 1 {
                length = maxPercentLength * scale + maxPercentLength * (1 - scale) * (barLength - 40.0) / 60.0
            } else {
                length = barLength / 40.0 * maxPercentLength * scale
                if length < 4 {
                    length = 4
                }
            }
            switch category {
            case .left:
                lalphaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.lalphaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })

            case .right:
                ralphaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.ralphaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })
            case .total:
                break
            }

        case .β:
            var length = maxPercentLength
            if barLength / 50 > 1 {
                length = maxPercentLength * scale + maxPercentLength * (1 - scale) * (barLength - 50.0) / 50.0
            } else {
                length = barLength / 50.0 * maxPercentLength * scale
                if length < 4 {
                    length = 4
                }
            }
            
            switch category {
            case .left:

                lbetaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.lbetaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })

            case .right:
                rbetaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.rbetaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })
            case .total:
                break
            }
            
        case .γ:
            var length = maxPercentLength
            if barLength / 30 > 1 {
                length = maxPercentLength * scale + maxPercentLength * (1 - scale) * (barLength - 30.0) / 70.0
            } else {
                length = barLength / 30.0 * maxPercentLength * scale
                if length < 4 {
                    length = 4
                }
            }
            switch category {
            case .left:

                lgamaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.lgamaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })

            case .right:
                rgamaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.rgamaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })
            case .total:
                break
            }
            
        case .θ:
            var length = maxPercentLength
            if barLength / 40 > 1 {
                length = maxPercentLength * scale + maxPercentLength * (1 - scale) * (barLength - 40.0) / 60.0
            } else {
                length = barLength / 40.0 * maxPercentLength * scale
                if length < 4 {
                    length = 4
                }
            }
            switch category {
            case .left:
                lthetaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.lthetaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })

            case .right:
                rthetaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.rthetaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })
            case .total:
                break
            }
            
        case .δ:
            var length = maxPercentLength
            if barLength / 40 > 1 {
                length = maxPercentLength * scale + maxPercentLength * (1 - scale) * (barLength - 40.0) / 60.0
            } else {
                length = barLength / 40.0 * maxPercentLength * scale
                if length < 4 {
                    length = 4
                }
            }
            switch category {
            case .left:
                ldeltaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.ldeltaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                })

            case .right:
                rdeltaValueLabel.text = String(format: "%.1f%%", value * 100)
                self.rdeltaBar.snp.updateConstraints {
                    $0.width.equalTo(length)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {

                    self.layoutIfNeeded()
                })
            case .total:
                break
            }
        }
    }
}
