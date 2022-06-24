//
//  CoherenceTimeView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/21.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit

public class CoherenceIntroView: UIView {
    
    public var value: Int = 0 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }

    let bgImagaView = UIImageView()
    let headView = PrivateReportViewHead()
    let valueLabel = UILabel()
    let unitLabel = UILabel()
    
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
    
    private func setup() {
        self.backgroundColor = ColorExtension.bgZ1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        self.addSubview(bgImagaView)
        self.addSubview(headView)
        self.addSubview(valueLabel)
        self.addSubview(unitLabel)
        headView.titleText = "Coherence Time"
        headView.image = UIImage.loadImage(name: "coherence", any: classForCoder)
        
        bgImagaView.image = UIImage.loadImage(name: "type_yellow_green", any: classForCoder)
        bgImagaView.contentMode = .scaleAspectFill
        self.bgImagaView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        valueLabel.textColor = ColorExtension.textLv1
        valueLabel.font = .rounded(ofSize: 40, weight: .bold)
        valueLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
        unitLabel.text = "min"
        unitLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        unitLabel.textColor = ColorExtension.textLv1
        unitLabel.snp.makeConstraints {
            $0.bottom.equalTo(valueLabel.snp.bottom).offset(-6)
            $0.leading.equalTo(valueLabel.snp.trailing)
        }
    }

}
