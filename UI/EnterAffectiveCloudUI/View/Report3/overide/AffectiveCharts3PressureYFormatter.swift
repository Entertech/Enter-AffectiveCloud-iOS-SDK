//
//  AffectiveCharts3PressureView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts


public class AffectiveCharts3PressureYFormatter: NSObject, AxisValueFormatter {
    
    override init() {
        super.init()
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var retValue = ""
        if value > 99 {
            retValue = "High"
        } else if value > 74 {
            retValue = "Elevated"
        } else if value > 49 {
            retValue = "Normal"
        } else if value > 24 {
            retValue = "Low"
        }
        return retValue
    }
}
