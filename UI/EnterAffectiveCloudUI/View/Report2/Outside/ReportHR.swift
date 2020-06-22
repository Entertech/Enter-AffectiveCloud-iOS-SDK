//
//  ReportHR.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/23.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class PrivateReportHR: UIView {
    
    public var corner: CGFloat = 0 {
        willSet {
            self.layer.cornerRadius = newValue
        }
    }

    public var value: Int = 0 {
        willSet {
            numberView.number = newValue
            dotView.setDotValue(index: Float(newValue))
            for i in 0..<(_splitStateArray.count-1) {
                let range = _splitStateArray[i]..._splitStateArray[i+1]
                if range.contains(newValue) {
                    switch i {
                    case 0:
                        numberView.state = .low
                    case 1:
                        numberView.state = .nor
                    case 2:
                        numberView.state = .high
                    default:
                        numberView.state = .high
                    }
                    break
                }
            }
        }
    }
    
    public let numberView = PrivateReportNumberView()
    let dotView = SurveyorsRodView()
    
    public var colors = [UIColor.colorWithHexString(hexColor: "ffb2c0"),
                         UIColor.colorWithHexString(hexColor: "ff66b2"),
                         UIColor.colorWithHexString(hexColor: "7f5960")] {
        willSet {
            numberView.stateColor = newValue[0]
            dotView.setBarColor(newValue, splitStateArray)
            dotView.setDotColor(newValue[2])
        }
    }
    
    public var lineNumColor: UIColor = .white {
        willSet {
            dotView.setLabelColor(newValue)
        }
    }
    
    let splitStateArray:[CGFloat] = [50 ,60, 80, 100] //等级分段
    private let _splitStateArray = [50 ,60, 80, 100]
    
    let scaleArray = [50, 60, 80, 100] //刻度
    
    
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
        numberView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        dotView.snp.makeConstraints {
            $0.centerY.equalTo(numberView.snp.centerY).offset(8)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(29)
            $0.width.equalTo(180)
        }
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
    
    func initFunction() {
        self.backgroundColor = .clear
        numberView.stateColor = colors[0]
        numberView.unitString = "bpm"
        self.addSubview(numberView)
        
        dotView.setBarColor(colors, splitStateArray)
        dotView.setDotColor(colors[1])
        dotView.setLabelColor(UIColor.colorWithHexString(hexColor: "7f5960"))
        dotView.scaleArray = scaleArray
        self.addSubview(dotView)
        
    }

}
