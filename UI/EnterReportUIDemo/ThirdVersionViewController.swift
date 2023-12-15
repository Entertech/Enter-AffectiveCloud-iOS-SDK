//
//  ThirdVersionViewController.swift
//  EnterReportUIDemo
//
//  Created by Enter on 2022/6/14.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import EnterAffectiveCloud
import EnterAffectiveCloudUI
import HandyJSON
import SnapKit
import UIKit
import Accelerate

class Power: HandyJSON {
    required init() {
    }

    var gamma: [Float]?
    var beta: [Float]?
    var alpha: [Float]?
    var theta: [Float]?
    var delta: [Float]?
}

class ThirdVersionViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!
    let contentView = UIView()
    let contentView2 = UIView()
    let contentView3 = UIView()
//    let common = AffectiveCharts3Pressure()
    let rhythms = AffectiveChartsSleepBrainwaveView()
    let rhythms2 = ReportBrainwaveRhythms()
    let rhythms3 = ReportBrainwaveRhythms()
    let bar = AffectiveCharts3BarCommonView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.addArrangedSubview(contentView)
        stackView.addArrangedSubview(contentView2)
        stackView.addArrangedSubview(contentView3)
        contentView.snp.makeConstraints {
            $0.height.equalTo(190)
        }
        contentView2.snp.makeConstraints {
            $0.height.equalTo(311)
        }
        contentView3.snp.makeConstraints {
            $0.height.equalTo(311)
        }

        contentView.addSubview(bar)
        bar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        var theme = AffectiveChart3Theme()
        theme.averageValue = "10"
        theme.startTime = 1635221841
        theme.endTime = 1664165841
        theme.chartName = "add"
        theme.themeColor = .red
        theme.chartType = .coherece
        theme.style = .year
        contentView.addSubview(rhythms)
        rhythms.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let param = AffectiveChartsSleepParameter()
        var gammaArray: [Double] = []
        var betaArray: [Double] = []
        var alphaArray: [Double] = []
        var thetaArray: [Double] = []
        var deltaArray: [Double] = []
        for index in 0..<54 {
            gammaArray.append(Double(Int.random(in: 8..<15)))
            betaArray.append(Double(Int.random(in: 12..<18)))
            alphaArray.append(Double(Int.random(in: 16..<35)))
            thetaArray.append(Double(Int.random(in: 15..<25)))
            deltaArray.append(Double(Int.random(in: 8..<12)))
        }
        let start = Date().timeIntervalSince1970
        let end = start + Double(gammaArray.count * 300)
        param.start = start
        param.end = end
        param.lineColors = [UIColor.colorWithHexString(hexColor: "#FF6682"),
                            UIColor.colorWithHexString(hexColor: "#3479FF"),
                            UIColor.colorWithHexString(hexColor: "#FFC56F"),
                            UIColor.colorWithHexString(hexColor: "#5FC695"),
                            UIColor.colorWithHexString(hexColor: "#8B7AF3"),
                            .lightGray, UIColor.colorWithHexString(hexColor: "#F2F2F7")]
        param.xAxisLabelColor = UIColor.colorWithHexString(hexColor: "#A6A7AF")
        param.xAxisLineColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
        param.xGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
        param.yAxisLabelColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
        param.yGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
        rhythms.setData(gamma: gammaArray, beta: betaArray, alpha: alphaArray, theta: thetaArray, delta: deltaArray, param: param)
            .stepTwoSetLayout()
            .build()
        

        contentView2.addSubview(rhythms2)
        rhythms2.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rhythms2.gamaColor = .clear
        rhythms2.betaColor = UIColor.colorWithHexString(hexColor: "#FF6682")
        rhythms2.gamaEnable = true
        rhythms2.betaEnable = true
        rhythms2.deltaEnable = true
        rhythms2.alphaEnable = true
        rhythms2.thetaEnable = true
        rhythms2.setContentHidden(list: [0])

        contentView3.addSubview(rhythms3)
        rhythms3.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rhythms3.gamaColor = .clear
        rhythms3.betaColor = UIColor.colorWithHexString(hexColor: "#FF6682")
        rhythms3.gamaEnable = true
        rhythms3.betaEnable = true
        rhythms3.deltaEnable = true
        rhythms3.alphaEnable = true
        rhythms3.thetaEnable = true
        rhythms3.setContentHidden(list: [0])

        if let samplePath = Bundle.main.path(forResource: "eeg_power", ofType: "json") {
            if let text = try? String(contentsOfFile: samplePath, encoding: .utf8) {
                let model = Power.deserialize(from: text)
                var halfSmoothLen = 9
                var sample = 5
                for loop in 0 ..< 3 {
                    var gamma = [Float]()
                    var beta = [Float]()
                    var alpha = [Float]()
                    var theta = [Float]()
                    var delta = [Float]()
                    
                    if loop == 0 {
                        sample = 1
                        let recLen = model?.gamma?.count ?? 0
                        let tmp = recLen / 100
                        let max = tmp > 16 ? tmp : 16
                        let min = max > recLen ? recLen : max
                        halfSmoothLen = min
                        
                    } else if loop == 1 {
                        sample = 2
                    } else if loop == 2 {
                        sample = 3
                    }
                    if let list = model?.gamma {
                        var sampleList = [Float]()
                        for i in stride(from: 0, to: list.count, by: sample) {
                            sampleList.append(list[i])
                        }
                        var curveExpand = [Float]()
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.first ?? 0, count: halfSmoothLen))
                        curveExpand.append(contentsOf: sampleList)
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.last ?? 0, count: halfSmoothLen))
                        var curve = Array.init(repeating: Float(0.0), count: sampleList.count)
                        for (index, e) in sampleList.enumerated() {
                            curve[index] = vDSP.mean(Array(curveExpand[index...index+halfSmoothLen*2]))

                        }
                        curve.removeFirst(90)
                        gamma.append(contentsOf: curve)

                    }
                    if let list = model?.beta {
                        var sampleList = [Float]()
                        for i in stride(from: 0, to: list.count, by: sample) {
                            sampleList.append(list[i])
                        }
                        var curveExpand = [Float]()
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.first ?? 0, count: halfSmoothLen))
                        curveExpand.append(contentsOf: sampleList)
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.last ?? 0, count: halfSmoothLen))
                        var curve = Array.init(repeating: Float(0.0), count: sampleList.count)
                        for (index, e) in sampleList.enumerated() {
                            curve[index] = vDSP.mean(Array(curveExpand[index...index+halfSmoothLen*2]))

                        }
                        curve.removeFirst(45)
                        beta.append(contentsOf: curve)
                      
                    }
                    if let list = model?.alpha {
                        var sampleList = [Float]()
                        for i in stride(from: 0, to: list.count, by: sample) {
                            sampleList.append(list[i])
                        }
                        var curveExpand = [Float]()
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.first ?? 0, count: halfSmoothLen))
                        curveExpand.append(contentsOf: sampleList)
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.last ?? 0, count: halfSmoothLen))
                        var curve = Array.init(repeating: Float(0.0), count: sampleList.count)
                        for (index, e) in sampleList.enumerated() {
                            curve[index] = vDSP.mean(Array(curveExpand[index...index+halfSmoothLen*2]))

                        }
                        curve.removeFirst(30)
                        alpha.append(contentsOf: curve)
                   
                    }
                    if let list = model?.theta {
                        var sampleList = [Float]()
                        for i in stride(from: 0, to: list.count, by: sample) {
                            sampleList.append(list[i])
                        }
                        var curveExpand = [Float]()
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.first ?? 0, count: halfSmoothLen))
                        curveExpand.append(contentsOf: sampleList)
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.last ?? 0, count: halfSmoothLen))
                        var curve = Array.init(repeating: Float(0.0), count: sampleList.count)
                        for (index, e) in sampleList.enumerated() {
                            curve[index] = vDSP.mean(Array(curveExpand[index...index+halfSmoothLen*2]))

                        }
                        theta.append(contentsOf: curve)
                    }
                    if let list = model?.delta {
                        var sampleList = [Float]()
                        for i in stride(from: 0, to: list.count, by: sample) {
                            sampleList.append(list[i])
                        }
                        var curveExpand = [Float]()
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.first ?? 0, count: halfSmoothLen))
                        curveExpand.append(contentsOf: sampleList)
                        curveExpand.append(contentsOf: Array.init(repeating: sampleList.last ?? 0, count: halfSmoothLen))
                        var curve = Array.init(repeating: Float(0.0), count: sampleList.count)
                        for (index, e) in sampleList.enumerated() {
                            curve[index] = vDSP.mean(Array(curveExpand[index...index+halfSmoothLen*2]))

                        }
                        delta.append(contentsOf: curve)
                        
                    }
                    if loop == 0 {
                        
                        
//                        rhythms.uploadCycle = 1
//                        rhythms.setData(gamaList: gamma, betaList: beta, alphaList: alpha, thetaList: theta, deltaList: delta)
                    } else if loop == 1 {
                        rhythms2.uploadCycle = 1
                        rhythms2.setData(gamaList: gamma, betaList: beta, alphaList: alpha, thetaList: theta, deltaList: delta)
                    } else if loop == 2 {
                        rhythms3.uploadCycle = 1
                        rhythms3.setData(gamaList: gamma, betaList: beta, alphaList: alpha, thetaList: theta, deltaList: delta)
                    }
                }
            }
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
