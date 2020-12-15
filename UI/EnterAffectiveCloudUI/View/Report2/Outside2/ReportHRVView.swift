//
//  ReportHRVView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/15.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class ReportHRVView: UIView {

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
    
    func initFunction() {
        self.backgroundColor = .clear
        self.addSubview(numLabel)
        self.addSubview(mslabel)
        self.addSubview(icon)
        numLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        numLabel.textColor = ColorExtension.textLv1
        
        mslabel.font = UIFont.systemFont(ofSize: 12)
        mslabel.textColor = ColorExtension.textLv2
        
        numLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.bottom.equalTo(-16)
        }
        
        mslabel.snp.makeConstraints {
            $0.left.equalTo(numLabel.snp.right).offset(5)
            $0.bottom.equalTo(-20)
        }
        
        icon.snp.makeConstraints {
            $0.bottom.equalTo(mslabel)
            $0.centerY.equalTo(mslabel)
        }
    }

}
