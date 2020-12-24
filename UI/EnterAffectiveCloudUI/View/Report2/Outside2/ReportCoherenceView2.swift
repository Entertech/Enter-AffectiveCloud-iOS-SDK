//
//  ReportHRVView2.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/1.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class ReportCoherenceView2: UIView {
    
    /// coherence time
    public var currentTime: Int = 0 {
        willSet {
            let left = newValue/60
            let remainder = newValue%60

            coherenceTimeLabel.text = "\(left)min \(remainder)s"
                
            
        }
    }
    public var minText: String = "Time(min)" {
        willSet {
            minLabel.text = newValue
        }
    }
    
    public var coherenceText: String = "Coherence Time" {
        willSet {
            coherenceLabel.text = newValue
        }
    }
    
    public var coherenceList: [Int]? {
        willSet {
            if let list = newValue {
                chartView.setPadding(list: list)
            }
        }
    }
    
    public var hrList: [Int]? {
        willSet {
            if let list = newValue {
                chartView.setData(list: list)
            }
        }
    }
    
    public var uploadCycle = 0 {
        willSet {
            chartView.uploadCycle = UInt(newValue)
        }
    }
    

    private var coherenceColor = UIColor.colorWithHexString(hexColor: "#5FC695")
    private var textColor = ColorExtension.textLv1
    private var axisLabelColor = ColorExtension.textLv2
    private var xAxisLineColor = ColorExtension.textLv1
    private var gridLineColor = ColorExtension.lineLight
    
    private let coherenceLabel = UILabel()
    private let coherenceTimeLabel = UILabel()
    private let chartView = HRChart()
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
        coherenceLabel.text = "Coherence Time"
        coherenceLabel.font = UIFont.systemFont(ofSize: 14)
        
        coherenceTimeLabel.textColor = coherenceColor
        coherenceTimeLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        coherenceTimeLabel.text = "0min 0s"
        minLabel.textColor = textColor
        minLabel.font = UIFont.systemFont(ofSize: 12)
        minLabel.textAlignment = .center
        minLabel.text = minText
        
        chartView.isNeedLeftLabel = false
        
        setLayout()
    }
    
    private func setLayout() {
        coherenceLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(12)
        }
        
        coherenceTimeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(coherenceLabel.snp.bottom).offset(4)
        }
        
        chartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalTo(minLabel.snp.top).offset(-6)
        }
        
        minLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
    }
    

}
