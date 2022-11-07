//
//  AverageOfSevenDayView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/23.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class PrivateAverageOfSevenDayView: UIView {
    
    public var valuesSpect: [Int] = [] {
        willSet {

                for i in 0..<valueViews.count {
                    valueViews[i].removeFromSuperview()
                    valueLabels[i].removeFromSuperview()
                }
                valueViews.removeAll()
                valueLabels.removeAll()
                _values = newValue
                //let total = newValue.reduce(0, +)
                //averageValue = lroundf(Float(total) / Float(newValue.count))
                for (i,_) in newValue.enumerated() {
                    let bar = UIView()
                    let numLabel = UILabel()
                    // 设置bar
                    if i == 0 {
                        bar.backgroundColor = currentBarColor
                        numLabel.backgroundColor = numBgColor
                    } else {
                        bar.backgroundColor = barColor
                        numLabel.isHidden = true
                    }
                    
                    bar.layer.cornerRadius = 4
                    bar.layer.masksToBounds = true
                    valueViews.append(bar)
                    
                    // 设置bar上面的label
                    numLabel.font = UIFont.systemFont(ofSize: 11)
                    numLabel.text = String.init(format: "%d", Int(ceil(Double(newValue[i]) / 60.0)))
                    numLabel.layer.cornerRadius = 4
                    numLabel.layer.masksToBounds = true
                    numLabel.textAlignment = .center
                    numLabel.textColor = numTextColor
                    valueLabels.append(numLabel)
                }
                barLayout()
        }
    }
    
    public var values: [Int] = [] {
        willSet {
                
                for i in 0..<valueViews.count {
                    valueViews[i].removeFromSuperview()
                    valueLabels[i].removeFromSuperview()
                }
                valueViews.removeAll()
                valueLabels.removeAll()
                _values = newValue
                //let total = newValue.reduce(0, +)
                //averageValue = lroundf(Float(total) / Float(newValue.count))
                for (i,e) in newValue.enumerated() {
                    let bar = UIView()
                    let numLabel = UILabel()
                    // 设置bar
                    if i == (newValue.count-1) {
                        bar.backgroundColor = currentBarColor
                        numLabel.backgroundColor = numBgColor
                    } else {
                        bar.backgroundColor = barColor
                        numLabel.isHidden = true
                    }
                    
                    bar.layer.cornerRadius = 4
                    bar.layer.masksToBounds = true
                    valueViews.append(bar)
                    
                    // 设置bar上面的label
                    numLabel.font = UIFont.systemFont(ofSize: 11)
      
                    numLabel.layer.cornerRadius = 4
                    numLabel.layer.masksToBounds = true
                    numLabel.textAlignment = .center
                    numLabel.textColor = numTextColor
                    valueLabels.append(numLabel)
                }
                barLayout()
        }
    }
    
    public var floatValues: [Float] = [] {
        willSet {
                for i in 0..<valueViews.count {
                    valueViews[i].removeFromSuperview()
                    valueLabels[i].removeFromSuperview()
                }
                valueViews.removeAll()
                valueLabels.removeAll()
                _floatValues = newValue
                let total = newValue.reduce(0, +)
                averageFloatValue = Float(total) / Float(newValue.count)
                for (i,e) in newValue.enumerated() {
                    let bar = UIView()
                    let numLabel = UILabel()
                    // 设置bar
                    if i == (newValue.count-1) {
                        bar.backgroundColor = currentBarColor
                        numLabel.backgroundColor = numBgColor
                    } else {
                        bar.backgroundColor = barColor
                        numLabel.isHidden = true
                    }
                    
                    bar.layer.cornerRadius = 4
                    bar.layer.masksToBounds = true
                    valueViews.append(bar)
                    
                    // 设置bar上面的label
                    numLabel.font = UIFont.systemFont(ofSize: 11)
                    numLabel.text = String.init(format: "%.1f", e)
                    numLabel.layer.cornerRadius = 4
                    numLabel.layer.masksToBounds = true
                    numLabel.textAlignment = .center
                    numLabel.textColor = numTextColor
                    valueLabels.append(numLabel)
                }
                barLayout()
        }
    }
    
    public var currentBarColor: UIColor = UIColor.colorWithHexString(hexColor: "FF6682")  {
        willSet {
            if let view = valueViews.first {
                view.backgroundColor = newValue
            }
            self.averageLine.backgroundColor = newValue
        }
    }
    
    public var meditationTime: Int = 0 {
        willSet {
            meditationTimeLabel.text = "\(newValue)min"
        }
    }
    
    public var unitText = "ms" {
        willSet {
            unitLabel.text = newValue
        }
    }
    
    public var averageText = "Average" {
        willSet {
            averageLabel.text = newValue
        }
    }
    
    public var lastSevenTime = "Last 7 times" {
        willSet {
            lastLabel.text = newValue
        }
    }
    
    public var barColor = UIColor.colorWithHexString(hexColor: "eaecf1")
    
    public var numBgColor: UIColor = .gray
    
    public var numTextColor: UIColor = .white
    
    public var numTextFont: UIFont? {
        willSet {
            averageNumLabel.font = newValue ?? UIFont.rounded(ofSize: 24, weight: .bold)
        }
    }
    
    private var averageFloatValue:Float = 0 {
        willSet {
            averageNumLabel.text = String.init(format: "%.1f", newValue)
        }
    }
    
    public var averageValue:Int = 0 {
        willSet {
            averageNumLabel.text = "\(newValue)"
        }
    }
    private let meditationTimeLabel = UILabel()
    private var valueViews:[UIView] = []
    private var valueLabels:[UILabel] = []
    
    private let averageLine = UIView()
    private let averageLabel = UILabel()
    public let averageNumLabel = UILabel()
    public let unitLabel = UILabel()
    private let lastLabel = UILabel()
    private var _values: [Int]?
    private var _floatValues: [Float]?

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
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func initFunction() {
        self.backgroundColor = .clear
        self.addSubview(averageNumLabel)
        self.addSubview(averageLabel)
        self.addSubview(lastLabel)
        self.addSubview(unitLabel)
        self.addSubview(averageLine)
        self.addSubview(meditationTimeLabel)
        averageLine.backgroundColor = currentBarColor
        averageLine.layer.cornerRadius = 1
        averageLine.layer.masksToBounds = true
        averageLabel.text = "Average"
        averageLabel.textColor = UIColor.systemGray
        averageLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        averageNumLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        unitLabel.font = UIFont.systemFont(ofSize: 12)
        unitLabel.textColor = UIColor.systemGray
        
        lastLabel.font = UIFont.systemFont(ofSize: 12)
        lastLabel.text = "Last 7 times"
        lastLabel.textColor = UIColor.systemGray

        meditationTimeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        lastLabel.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
        }
        
        averageLine.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(3)
            
            $0.bottom.equalToSuperview().offset(-64)
            
        }
        
        averageLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalTo(averageLine.snp.top).offset(-4)
        }
        
        averageNumLabel.snp.makeConstraints {
            $0.top.equalTo(averageLine.snp.bottom).offset(4)
            $0.left.equalToSuperview()
        }
        
        unitLabel.snp.makeConstraints {
            $0.left.equalTo(averageNumLabel.snp.right)
            $0.centerY.equalTo(averageNumLabel.snp.centerY).offset(4)
        }
        
        meditationTimeLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
        }
    }
    
    func barLayout() {
        let barCount = valueViews.count
        var min: Float = 0
        var max: Float = 0
        if let valuesArray = _values {
            min = Float(valuesArray.min() ?? 0)
            max = Float(valuesArray.max() ?? 100)
        }
        if let valuesArray = _floatValues {
            min = valuesArray.min() ?? 0
            max = valuesArray.max() ?? 100
        }
//        let min = _values!.min()!
//        let max = _values!.max()!
        for i in 0..<barCount {
            //let value = _values![barCount-1-i]
            var value: Float = 0
            if let valuesArray = _values {
                value = Float(valuesArray[i])
            }
            if let valuesArray = _floatValues {
                value = valuesArray[i]
            }
            
            let label = valueLabels[barCount-1-i] // 顺序是倒着的
            let bar = valueViews[barCount-1-i]
            self.addSubview(bar)
            self.addSubview(label)
            bar.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.right.equalToSuperview().offset(-25-29*i)
                $0.width.equalTo(17)
                if max == min{
                    $0.height.equalTo(64)
                } else  {
                    $0.height.equalTo(28+Float(value-min)/Float(max-min)*100)
                }
            }
            if i == 0 {
                label.text = "\(Int(value))"
            }
            label.text = "\(Int(value))"
            label.snp.makeConstraints {
                $0.bottom.equalTo(bar.snp.top).offset(-4)
                $0.centerX.equalTo(bar.snp.centerX)
                $0.height.equalTo(14)
                $0.width.greaterThanOrEqualTo(17)
            }
        }
        
        averageLine.snp.updateConstraints {
            if max == min {
                $0.bottom.equalToSuperview().offset(-64)
            } else {
                if 28 + ((Float(averageValue)-Float(min))/Float(max-min)*100) < 46 {
                    $0.bottom.equalTo(-46)
                } else {
                    $0.bottom.equalTo(-28-((Float(averageValue)-Float(min))/Float(max-min)*100)).priority(.high)
                }
                
            }
        }
        self.bringSubviewToFront(averageLine)
        for i in 0..<barCount {
            self.bringSubviewToFront(valueLabels[i])
        }
    }
    

}
