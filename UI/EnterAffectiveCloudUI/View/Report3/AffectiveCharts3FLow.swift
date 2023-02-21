//
//  AffectiveCharts3FLow.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/2/21.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class AffectiveCharts3FLowView: AffectiveCharts3LineCommonView {
    public override func stepThreeSetData(_ array: [Int]) -> Self {
        guard array.count > 0 else {return self}
        dataSorce.removeAll()
        separateY.removeAll()
        dataSorce.append(contentsOf: array)
        
        //计算抽样
        sample = array.count / maxDataCount == 0 ? 1 : Int(ceilf(Float(array.count) / Float(maxDataCount)))
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.axisMaximum = Double(100)
        chartView.leftAxis.axisMinimum = Double(0)
        separateY.append(0)
        separateY.append(33)
        separateY.append(66)
        separateY.append(99)

        return self
    }
}
