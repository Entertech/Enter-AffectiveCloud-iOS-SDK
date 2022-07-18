//
//  ThirdVersionViewController.swift
//  EnterReportUIDemo
//
//  Created by Enter on 2022/6/14.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
import EnterAffectiveCloudUI
import SnapKit

class ThirdVersionViewController: UIViewController {

    let contentView = UIView()
    let common = AffectiveCharts3Pressure()
//    let rhythms = AffectiveCharts3StackView()
    let bar = AffectiveCharts3CandleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vcViewHeight = self.view.frame.height
        self.view.addSubview(contentView)
        
        self.view.addSubview(common)
//        self.view.addSubview(rhythms)
        self.contentView.addSubview(bar)
        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(311)
        }
        common.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(64)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(contentView.snp.bottom)
            $0.height.equalTo(self.view.snp.height).multipliedBy(271.0/vcViewHeight)
        }
        
//        rhythms.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(8)
//            $0.trailing.equalToSuperview().offset(-16)
//            $0.top.equalTo(common.snp.bottom).offset(16)
//            $0.height.equalTo(273)
//        }
        
        bar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
        if let samplePath = samplePath {
            let service = ChartService()
            service.dataOfReport = ReportFileHander.readReportFile(samplePath)
            let timeStamp = TimeInterval(service.model.timestamp ?? Int(Date().timeIntervalSince1970))
            
            var commonTheme = AffectiveChart3Theme()

            commonTheme.startTime = timeStamp
            commonTheme.endTime = commonTheme.startTime
            commonTheme.themeColor = .green
            commonTheme.averageValue = "\(service.model.attentionAvg ?? 10)"
            commonTheme.style = .session
//            commonTheme.tagValue = "low"
//            commonTheme.tagColor = .green.changeAlpha(to: 0.2)
//            commonTheme.tagTextColor = .black
            commonTheme.chartName = "ATTENTION"
//            commonTheme.tagSeparation = [0, 30, 70, 100]
            
            
            if let attention = service.model.attention {
                var tmp: [Int] = []
                
                for e in attention {
                    if e > 60 {
                        tmp.append(1)
                    } else {
                        tmp.append(0)
                    }
                }
                
                common.setTheme(commonTheme)
                    .setLayout()
                    .setData(attention)
                    .setChartProperty()
                    .setMarker()
                    .build()
            }
            
            guard let gamma = service.model.gama?.map({ value in
                return Double(value*100)
            }) else {return}
            guard let beta = service.model.beta?.map({ value in
                return Double(value*100)
            }) else {return}
            guard let alpha = service.model.alpha?.map({ value in
                return Double(value*100)
            }) else {return}
            guard let theta = service.model.theta?.map({ value in
                return Double(value*100)
            }) else {return}
            guard let delta = service.model.delta?.map({ value in
                return Double(value*100)
            }) else {return}
//
//
//            rhythms
//                .setParam(type: .year, startDate: Date.init(timeIntervalSince1970: timeStamp))
//                .setRhythmLineEnable(value: 28)
//                .build(gamma: gamma, beta: beta, alpha: alpha, theta: theta, delta: delta)
//
            var values = [Double]()
            var min = [Double]()
            var max = [Double]()
            for (i, e) in alpha.enumerated() {
                if i > 60 {
                    break
                }
                let random = Int.random(in: 0...1)
                if random > 0 {
                    values.append(e)
                    min.append(delta[i])
                    max.append(beta[i])
                } else {
                    values.append(0.0)
                    min.append(0.0)
                    max.append(0.0)
                }
            }
            var barTheme = AffectiveChart3Theme()
            barTheme.style = .month
            barTheme.themeColor = .red
            barTheme.startTime = timeStamp
            barTheme.endTime = timeStamp
            barTheme.chartName = "Heart Rate".uppercased()
            barTheme.averageValue = "\(service.model.heartRateAvg ?? 0)"
            barTheme.unitText = "bpm"
            var minAndMax = Array2D(columns: min.count, rows: 2, initialValue: 0.0)
            for (index, e) in min.enumerated() {
                minAndMax[index, 0] = e
            }
            for (index, e) in max.enumerated() {
                minAndMax[index, 1] = e
            }
            bar.setTheme(barTheme)
                .setProperty()
                .setLayout()
                .build(candle: minAndMax, average: values)
//            if let relaxation = service.model.relaxation {
//                let array = relaxation.map { v in
//                    Double(v)
//                }
//                bar.setTheme(barTheme)
//                    .setProperty()
//                    .setLayout()
//                    .build(array: array)
//            }

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
