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
    let rhythms = ReportBrainwaveRhythms()
    let rhythms2 = ReportBrainwaveRhythms()
    let rhythms3 = ReportBrainwaveRhythms()
//    let bar = AffectiveCharts3CandleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.addArrangedSubview(contentView)
        stackView.addArrangedSubview(contentView2)
        stackView.addArrangedSubview(contentView3)
        contentView.snp.makeConstraints {
            $0.height.equalTo(311)
        }
        contentView2.snp.makeConstraints {
            $0.height.equalTo(311)
        }
        contentView3.snp.makeConstraints {
            $0.height.equalTo(311)
        }

        contentView.addSubview(rhythms)
        rhythms.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rhythms.gamaColor = .clear
        rhythms.betaColor = UIColor.colorWithHexString(hexColor: "#FF6682")
        rhythms.gamaEnable = true
        rhythms.betaEnable = true
        rhythms.deltaEnable = true
        rhythms.alphaEnable = true
        rhythms.thetaEnable = true
        rhythms.setContentHidden(list: [0])

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
                        rhythms.uploadCycle = 1
                        rhythms.setData(gamaList: gamma, betaList: beta, alphaList: alpha, thetaList: theta, deltaList: delta)
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
