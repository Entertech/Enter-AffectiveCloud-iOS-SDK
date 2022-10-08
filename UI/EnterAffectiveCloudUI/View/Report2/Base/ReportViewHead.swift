//
//  ReportViewHead.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/20.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit

/// 顶部栏
public class PrivateReportViewHead: UIView {
    public var titleText = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
    public var image: UIImage? {
        willSet {
            imageView.image = newValue
        }
    }
    
    public var btnImage: UIImage? {
        willSet {
            barButton.setImage(newValue, for: .normal)
        }
    }
    
    private let imageView = UIImageView()
    public let titleLabel = UILabel()
    public let barButton = UIButton(type: .custom)
    
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else {
            return
        }
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(11)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(8)
            $0.centerY.equalTo(imageView.snp.centerY)
        }
        barButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(11)
        }
        
        self.snp.makeConstraints  {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(46)
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    func initFunction()  {
        self.backgroundColor = .clear
        
        barButton.setImage(UIImage.loadImage(name: "right_back", any: classForCoder), for: .normal)
        self.addSubview(barButton)
    
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(titleLabel)
        
        self.addSubview(imageView)
    }
    
}
