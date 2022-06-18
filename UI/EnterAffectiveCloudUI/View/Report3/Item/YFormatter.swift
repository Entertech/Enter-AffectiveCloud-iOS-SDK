//
//  YFormatter.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/17.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

public class AffectiveCharts3PercentFormatter: NSObject, AxisValueFormatter {


    override init() {
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return "\(Int(value))%"
        
    }
}
