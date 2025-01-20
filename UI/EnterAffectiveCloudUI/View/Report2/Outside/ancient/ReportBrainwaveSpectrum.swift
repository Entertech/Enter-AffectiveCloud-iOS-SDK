//
//  ReportBrainwaveSpectrum.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/20.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts

public class PrivateReportBrainwaveSpectrum: UIView {
    
    public var corner: CGFloat = 0 {
        willSet {
            self.layer.cornerRadius = newValue
        }
    }
    
    public var colorArray: [UIColor] = [UIColor.colorWithHexString(hexColor: "#FF6682"),
                                 UIColor.colorWithHexString(hexColor: "#FB9C98"),
                                 UIColor.colorWithHexString(hexColor: "#F7C77E"),
                                 UIColor.colorWithHexString(hexColor: "5FC695"),
                                 UIColor.colorWithHexString(hexColor: "#5E75FF")
        ] {
        willSet {
            guard newValue.count == 5 else {
                return
            }
            for i in 0..<5 {
                dots[i].backgroundColor = newValue[i]
            }
        }
    }
    
    public var values: [Float]? {
        willSet {
            guard newValue?.count == 5 else {
                return
            }
            if newValue![0] == 0 && newValue![1] == 0 {
                for i in 0...4 {
                    texts[i].text = spectrums[i] + waveText + " " + "0%"
                }
                chartView.isHidden = true
                roundView.isHidden = true
            } else {
                chartView.isHidden = false
                roundView.isHidden = false
                var value5 = 100
                for i in 0..<4 {
                    value5 = value5 - lroundf(newValue![i]*100)
                    texts[i].text = spectrums[i] + waveText + " " + "\(lroundf(newValue![i]*100))%"
                }
                texts[4].text = spectrums[4] + waveText + " " + "\(Int(value5))%"
                setDataCount(values: newValue!)
            }
        }
    }
    public var waveText = "wave"
    public var bgColor: UIColor = .white {
        willSet {
            roundView.backgroundColor = newValue
            //self.backgroundColor = newValue
        }
    }
    private let roundView = UIView()
    private let chartView: PieChartView = PieChartView()
    private let dots: [UIView] = [UIView(), UIView(), UIView(), UIView(), UIView()]
    private let texts: [UILabel] = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
    private let spectrums = ["γ ", "β ", "α ", "θ ", "δ "]
    
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
        for i in 0..<5 {

            dots[i].snp.makeConstraints {
                $0.width.height.equalTo(10)
                $0.top.equalToSuperview().offset(46 + i * 29)
                $0.right.equalToSuperview().offset(-110)
            }

            texts[i].snp.makeConstraints {
                $0.left.equalTo(dots[i].snp.right).offset(4)
                $0.centerY.equalTo(dots[i].snp.centerY)
            }
        }
        roundView.snp.makeConstraints {
            $0.center.equalTo(chartView.snp.center)
            $0.width.height.equalTo(90)
        }
        chartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.width.height.equalTo(200)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(218)
        }
    }

    
    func initFunction() {
        self.backgroundColor = .clear
        
        for i in 0..<5 {
            self.addSubview(dots[i])
            self.addSubview(texts[i])
            dots[i].backgroundColor = colorArray[i]
            dots[i].layer.cornerRadius = 5
            texts[i].font = UIFont.systemFont(ofSize: 12)
        }
        
        self.addSubview(chartView)
        chartView.legend.enabled = false
        chartView.backgroundColor = .clear
        chartView.entryLabelColor = .clear
        chartView.drawCenterTextEnabled = false
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.isUserInteractionEnabled = false
        
        self.addSubview(roundView)
        roundView.layer.cornerRadius = 45
        roundView.backgroundColor = .clear
        self.bringSubviewToFront(roundView)
    }
    
    func setDataCount(values: [Float]) {
        let entries = values.map { (value) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(value))
        }
        let set = PieChartDataSet(entries: entries)
        set.drawIconsEnabled = false
        set.drawValuesEnabled = false
        set.sliceSpace = 0
        set.colors = colorArray
        
        let data = PieChartData(dataSet: set)
        chartView.data = data
        
        chartView.highlightValue(nil)
        
    }
    
}
