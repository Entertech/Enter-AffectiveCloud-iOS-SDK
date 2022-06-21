//
//  AttentionIntroView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/21.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class AttentionIntroView: UIView {

    // 最大值
    public var largeValue = 100 {
        willSet {
            attentionCircleView.largeValue = CGFloat(newValue)
        }
    }
    // 最小值
    public var smallValue = 0 {
        willSet {
            attentionCircleView.smallValue = CGFloat(newValue)
        }
    }
    
    public var attentionValue:Int = 0 {
        willSet {
            attentionNumberView.number = newValue
            attentionCircleView.currentValue = CGFloat(newValue)
            attentionCircleView.drawLayer()
            for i in 0..<(attentionStateArray.count-1) {
                let range = attentionStateArray[i]...attentionStateArray[i+1]
                if range.contains(newValue) {
                    switch i {
                    case 0:
                        attentionNumberView.state = .low
                    case 1:
                        attentionNumberView.state = .nor
                    case 2:
                        attentionNumberView.state = .high
                    default:
                        attentionNumberView.state = .high
                    }
                    break
                }
            }
        }
    }
    
    
    public var attentionColor = ColorExtension.greenPrimary
    
    public var attentionStateArray = [0 ,60, 80, 100] //放松度等级分段
    
    
    public var attentionStateColor = ColorExtension.green5 {
        willSet {
            attentionNumberView.stateColor = newValue
        }
    }

    public var attentionStateTextColor = ColorExtension.green2 {
        willSet {
            attentionNumberView.stateTextColor = newValue
        }
    }

    
    private let attentionNumberView = PrivateReportNumberView()
    private let attentionCircleView = PrivateReportSemiCircle()
    private let bgImage = UIImageView()
    private let header = PrivateReportViewHead()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
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
    
    private func initFunction() {
        self.backgroundColor = ColorExtension.bgZ1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.addSubview(bgImage)
        self.addSubview(header)
        self.addSubview(attentionNumberView)
        self.addSubview(attentionCircleView)
        
        header.titleText = "attention"
        header.image = UIImage.init(named: "attention")
        
        bgImage.image = UIImage.init(named: "type_blue_green")
        bgImage.contentMode = .scaleAspectFill
        self.bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        attentionCircleView.shaperColor = attentionColor
        attentionCircleView.text = "attention"
        
        attentionNumberView.stateColor = attentionStateColor
        attentionNumberView.stateTextColor = attentionStateTextColor

        attentionNumberView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        attentionCircleView.snp.makeConstraints {
            $0.height.equalTo(70)
            $0.width.equalTo(130)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }

}
