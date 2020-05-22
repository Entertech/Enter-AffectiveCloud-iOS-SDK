//
//  AverageView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/24.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class PrivateAverageView: UIView {
    
    public enum AverageName: String {
        case Attention
        case Relaxation
        case Pressure
        case Heart
        case HRV
        case Meditation = "meditation time"
    }
    
    enum AverageCompare: String {
        case higher = "higher than"
        case lower = "lower than"
        case equal = "the same as"
        case shorter = "shorter than"
        case longer = "longer than"
    }
    
    public var values: [Int] = [] {
        willSet {
            if newValue.count > 0 {
                chart.values = newValue
                if let name = categoryName {
                    let total = newValue.reduce(0, +)
                    let averageValueTemp = Float(total) / Float(newValue.count)
                    let averageValue = lroundf(averageValueTemp)
                    let current = newValue.first!
                    var compareText = AverageCompare.equal
                    icon.image = UIImage.loadImage(name: "equal", any: classForCoder)
                    if current > averageValue {
                        compareText = name == .Meditation ? .longer : .higher
                        icon.image = UIImage.loadImage(name: "arrow_up", any: classForCoder)
                    } else if current < averageValue {
                        compareText = name == .Meditation ? .shorter : .lower
                        icon.image = UIImage.loadImage(name: "arrow_down", any: classForCoder)
                    }
                    let text = "The " + name.rawValue + " is " + compareText.rawValue + " the average of last 7 times."
                    let attributedText = NSMutableAttributedString(string:text)
                    let style = NSMutableParagraphStyle()
                    style.alignment = .left
                    style.lineSpacing = 5
                    attributedText.addAttribute(
                        kCTParagraphStyleAttributeName as NSAttributedString.Key,
                        value: style,
                        range: NSMakeRange(0, attributedText.length))
                    label.attributedText = attributedText
                }

            }

        }
    }
    
    public var mainColor: UIColor = UIColor.colorWithHexString(hexColor: "EAECF1") {
        willSet {
            chart.currentBarColor = newValue
        }
    }
    
    public var unitText:String = "" {
        willSet {
            chart.unitText = newValue
        }
    }
    
    public var textBgColor: UIColor = .white {
        willSet {
            bgLabel.backgroundColor = newValue
        }
    }
    
    public var numTextColor: UIColor = .white {
        willSet {
            chart.numTextColor = newValue
        }
    }
    
    public var numBgColor: UIColor = .gray {
        willSet {
            chart.numBgColor = newValue
        }
    }
    
    public var barColor: UIColor = .white {
        willSet {
            chart.barColor = newValue
        }
    }
    
    public var categoryName: AverageName?
    
    private let bgLabel = UIView()
    private let icon = UIImageView()
    private let chart = PrivateAverageOfSevenDayView()
    private let label = UILabel()
    
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
        bgLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-8)
            $0.height.equalTo(64)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        icon.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.left.equalTo(icon.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        chart.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(bgLabel.snp.top).offset(-24)
            $0.height.equalTo(146)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(258)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func initFunction() {
        self.backgroundColor = .clear
        self.addSubview(bgLabel)
        self.addSubview(chart)
        bgLabel.addSubview(icon)
        bgLabel.addSubview(label)
        
        bgLabel.backgroundColor = UIColor.colorWithHexString(hexColor: "F1F5F6")
        bgLabel.layer.cornerRadius = 16
        bgLabel.layer.masksToBounds = true
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
    }
}
