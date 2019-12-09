//
//  ReportViewService.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloud

public class ReportViewService: NSObject {
    
    public var model: ReportModel = ReportModel()
    public var heartRateView: HeartRateReportView?
    public var hrvView: HeartRateVariablityReportView?
    public var braveWaveView: BrainSpecturmReportView?
    public var attentionView: AttentionReportView?
    public var relaxationView: RelaxationReportView?
    public var pressureView: PressureReportView?
    
    private var isShowed: Bool = false
    
    public var dataOfReport: EnterAffectiveCloud.EnterAffectiveCloudReportData? {
        willSet {
            if let scalars = newValue?.scalars {
                for e in scalars {
                    switch e.type {

                    case .hrAverage:
                        model.heartRateAvg = Int(e.value)
                    case .hrMax:
                        model.heartRateMax = Int(e.value)
                    case .hrMin:
                        model.heartRateMin  = Int(e.value)
                    case .hrvAverage:
                        model.hrvAvg = Int(e.value)
                    case .attentionAverage:
                        model.attentionAvg = Int(e.value)
                    case .attentionMax:
                        model.attentionMax = Int(e.value)
                    case .attentionMin:
                        model.attentionMin = Int(e.value)
                    case .relaxAverage:
                        model.relaxationAvg = Int(e.value)
                    case .relaxMax:
                        model.relaxationMax = Int(e.value)
                    case .relaxMin:
                        model.relaxationMin = Int(e.value)
                    case .timestamp:
                        model.timestamp = Int(e.value)
                    default:
                        break
                    }
                }
            }
            var alphaArray: [Float]?
            var betaArray: [Float]?
            var thetaArray: [Float]?
            var deltaArray: [Float]?
            var gamaArray: [Float]?
            
            if let digitals = newValue?.digitals {
                for e in digitals {
                    switch e.type {
                    case .alpha:
                        alphaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .belta:
                        betaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .theta:
                        thetaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .delta:
                        deltaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .gamma:
                        gamaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .hr:
                        let arrayTemp = (e.bodyDatas.to(arrayType: Float.self))?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 120 {
                                tmp = 120
                            } else if value < 30 {
                                tmp = 30
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        if let array = arrayTemp {
                            model.heartRate = array
                        }
                        
                    case .hrv:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 150 {
                                tmp = 150
                            } else if value < 0 {
                                tmp = 0
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        
                        if let array = arrayTemp {
                            model.heartRateVariability = array
                        }
                    case .attention:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 100 {
                                tmp = 100
                            } else if value < 0 {
                                tmp = 0
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        
                        if let array = arrayTemp {
                            model.attentionMax = array.max()
                            model.attentionMin = array.filter{ $0>0 }.min() ?? 0
                            model.attention = array
                        }
                    case .relax:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 100 {
                                tmp = 100
                            } else if value < 0 {
                                tmp = 0
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        if let array = arrayTemp {
                            model.relaxationMax = array.max()
                            model.relaxationMin = array.filter{ $0>0 }.min() ?? 0
                            model.relaxation = array
                        }
                    case .pressure:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)
                        if let array = arrayTemp {
                            model.pressure = array
                        }
                        
                    default:
                        break
                    }
                }
            }
            if let alpha = alphaArray, let beta = betaArray, let theta = thetaArray, let delta = deltaArray, let gama = gamaArray {
                //model.brainwaveMapping(gama, delta, theta, alpha, beta)
                model.alpha = alpha
                model.beta = beta
                model.theta = theta
                model.delta = delta
                model.gama = gama
            }
            
        }
    }
    /// 展示添加的视图，必须在layout之后
    public func show(object: UIViewController) {
        if !isShowed {
            if let alpha = model.alpha, let beta = model.beta, let theta = model.theta, let delta = model.delta, let gama = model.gama {
                self.braveWaveView?.setDataFromModel(gama: gama, delta: delta, theta: theta, alpha: alpha, beta: beta)
            }
            self.heartRateView?.setDataFromModel(hr: model.heartRate, timestamp: model.timestamp)
            self.heartRateView?.avgValue = model.heartRateAvg!
            self.heartRateView?.maxValue = model.heartRateMax!
            self.heartRateView?.minValue = model.heartRateMin!
            self.hrvView?.setDataFromModel(hrv: model.heartRateVariability)
            self.hrvView?.avgValue = model.hrvAvg!
            self.attentionView?.setDataFromModel(attention: model.attention)
            self.attentionView?.maxValue = model.attentionMax!
            self.attentionView?.minValue = model.attentionMin!
            self.attentionView?.avgValue = model.attentionAvg!
            self.relaxationView?.setDataFromModel(relaxation: model.relaxation, timestamp: model.timestamp)
            self.relaxationView?.maxValue = model.relaxationMax!
            self.relaxationView?.minValue = model.relaxationMin!
            self.relaxationView?.avgValue = model.relaxationAvg!
            self.pressureView?.setDataFromModel(pressure: model.pressure)
            isShowed = true
            object.view.layoutIfNeeded()
        }
        
    }

}
