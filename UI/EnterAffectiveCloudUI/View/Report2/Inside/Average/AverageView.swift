//
//  AverageView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/24.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public enum AverageName: String {
    case Attention
    case Relaxation
    case Pressure = "stress"
    case Heart = "heart rate"
    case HRV
    case Meditation = "meditation time"
    case Coherence = "coherence time"
}

extension AverageName {
    var ch: String {
        switch self {
        case .Attention:
            return "注意力"
        case .Relaxation:
            return "放松度"
        case .Pressure:
            return "压力值"
        case .Heart:
            return "心率"
        case .HRV:
            return "心率变异性"
        case .Meditation:
            return "训练时长"
        case .Coherence:
            return "和谐时间"
        }
    }
}

extension AverageName {
    var theme: UIColor {
        get {
            switch self {
            case .Attention:
                return ColorExtension.greenPrimary
            case .Relaxation:
                return ColorExtension.bluePrimary
            case .Pressure:
                return ColorExtension.redPrimary
            case .Heart:
                return ColorExtension.redPrimary
            case .HRV:
                return ColorExtension.yellowPrimary
            case .Meditation:
                return ColorExtension.redPrimary
            case .Coherence:
                return ColorExtension.greenPrimary
            }
        }
    }
    
    var textColor: UIColor {
        get {
            switch self {
            case .Attention:
                return ColorExtension.green2
            case .Relaxation:
                return ColorExtension.blue2
            case .Pressure:
                return ColorExtension.red2
            case .Heart:
                return ColorExtension.red2
            case .HRV:
                return ColorExtension.yellow2
            case .Meditation:
                return ColorExtension.red2
            case .Coherence:
                return ColorExtension.green2
            }
        }
    }
    
    var textBackground: UIColor {
        get {
            switch self {
            case .Attention:
                return ColorExtension.green5
            case .Relaxation:
                return ColorExtension.blue5
            case .Pressure:
                return ColorExtension.red5
            case .Heart:
                return ColorExtension.red5
            case .HRV:
                return ColorExtension.yellow5
            case .Meditation:
                return ColorExtension.red5
            case .Coherence:
                return ColorExtension.green5
            }
        }
    }
    
    var unit: String {
        get {
            switch self {
            case .Attention:
                return ""
            case .Relaxation:
                return ""
            case .Pressure:
                return ""
            case .Heart:
                return "bpm"
            case .HRV:
                return "ms"
            case .Meditation:
                return "min"
            case .Coherence:
                return "min"
            }
        }
    }
}

public enum AverageCompare: String {
    case higher = "higher than"
    case lower = "lower than"
    case equal = "the same as"
    case shorter = "shorter than"
    case longer = "longer than"
}

extension AverageCompare {
    var ch: String {
        switch self {
        case .higher:
            return "高于"
        case .lower:
            return "低于"
        case .equal:
            return "等于"
        case .shorter:
            return "低于"
        case .longer:
            return "高于"
        }
    }
}

public enum LanguageEnum {
    case en
    case ch
}


public class PrivateAverageView: UIView {
    
    public var values: [Int] = [] {
        willSet {
            if newValue.count > 0 {
                self.chart.isHidden = false
                let name = categoryName
                let total = newValue.reduce(0, +)
                let averageValueTemp = Float(total) / Float(newValue.count)
                chart.values = newValue
                chart.averageValue = Int(ceilf(Float(total) / Float(newValue.count)))
                
                let averageValue = lroundf(averageValueTemp)
                let current = newValue.first!
                var compareText = AverageCompare.equal
                icon.image = UIImage.loadImage(name: "equal", any: classForCoder)
                if current > averageValue {
                    compareText = (name == .Meditation || name == .Coherence) ? .longer : .higher
                    icon.image = UIImage.loadImage(name: "arrow_up", any: classForCoder)
                } else if current < averageValue {
                    compareText = (name == .Meditation || name == .Coherence) ? .shorter : .lower
                    icon.image = UIImage.loadImage(name: "arrow_down", any: classForCoder)
                }
                if language == .en {
                    self.setCompareText(name: name.rawValue, compare: compareText.rawValue)
                } else {
                    self.setCompareText(name: name.ch, compare: compareText.ch)
                }
                    
            } else {
                self.chart.isHidden = true
            }

        }
    }
    
    public var floatValues: [Float] = [] {
        willSet {
            if newValue.count > 0 {
                chart.floatValues = newValue
                let name = categoryName
                let total = newValue.reduce(0, +)
                let averageValueTemp = Float(total) / Float(newValue.count)
                let averageValue = averageValueTemp
                let current = newValue.first!
                var compareText = AverageCompare.equal
                icon.image = UIImage.loadImage(name: "equal", any: classForCoder)
                if current > averageValue {
                    compareText = (name == .Meditation || name == .Coherence) ? .longer : .higher
                    icon.image = UIImage.loadImage(name: "arrow_up", any: classForCoder)
                    
                } else if current < averageValue {
                    compareText = (name == .Meditation || name == .Coherence) ? .shorter : .lower
                    icon.image = UIImage.loadImage(name: "arrow_down", any: classForCoder)
                }
                if language == .en {
                    self.setCompareText(name: name.rawValue, compare: compareText.rawValue)
                } else {
                    self.setCompareText(name: name.ch, compare: compareText.ch)
                }

            }

        }
    }
    
    private var attributeText: NSAttributedString? {
        didSet {
            chart.averageNumLabel.attributedText = attributeText
        }
        
    }
    
    private var mainColor: UIColor = UIColor.colorWithHexString(hexColor: "EAECF1") {
        willSet {
            chart.currentBarColor = newValue
        }
    }
    
    public var unitText:String = "ms" {
        willSet {
            chart.unitText = newValue
        }
    }
    
    private var lastSevenTime = "Last 7 times" {
        willSet {
            chart.lastSevenTime = newValue
        }
    }
    
    private var meditationTime = 0 {
        willSet {
            chart.meditationTime = newValue
        }
    }
    
    private var averageText = "Average" {
        willSet {
            chart.averageText = newValue
        }
    }
    
    private var textBgColor: UIColor = ColorExtension.bgZ2 {
        willSet {
            bgLabel.backgroundColor = newValue
        }
    }
    
    private var numTextColor: UIColor = .white {
        willSet {
            chart.numTextColor = newValue
        }
    }
    
    private var numBgColor: UIColor = .gray {
        willSet {
            chart.numBgColor = newValue
        }
    }
    
    private var barColor: UIColor = .white {
        willSet {
            chart.barColor = newValue
        }
    }
    
    public var language: LanguageEnum = .en
    
    public var categoryName: AverageName = .Meditation {
        willSet {
            chart.barColor = ColorExtension.lineLight
            chart.numBgColor = newValue.textBackground
            chart.numTextColor = newValue.textColor
            bgLabel.backgroundColor = ColorExtension.bgZ2
            chart.averageText = "Average"
            chart.lastSevenTime = "Last 7 times"
            chart.currentBarColor = newValue.theme
            icon.tintColor = newValue.theme
            chart.unitText = newValue.unit
        }
    }
    
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
            $0.height.equalTo(259)
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
    
    func setCompareText(name: String, compare: String) {
        var text = ""
        switch language {
        case .en:
            text = "The " + name + " is " + compare + " the average of last 7 times."
        case .ch:
            text = "本次" + name + compare + "过去7次的平均值"
        }
        
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
