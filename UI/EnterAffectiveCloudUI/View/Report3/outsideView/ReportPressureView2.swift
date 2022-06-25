//
//  ReportPressureView2.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/15.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class PressureIntroView: UIView {

    public var value:Int =  0 {
        willSet {
            
//            circleView.currentValue = CGFloat(newValue)
//            circleView.drawLayer()
            if newValue >= stateArray[0] && newValue <= stateArray[1] {
                state = .low
            } else if newValue >= stateArray[1] && newValue <= stateArray[2] {
                state = .nor
            } else  {
                state = .high
            }
            numLabel.text = "\(state.rawValue)"
        }
    }
    //state
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
    public let circleView = ReportSemiCircle3()
    public var stateArray:[Int] = [0 ,20, 70, 100] 
    private let titleLabel = UILabel()
    private let button = UIImageView()
    private let bgImage = UIImageView()
    
    // state label background color
    public var stateColor = ColorExtension.red5 {
        willSet {
            stateLabel.backgroundColor = newValue
        }
    }
    
    // state text color
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
            $0.bottom.equalTo(stateLabel.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            if UIDevice.current.userInterfaceIdiom == .pad {
                $0.width.equalTo(200)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(32)
            } else {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(32)
            }
            
            $0.bottom.equalTo(-4)
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
    
    private func initFunction() {
        self.backgroundColor = ColorExtension.bgZ1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.addSubview(bgImage)
        self.addSubview(numLabel)
        self.addSubview(stateLabel)
        self.addSubview(circleView)
        self.addSubview(titleLabel)
        self.addSubview(button)
        
        bgImage.image = UIImage.loadImage(name: "type_red_blue", any: classForCoder)
        bgImage.contentMode = .scaleAspectFill
        self.bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        numLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.text = "Pressure"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = ColorExtension.textLv1
        
//        button.image = UIImage.loadImage(name: "right_back", any: classForCoder)

        stateLabel.text = state.rawValue
        stateLabel.layer.cornerRadius = 8.5
        stateLabel.layer.masksToBounds = true
        stateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        stateLabel.backgroundColor = stateColor
        stateLabel.textColor = stateTextColor
        stateLabel.textAlignment = .center
        stateLabel.isHidden = true
    }

}
