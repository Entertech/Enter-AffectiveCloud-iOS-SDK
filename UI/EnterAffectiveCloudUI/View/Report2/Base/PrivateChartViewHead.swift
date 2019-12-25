//
//  PrivateChartViewHead.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/24.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class PrivateChartViewHead: UIView {
    
    public var titleText = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    public let expandBtn = UIButton()
    
    private let titleLabel = UILabel()
    
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        expandBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.left.right.top.equalToSuperview()
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    func initFunction() {
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        expandBtn.setImage(UIImage.loadImage(name: "expand", any: classForCoder), for: .normal)
        
        self.addSubview(titleLabel)
        self.addSubview(expandBtn)
    }
    
}
