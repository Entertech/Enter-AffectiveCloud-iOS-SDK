//
//  ReportModel.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public struct ReportModel {
    var gama: [Float]?
    var delta: [Float]?
    var theta: [Float]?
    var alpha: [Float]?
    var beta: [Float]?
    
    var brainwave: Array2D<Float>?
    mutating func brainwaveMapping(_ gama: [Float], _ delta: [Float], _ theta: [Float], _ alpha: [Float], _ beta: [Float]) {
        let arrayCount = gama.count
        var tmpArray = Array2D(columns: arrayCount, rows: 4, initialValue: Float(0.0))
        for i in 0..<arrayCount {
            let total = gama[i] + theta[i] + delta[i] + alpha[i] + beta[i]
            let set1 = delta[i] / total
            let set2 = (delta[i] + theta[i]) / total
            let set3 = (delta[i] + alpha[i] + theta[i]) / total
            let set4 = (total - gama[i]) / total
            tmpArray[i, 0] = set1 * 100
            tmpArray[i, 1] = set2 * 100
            tmpArray[i, 2] = set3 * 100
            tmpArray[i, 3] = set4 * 100
        }
        
        brainwave = tmpArray
    }

    
    var heartRate: [Int]?
    var heartRateAvg: Int?
    var heartRateMax: Int?
    var heartRateMin: Int?
    
    var heartRateVariability: [Int]?
    var hrvAvg: Int?
    
    var attention: [Int]?
    var attentionAvg: Int?
    var attentionMax: Int?
    var attentionMin: Int?
    
    var relaxation: [Int]?
    var relaxationAvg: Int?
    var relaxationMax: Int?
    var relaxationMin: Int?
    
    private var _pressure: [Float]?
    var pressure: [Float]? {
        get {
            return _pressure
        }
        set {
             
            _pressure = newValue
            
        }
    }
    
    var timestamp: Int?
}
