//
//  RhythmsIntroView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/21.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class RhythmsIntroView: UIView {

    public var value: (Int, Int, Int, Int, Int) = (0, 0, 0, 0, 0) {
        didSet {
            gammaNumLabel.text = "\(value.0)"
            betaNumLabel.text = "\(value.1)"
            alphaNumLabel.text = "\(value.2)"
            thetaNumLabel.text = "\(value.3)"
            deltaNumLabel.text = "\(value.4)"
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public var gammaColor = UIColor.colorWithHexString(hexColor: "#FF6682")
    public var betaColor = UIColor.colorWithHexString(hexColor: "#58B9E0")
    public var alphaColor = UIColor.colorWithHexString(hexColor: "#F7C77E")
    public var thetaColor = UIColor.colorWithHexString(hexColor: "#5FC695")
    public var deltaColor = UIColor.colorWithHexString(hexColor: "#5E75FF")
    public var numFont = UIFont.rounded(ofSize: 18, weight: .semibold)
    public var percentFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
    public var lineColor = ColorExtension.lineLight

    let bgImagaView = UIImageView()
    let headView = PrivateReportViewHead()
    let gammaImage = UIImageView()
    let gammaNumLabel = UILabel()
    let gammaPercentLabel = UILabel()
    let split1 = UIView()
    let betaImage = UIImageView()
    let betaNumLabel = UILabel()
    let betaPercentLabel = UILabel()
    let split2 = UIView()
    let alphaImage = UIImageView()
    let alphaNumLabel = UILabel()
    let alphaPercentLabel = UILabel()
    let split3 = UIView()
    let thetaImage = UIImageView()
    let thetaNumLabel = UILabel()
    let thetaPercentLabel = UILabel()
    let split4 = UIView()
    let deltaImage = UIImageView()
    let deltaNumLabel = UILabel()
    let deltaPercentLabel = UILabel()
    
    public func setup() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = ColorExtension.bgZ1
        self.addSubview(bgImagaView)
        self.addSubview(headView)
        addSubview(gammaImage)
        addSubview(gammaNumLabel)
        addSubview(gammaPercentLabel)
        addSubview(split1)
        addSubview(betaImage)
        addSubview(betaPercentLabel)
        addSubview(betaNumLabel)
        addSubview(split2)
        addSubview(alphaImage)
        addSubview(alphaNumLabel)
        addSubview(alphaPercentLabel)
        addSubview(split3)
        addSubview(thetaImage)
        addSubview(thetaNumLabel)
        addSubview(thetaPercentLabel)
        addSubview(split4)
        addSubview(deltaImage)
        addSubview(deltaNumLabel)
        addSubview(deltaPercentLabel)
        headView.titleText = "Brainwave Rhythms"
        headView.image = UIImage.loadImage(name: "brainwave", any: classForCoder)
        
        bgImagaView.image = UIImage.loadImage(name: "type_yellow_green", any: classForCoder)
        bgImagaView.contentMode = .scaleAspectFill
        self.bgImagaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gammaImage.image = UIImage.loadImage(name: "gamma", any: classForCoder)
        gammaNumLabel.textColor = gammaColor
        gammaNumLabel.font = numFont
        gammaPercentLabel.textColor = gammaColor
        gammaPercentLabel.font = percentFont
        gammaPercentLabel.text = "%"

        split1.backgroundColor = lineColor
        split1.layer.cornerRadius = 0.5
        split1.layer.masksToBounds = true

        betaImage.image = UIImage.loadImage(name: "beta", any: classForCoder)
        betaNumLabel.textColor = betaColor
        betaNumLabel.font = numFont
        betaPercentLabel.textColor = betaColor
        betaPercentLabel.font = percentFont
        betaPercentLabel.text = "%"

        split2.backgroundColor = lineColor
        split2.layer.cornerRadius = 0.5
        split2.layer.masksToBounds = true

        alphaImage.image = UIImage.loadImage(name: "alpha", any: classForCoder)
        alphaNumLabel.textColor = alphaColor
        alphaNumLabel.font = numFont
        alphaPercentLabel.textColor = alphaColor
        alphaPercentLabel.font = percentFont
        alphaPercentLabel.text = "%"

        split3.backgroundColor = lineColor
        split3.layer.cornerRadius = 0.5
        split3.layer.masksToBounds = true

        thetaImage.image = UIImage.loadImage(name: "theta", any: classForCoder)
        thetaNumLabel.textColor = thetaColor
        thetaNumLabel.font = numFont
        thetaPercentLabel.textColor = thetaColor
        thetaPercentLabel.font = percentFont
        thetaPercentLabel.text = "%"

        split4.backgroundColor = lineColor
        split4.layer.cornerRadius = 0.5
        split4.layer.masksToBounds = true

        deltaImage.image = UIImage.loadImage(name: "delta", any: classForCoder)
        deltaNumLabel.textColor = deltaColor
        deltaNumLabel.font = numFont
        deltaPercentLabel.textColor = deltaColor
        deltaPercentLabel.font = percentFont
        deltaPercentLabel.text = "%"
        
        gammaImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.equalTo(16)
            $0.height.equalTo(20)
        }
        gammaNumLabel.snp.makeConstraints {
            $0.leading.equalTo(gammaImage.snp.trailing)
            $0.centerY.equalTo(gammaImage.snp.centerY)
            $0.height.equalTo(21)
        }
        gammaPercentLabel.snp.makeConstraints {
            $0.bottom.equalTo(gammaNumLabel.snp.bottom)
            $0.leading.equalTo(gammaNumLabel.snp.trailing)
            $0.height.equalTo(17)
            $0.width.equalTo(14)
        }
        split1.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(18)
            $0.leading.equalTo(gammaPercentLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(gammaImage.snp.centerY)
        }
        
        betaImage.snp.makeConstraints {
            $0.leading.equalTo(split1.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.equalTo(16)
            $0.height.equalTo(20)
        }
        betaNumLabel.snp.makeConstraints {
            $0.leading.equalTo(betaImage.snp.trailing)
            $0.centerY.equalTo(betaImage.snp.centerY)
            $0.height.equalTo(21)
        }
        betaPercentLabel.snp.makeConstraints {
            $0.bottom.equalTo(betaNumLabel.snp.bottom)
            $0.leading.equalTo(betaNumLabel.snp.trailing)
            $0.height.equalTo(17)
            $0.width.equalTo(14)
        }
        split2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(18)
            $0.leading.equalTo(betaPercentLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(betaImage.snp.centerY)
        }
        
        alphaImage.snp.makeConstraints {
            $0.leading.equalTo(split2.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.equalTo(16)
            $0.height.equalTo(20)
        }
        alphaNumLabel.snp.makeConstraints {
            $0.leading.equalTo(alphaImage.snp.trailing)
            $0.centerY.equalTo(alphaImage.snp.centerY)
            $0.height.equalTo(21)
        }
        alphaPercentLabel.snp.makeConstraints {
            $0.bottom.equalTo(alphaNumLabel.snp.bottom)
            $0.leading.equalTo(alphaNumLabel.snp.trailing)
            $0.height.equalTo(17)
            $0.width.equalTo(14)
        }
        split3.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(18)
            $0.leading.equalTo(alphaPercentLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(alphaImage.snp.centerY)
        }
        
        thetaImage.snp.makeConstraints {
            $0.leading.equalTo(split3.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.equalTo(16)
            $0.height.equalTo(20)
        }
        thetaNumLabel.snp.makeConstraints {
            $0.leading.equalTo(thetaImage.snp.trailing)
            $0.centerY.equalTo(thetaImage.snp.centerY)
            $0.height.equalTo(21)
        }
        thetaPercentLabel.snp.makeConstraints {
            $0.bottom.equalTo(thetaNumLabel.snp.bottom)
            $0.leading.equalTo(thetaNumLabel.snp.trailing)
            $0.height.equalTo(17)
            $0.width.equalTo(14)
        }
        split4.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(18)
            $0.leading.equalTo(thetaPercentLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(thetaImage.snp.centerY)
        }
        deltaImage.snp.makeConstraints {
            $0.leading.equalTo(split3.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.equalTo(16)
            $0.height.equalTo(20)
        }
        deltaNumLabel.snp.makeConstraints {
            $0.leading.equalTo(deltaImage.snp.trailing)
            $0.centerY.equalTo(deltaImage.snp.centerY)
            $0.height.equalTo(21)
        }
        deltaPercentLabel.snp.makeConstraints {
            $0.bottom.equalTo(deltaNumLabel.snp.bottom)
            $0.leading.equalTo(deltaNumLabel.snp.trailing)
            $0.height.equalTo(17)
            $0.width.equalTo(14)
        }
    }

}
