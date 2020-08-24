//
//  ReportModel.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public struct ReportModel {
    public init() {
    }
    
    public var gama: [Float]?
    public var delta: [Float]?
    public var theta: [Float]?
    public var alpha: [Float]?
    public var beta: [Float]?
    
    public var brainwave: Array2D<Float>?
    public mutating func brainwaveMapping(_ gama: [Float], _ delta: [Float], _ theta: [Float], _ alpha: [Float], _ beta: [Float]) {
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

    
    public var heartRate: [Int]?
    public var heartRateAvg: Int?
    public var heartRateMax: Int?
    public var heartRateMin: Int?
    
    public var heartRateVariability: [Int]?
    public var hrvAvg: Float?
    
    public var attention: [Int]?
    public var attentionAvg: Int?
    public var attentionMax: Int?
    public var attentionMin: Int?
    
    public var relaxation: [Int]?
    public var relaxationAvg: Int?
    public var relaxationMax: Int?
    public var relaxationMin: Int?
    
    private var _pressure: [Float]?
    public var pressure: [Float]? {
        get {
            return _pressure
        }
        set {
             
            _pressure = newValue
            
        }
    }
    
    public var timestamp: Int?
}
