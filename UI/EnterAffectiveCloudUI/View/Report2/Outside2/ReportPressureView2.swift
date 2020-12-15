//
//  ReportPressureView2.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/15.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class ReportPressureView2: UIView {

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
    // 状态
    public var state: PrivateReportState = .nor{
        willSet {
            if language == .ch {
                stateLabel.text = newValue.ch
            } else {
                stateLabel.text = newValue.rawValue
            }
            
        }
    }
    public var language = LanguageEnum.en
    private let numLabel = UILabel()
    private let stateLabel = UILabel()
    public let circleView = ReportSemiCircle3() // 扇形试图
    public var stateArray:[Int] = [0 ,20, 70, 100] //放松度等级分段
    private let titleLabel = UILabel()
    private let button = UIImageView()
    
    // 状态文字背景色
    public var stateColor = ColorExtension.red5 {
        willSet {
            stateLabel.backgroundColor = newValue
        }
    }
    
    // 状态文字颜色
    public var stateTextColor = UIColor.colorWithHexString(hexColor: "7f5960") {
        willSet {
            stateLabel.textColor = newValue
        }
    }
    
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
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        numLabel.snp.makeConstraints {
            $0.bottom.equalTo(stateLabel.snp.top).offset(-4)
            $0.centerX.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    private func initFunction() {
        self.backgroundColor = .clear
        
        self.addSubview(numLabel)
        self.addSubview(stateLabel)
        self.addSubview(circleView)
        self.addSubview(titleLabel)
        self.addSubview(button)
        
        numLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.text = "Pressure"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = ColorExtension.textLv1
        
        button.image = UIImage.loadImage(name: "right_back", any: classForCoder)

        stateLabel.text = state.rawValue
        stateLabel.layer.cornerRadius = 8.5
        stateLabel.layer.masksToBounds = true
        stateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        stateLabel.backgroundColor = stateColor
        stateLabel.textColor = stateTextColor
        stateLabel.textAlignment = .center
    }

}
