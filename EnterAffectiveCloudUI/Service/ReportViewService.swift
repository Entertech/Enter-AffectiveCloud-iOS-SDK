//
//  ReportViewService.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class ReportViewService: NSObject {
    
    public var model: ReportModel? = ReportModel()
    
    public var dataOfReport: EnterAffectiveCloudReportData? {
        willSet {
            if let scalars = newValue?.scalars {
                for e in scalars {
                    switch e.type {

                    case .hrAverage:
                        model?.heartRateAvg = Int(e.value)
                    case .hrMax:
                        model?.heartRateMax = Int(e.value)
                    case .hrMin:
                        model?.heartRateMin  = Int(e.value)
                    case .hrvAverage:
                        model?.hrvAvg = Int(e.value)
                    case .attentionAverage:
                        model?.attentionAvg = Int(e.value)
                    case .attentionMax:
                        model?.attentionMax = Int(e.value)
                    case .attentionMin:
                        model?.attentionMin = Int(e.value)
                    case .relaxAverage:
                        model?.relaxationAvg = Int(e.value)
                    case .relaxMax:
                        model?.relaxationMax = Int(e.value)
                    case .relaxMin:
                        model?.relaxationMin = Int(e.value)
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
                            model?.heartRate = array
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
                            model?.heartRateVariability = array
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
                            model?.attentionMax = array.max()
                            model?.attentionMin = array.filter{ $0>0 }.min() ?? 0
                            model?.attention = array
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
                            model?.relaxationMax = array.max()
                            model?.relaxationMin = array.filter{ $0>0 }.min() ?? 0
                            model?.relaxation = array
                        }
                    case .pressure:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)
                        if let array = arrayTemp {
                            model?.pressure = array
                        }
                        
                    default:
                        break
                    }
                }
            }
            if let alpha = alphaArray, let beta = betaArray, let theta = thetaArray, let delta = deltaArray, let gama = gamaArray {
                model?.brainwaveMapping(gama, delta, theta, alpha, beta)
            }
            
        }
    }

}
