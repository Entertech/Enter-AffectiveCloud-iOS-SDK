//
//  ReportHRVView2.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/1.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class ReportHRVView2: UIView {
    
    public var currentTime: Int = 0 {
        willSet {
            let left = currentTime/60
            let remainder = currentTime%60
            if remainder > 0 {
                coherenceTimeLabel.text = "\(remainder)min \(left)s"
                
            } else {
                coherenceTimeLabel.text = "\(left)s"
            }
        }
    }
    public var minText: String = "Time(min)" {
        willSet {
            minLabel.text = newValue
        }
    }
    
    public var coherenceText: String = "Coherence Time:" {
        willSet {
            coherenceLabel.text = newValue
        }
    }
    
    public var coherenceList: [Int]? {
        willSet {
            if let list = newValue {
                chartView.setData(list: list)
            }
        }
    }
    
    public var hrvList: [Int]? {
        willSet {
            if let list = newValue {
                chartView.setData(list: list)
            }
        }
    }

    private var coherenceColor = UIColor.colorWithHexString(hexColor: "#5FC695")
    private var textColor = ColorExtension.textLv1
    private var axisLabelColor = ColorExtension.textLv2
    private var xAxisLineColor = ColorExtension.textLv1
    private var gridLineColor = ColorExtension.lineLight
    
    private let coherenceLabel = UILabel()
    private let coherenceTimeLabel = UILabel()
    private let chartView = HRVChart()
    private let minLabel = UILabel()
    
    public init() {
        super.init(frame: CGRect.zero)
        setUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.addSubview(chartView)
        self.addSubview(coherenceLabel)
        self.addSubview(coherenceTimeLabel)
        self.addSubview(minLabel)
        
        coherenceLabel.textColor = textColor
        coherenceLabel.text = "Coherence Time:"
        coherenceLabel.font = UIFont.systemFont(ofSize: 14)
        
        coherenceTimeLabel.textColor = coherenceColor
        coherenceTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        minLabel.textColor = textColor
        minLabel.font = UIFont.systemFont(ofSize: 12)
        minLabel.textAlignment = .center
        minLabel.text = minText
        
        setLayout()
    }
    
    private func setLayout() {
        coherenceLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(12)
        }
        
        coherenceTimeLabel.snp.makeConstraints {
            $0.left.equalTo(coherenceLabel.snp.right).offset(6)
            $0.centerY.equalTo(coherenceLabel.snp.centerY).offset(-2)
        }
        
        chartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(minLabel.snp.top).offset(-12)
        }
        
        minLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
        
    }
    

}
