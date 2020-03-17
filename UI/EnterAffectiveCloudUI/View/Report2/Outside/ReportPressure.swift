//
//  ReportPressure.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/23.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class PrivateReportPressure: UIView {
    public var value:Int =  0 {
        willSet {
            numLabel.text = "\(newValue)"
            circleView.currentValue = CGFloat(newValue)
            circleView.drawLayer()
            if newValue >= stateArray[0] && newValue <= stateArray[1] {
                state = .low
            } else if newValue >= stateArray[1] && newValue <= stateArray[2] {
                state = .nor
            } else  {
                state = .high
            }
        }
    }
    
    public var state: PrivateReportState = .nor{
        willSet {
            stateLabel.text = newValue.rawValue
        }
    }

    private let numLabel = UILabel()
    private let stateLabel = UILabel()
    public let circleView = ReportSemiCircle2()
    private var stateArray:[Int] = [0 ,20, 70, 100] //放松度等级分段
    
    public var stateColor = UIColor.colorWithHexString(hexColor: "ffb2c0") {
        willSet {
            stateLabel.backgroundColor = newValue
        }
    }
    private let stateTextColor = UIColor.colorWithHexString(hexColor: "7f5960")
    
    public init()  {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else { return }
        stateLabel.snp.makeConstraints {
            $0.width.equalTo(39)
            $0.height.equalTo(17)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        numLabel.snp.makeConstraints {
            $0.bottom.equalTo(stateLabel.snp.top).offset(-4)
            $0.centerX.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            $0.width.equalTo(260)
            $0.height.equalTo(140)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        self.snp.makeConstraints  {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(172)
        }
        
    }
    
    private func initFunction() {
        self.backgroundColor = .clear
        
        self.addSubview(numLabel)
        self.addSubview(stateLabel)
        self.addSubview(circleView)
        
        numLabel.font = UIFont.systemFont(ofSize: 38, weight: .semibold)

        stateLabel.text = state.rawValue
        stateLabel.layer.cornerRadius = 8.5
        stateLabel.layer.masksToBounds = true
        stateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        stateLabel.backgroundColor = stateColor
        stateLabel.textColor = stateTextColor
        stateLabel.textAlignment = .center
    }
    
    
}
