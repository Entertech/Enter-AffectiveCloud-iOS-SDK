//
//  ReportHRVView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/15.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class HRVIntroView: UIView {

    public var corner: CGFloat = 0 {
        willSet {
            self.layer.cornerRadius = newValue
        }
    }
    
    public var image: UIImage? = nil {
        willSet {
            icon.image = newValue
        }
    }
    
    public var value: Float = 0 {
        willSet {
            numLabel.text = "\(Int(newValue))"
        }
    }
 
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else { return }

    }
    
    private let numLabel = UILabel()
    private let mslabel = UILabel()
    private let icon = UIImageView()
    private let titleLabel = UILabel()
    private let button = UIImageView()
    private let bgImage = UIImageView()
    func initFunction() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = ColorExtension.bgZ1
        self.addSubview(bgImage)
        self.addSubview(numLabel)
        self.addSubview(mslabel)
        self.addSubview(icon)
        self.addSubview(titleLabel)
        self.addSubview(button)
        
        bgImage.image = UIImage.loadImage(name: "type_yellow_green", any: classForCoder)
        bgImage.contentMode = .scaleAspectFill
        self.bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.text = "HRV"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = ColorExtension.textLv1
        
        
        numLabel.font = .rounded(ofSize: 40, weight: .bold)
        numLabel.textColor = ColorExtension.textLv1
        numLabel.text = "\(value)"
        
        mslabel.font = UIFont.systemFont(ofSize: 12)
        mslabel.textColor = ColorExtension.textLv2
        mslabel.text = "ms"
        
        numLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.bottom.equalTo(-16)
        }
        
        mslabel.snp.makeConstraints {
            $0.left.equalTo(numLabel.snp.right).offset(5)
            $0.bottom.equalTo(-22)
        }
        
        icon.snp.makeConstraints {
            $0.bottom.equalTo(mslabel.snp.top)
            $0.centerX.equalTo(mslabel.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.top.equalTo(12)
        }
        
        button.snp.makeConstraints {
            $0.right.equalTo(-16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }

}
