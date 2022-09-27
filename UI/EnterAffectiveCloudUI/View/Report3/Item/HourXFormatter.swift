//
//  HourXFormatter.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import Charts
let daySeconds:Double = 86400
public class AffectiveCharts3HourValueFormatter: NSObject, AxisValueFormatter {
    private var startDate: Date?
    init(start: Date? = nil) {

        self.startDate = start
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let startDate = startDate {
            let nData = startDate.addingTimeInterval(value)
            let formatStr = "HH:mm a"
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

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getDayAfter(days: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day:days), to: self)
    }
    
    func getMonthAfter(month: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(month:month), to: self)
    }
    
    static func getMonthSymble(month: Int) -> String {
        return Calendar.current.shortMonthSymbols[month-1]
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
