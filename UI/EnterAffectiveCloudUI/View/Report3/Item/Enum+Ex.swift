//
//  Enum+Ex.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/16.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public protocol AffectiveCharts3ChartChanged: AnyObject {
    func update(single: Int?, mult: (Int, Int, Int, Int, Int)?, from: Double, to: Double)
}

public protocol AffectiveCharts3FormatType {
    var fromFormat: String {get}
    var toFormat: String{get}
    var format: String{get}
}

public enum AffectiveCharts3FormatOptional: String, AffectiveCharts3FormatType {
    
    case session
    case month
    case year
    
    public var fromFormat: String {
        switch self {
        case .session:
            return "MMM d, yyyy H:mm a"
        case .month:
            return "MMM d"
        case .year:
            return "MMM yyyy"
        }
    }
    
    public var toFormat: String {
        switch self {
        case .session:
            return "-H:mm a"
        case .month:
            return "-MMM d, yyyy"
        case .year:
            return "-MMM yyyy"
        }
    }
    
    public var format: String {
        switch self {
        case .session:
            return "MMM d, yyyy H:mm a"
        case .month:
            return "MMM d, yyyy"
        case .year:
            return "MMM yyyy"
        }
    }
}


public enum AffectiveCharts3ChartType: String {
    case coherece
    case common
    case rhythms
    case heartRate
    case pressure
    case flow
    var session: String {
        switch self {
        case .coherece,.flow:
            return "TOTAL"
        case .rhythms:
            return "Average Percentage".uppercased()
        default:
            return "AVERAGE"
        }
    }
    
    var sessionCh: String {
        switch self {
        case .coherece,.flow:
            return "TOTAL"
        case .rhythms:
            return "Average Percentage".uppercased()
        default:
            return "AVERAGE"
        }
    }
    
    var month: String {
        switch self {
        case .coherece,.flow:
            return "DAILY AVERAGE"
        case .rhythms:
            return "Daily Average Percentage".uppercased()
        default:
            return "DAILY AVERAGE"
        }
        
    }
    
    var year: String {
        switch self {
        case .coherece,.flow:
            return "DAILY AVERAGE"
        case .rhythms:
            return "Monthly Average Percentage".uppercased()
        default:
            return "MONTHLY AVERAGE"
        }
    }

}

