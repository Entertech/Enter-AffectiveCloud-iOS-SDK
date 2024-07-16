//
//  AffectiveChartsSleepModel.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/12/13.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class AffectiveChartsSleepParameter {
    public init() {}
    public var yAxisLabelColor: UIColor?
    public var xAxisLabelColor: UIColor?
    public var yGrideLineColor: UIColor?
    public var xGrideLineColor: UIColor?
    public var xAxisLineColor: UIColor?
    public var lineColors: [UIColor] = []
    public var text: [String] = []
    public var start: Double = 0
    public var end: Double = 0
}

extension Array where Element == Int {
    /// 获取出现频率最高的值
    func getMostFrequentValue() -> Int? {
        guard !self.isEmpty else { return nil }
        
        var frequencyDict = [Int: Int]()
        
        for value in self {
            frequencyDict[value, default: 0] += 1
        }
        
        if let mostFrequentValue = frequencyDict.max(by: { $0.value < $1.value })?.key {
            return mostFrequentValue
        }
        
        return nil
    }
}


extension Array where Element == Double {
    func meanOfNonZeroElements() -> Double {
        let nonZeroElements = self.filter { $0 != 0 }
        guard !nonZeroElements.isEmpty else { return 0 }
        let sum = nonZeroElements.reduce(0, +)
        return sum / Double(nonZeroElements.count)
    }
}
