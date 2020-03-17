//
//  ReportNumberView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/20.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public enum PrivateReportState: String {
    case nor
    case low
    case high
}

public class PrivateReportNumberView: UIView {
    
    public var stateTextColor: UIColor = UIColor.colorWithHexString(hexColor: "7F725E") {
        willSet {
            stateText.textColor = newValue
        }
    }
    
    public var stateColor: UIColor = .clear {
        willSet {
            stateText.backgroundColor = newValue
        }
    }

    public var number: Int = 0 {
        willSet {
            numberText.text = "\(newValue)"
        }
    }
    
    public var unitString = "" {
        willSet {
            unitText.text = newValue
        }
    }
    
    public var state: PrivateReportState = .nor {
        willSet {
            stateText.text = newValue.rawValue
        }
    }
    
    let numberText = UILabel()
    let unitText = UILabel()
    let stateText = UILabel()

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
        numberText.snp.makeConstraints {
            $0.width.height.equalTo(55)
            $0.left.top.equalToSuperview()
        }
        stateText.snp.makeConstraints {
            $0.width.equalTo(39)
            $0.height.equalTo(17)
            $0.left.equalTo(numberText.snp.right).offset(2)
            $0.bottom.equalTo(numberText.snp.bottom).offset(-9)
        }
        
        unitText.snp.makeConstraints {
            $0.centerX.equalTo(stateText.snp.centerX)
            $0.bottom.equalTo(stateText.snp.top).offset(-1)
        }
        self.snp.makeConstraints {
            $0.width.equalTo(98)
            $0.height.equalTo(48)
        }
        
    }
    
    func initFunction() {
        self.backgroundColor = .clear
        
        numberText.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        numberText.textAlignment = .center
        self.addSubview(numberText)
        
        unitText.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        unitText.textColor = UIColor.colorWithHexString(hexColor: "999999")
        unitText.textAlignment = .center
        self.addSubview(unitText)
        
        stateText.text = state.rawValue
        stateText.layer.cornerRadius = 8.5
        stateText.layer.masksToBounds = true
        stateText.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        stateText.backgroundColor = stateColor
        stateText.textColor = stateTextColor
        stateText.textAlignment = .center
        self.addSubview(stateText)
        
    }
}
