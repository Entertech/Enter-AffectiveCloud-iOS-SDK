//
//  UIView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/21.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class RelaxationIntroView: UIView {

    // 最大值
    public var largeValue = 100 {
        willSet {
            relaxationCircleView.largeValue = CGFloat(newValue)
        }
    }
    // 最小值
    public var smallValue = 0 {
        willSet {
            relaxationCircleView.smallValue = CGFloat(newValue)
        }
    }
    
    public var relaxationValue:Int = 0 {
        willSet {
            relaxationNumberView.number = newValue
            relaxationCircleView.currentValue = CGFloat(newValue)
            relaxationCircleView.drawLayer()
            for i in 0..<(relaxationStateArray.count-1) {
                let range = relaxationStateArray[i]...relaxationStateArray[i+1]
                if range.contains(newValue) {
                    switch i {
                    case 0:
                        relaxationNumberView.state = .low
                    case 1:
                        relaxationNumberView.state = .nor
                    case 2:
                        relaxationNumberView.state = .high
                    default:
                        relaxationNumberView.state = .high
                    }
                    break
                }
            }
        }
    }
    
    public var titleText: String = ""  {
        willSet {
            header.titleText = newValue
            relaxationCircleView.text = newValue
            relaxationNumberView.language = .ch 
        }
    }
    
    
    public var relaxationColor = UIColor.colorWithHexString(hexColor: "5e75ff")
    
    public var relaxationStateArray = [0 ,30, 70, 100] //放松度等级分段
    
    
    public var relaxationStateColor = ColorExtension.blue5 {
        willSet {
            relaxationNumberView.stateColor = newValue
        }
    }

    public var relaxationStateTextColor = ColorExtension.blue2 {
        willSet {
            relaxationNumberView.stateTextColor = newValue
        }
    }

    
    private let relaxationNumberView = PrivateReportNumberView()
    private let relaxationCircleView = PrivateReportSemiCircle()
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
        self.addSubview(relaxationNumberView)
        self.addSubview(relaxationCircleView)
        
        header.titleText = "Relaxation"
        header.image = UIImage.loadImage(name: "relaxation", any: classForCoder)
        header.btnImage = nil
        bgImage.image = UIImage.loadImage(name: "type_blue_green", any: classForCoder)
        bgImage.contentMode = .scaleAspectFill
        self.bgImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        relaxationCircleView.shaperColor = relaxationColor
        relaxationCircleView.text = "Relaxation"
        
        relaxationNumberView.stateColor = relaxationStateColor
        relaxationNumberView.stateTextColor = relaxationStateTextColor

        relaxationNumberView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        relaxationCircleView.snp.makeConstraints {
            $0.height.equalTo(70)
            $0.width.equalTo(130)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }

}
