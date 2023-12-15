//
//  HourXFormatter.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import DGCharts
let daySeconds:Double = 86400
public class AffectiveCharts3HourValueFormatter: NSObject, AxisValueFormatter {
    private var startDate: Date?
    init(start: Date? = nil) {

        self.startDate = start
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let startDate = startDate {
            let nData = startDate.addingTimeInterval(value)
            let formatStr = "h:mm a"
            lk_formatter.dateFormat = formatStr
            let value = lk_formatter.string(from: nData)
            return value
        }
        return "\(Int(value / 60))m"
    }
}


public class AffectiveCharts3DayValueFormatter: NSObject, AxisValueFormatter {
    private var originDate: Date!

    init(originDate: Date) {
        self.originDate = originDate
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let days = originDate.getDayAfter(days: Int(value)) ?? Date()
//        print("\(value) -- \(days.get(.month)) -- \(days.get(.day))")
        return "\(days.get(.day))"
        
    }
}

public class AffectiveCharts3MonthValueFormatter: NSObject, AxisValueFormatter {
    private var originDate: Date!

    init(originDate: Date) {
        self.originDate = originDate
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let month = originDate.getMonthAfter(month: Int(value)) ?? Date()
        let monthValue = month.get(.month)
        
        return Date.getMonthSymble(month: monthValue)
        
    }
}

public class AffectiveChartsSleepHourValueFormatter: NSObject, AxisValueFormatter {
    private var startInterval: Double!
    private var endInterval: Double!
    private var values: [Double] = []
    private let minStride: Int = 300
    private var stdValue: Double = 0
    init(start: Double, end: Double) {
        self.startInterval = start
        self.endInterval = end
        let fromToValue = end - start
        var strideValue: Int = 0
        if fromToValue < 1800 {
            strideValue = minStride
            
        } else if fromToValue < 3600 {
            strideValue = minStride * 2
        } else if fromToValue < 10800 {
            strideValue = minStride * 6
        } else if fromToValue < 21600{
            strideValue = minStride * 12
        } else {
            strideValue = minStride * 24
        }
    
        
        let startRemain = Int(start) % strideValue
        let endRemain = Int(end) % strideValue
        let from = Int(start) + strideValue - startRemain
        let to = Int(end) - endRemain
        for t in stride(from: from, through: to, by: strideValue) {
            values.append(Double(t))
        }

        stdValue = Double(Int(start) % minStride > 150 ? Int(start) + (minStride - Int(start) % minStride) : Int(start) - Int(start) % minStride)
        values = values.map({
            round(($0-start)/300)
        })
        
        lk_formatter.dateFormat = "HH:mm"
        
        
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
     
        axis?.entries = values
    
        var time = 0
        time = Int(value*300+stdValue)
        let date = lk_formatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
        return date
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = lk_calendar) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = lk_calendar) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getDayAfter(days: Int) -> Date? {
        return lk_calendar.date(byAdding: DateComponents(day:days), to: self)
    }
    
    func getMonthAfter(month: Int) -> Date? {
        return lk_calendar.date(byAdding: DateComponents(month:month), to: self)
    }
    
    static func getMonthSymble(month: Int) -> String {
        return lk_calendar.shortMonthSymbols[month-1]
    }
    
    func startOfMonth() -> Date {
        return lk_calendar.date(from: lk_calendar.dateComponents([.year, .month], from: lk_calendar.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return lk_calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
