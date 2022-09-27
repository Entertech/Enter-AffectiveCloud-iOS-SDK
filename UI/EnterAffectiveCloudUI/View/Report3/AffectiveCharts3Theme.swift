//
//  AffectiveCharts3Theme.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/14.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public struct AffectiveChart3Theme {
    public init() {
        
    }
    public var language: LanguageEnum = .en
    
    public var chartName: String = ""
    
    public var themeColor: UIColor = .red
    
    public var chartType: AffectiveCharts3ChartType = .common
    
    public var averageValue: String = ""
    
    public var startTime: TimeInterval = 0
    
    public var endTime: TimeInterval = 0
    
    public var unitText = ""
    
    public var tagSeparation:[Int] = []
    
    public var style = AffectiveCharts3FormatOptional.session
    
    public var startDate: Date {
        return Date.init(timeIntervalSince1970: startTime) 
    }
    
    public var endDate: Date {
        return Date.init(timeIntervalSince1970: endTime) 
    }
}
