//
//  HeartRateIntroView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/21.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class HeartRateIntroView: UIView {

    public var value: Int = 0 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }

    let bgImagaView = UIImageView()
    let headView = PrivateReportViewHead()
    let valueLabel = UILabel()
    let unitLabel = UILabel()
    
    public func setup() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = ColorExtension.bgZ1
        self.addSubview(bgImagaView)
        self.addSubview(headView)
        self.addSubview(valueLabel)
        self.addSubview(unitLabel)
        headView.titleText = "Heart Rate"
        headView.image = UIImage.init(named: "heart")
        
        bgImagaView.image = UIImage.init(named: "type_red_blue")
        bgImagaView.contentMode = .scaleAspectFill
        self.bgImagaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        valueLabel.textColor = ColorExtension.textLv1
        valueLabel.font = UIFont(name: "SFProRounded-Bold", size: 40)
        valueLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
        unitLabel.text = "bpm"
        unitLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        unitLabel.textColor = ColorExtension.textLv1
        unitLabel.snp.makeConstraints {
            $0.bottom.equalTo(valueLabel.snp.bottom).offset(-6)
            $0.leading.equalTo(valueLabel.snp.trailing)
        }
    }


}
