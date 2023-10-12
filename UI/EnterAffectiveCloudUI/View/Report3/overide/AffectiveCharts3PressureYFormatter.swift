//
//  AffectiveCharts3PressureView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import DGCharts


public class AffectiveCharts3PressureYFormatter: NSObject, AxisValueFormatter {
    var language = ["High", "Elevated", "Medium", "Low"]
    init(lan: [String]) {
        super.init()
        self.language = lan
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var retValue = ""
        if value > 99 {
            retValue = language[0]
        } else if value > 74 {
            retValue = language[1]
        } else if value > 49 {
            retValue = language[2]
        } else if value > 24 {
            retValue = language[3]
        }
        return retValue
    }
}
