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
    
    override init() {
        super.init()

    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value / 60))"
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
        
        return "\(month.get(.month))"
        
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
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
