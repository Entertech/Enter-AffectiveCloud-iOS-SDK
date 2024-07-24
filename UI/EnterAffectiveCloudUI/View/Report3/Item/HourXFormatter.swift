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
    private let minStride: Int = 120
    private var stdValue: Double = 0
    init(start: Double, end: Double) {
        self.startInterval = start
        self.endInterval = end
        if end - start < 21600 {
            lk_formatter.dateFormat = "HH:mm"
        } else {
            lk_formatter.dateFormat = "HH"
        }
        let result = findDesiredTimes(start: Date(timeIntervalSince1970: start), end: Date(timeIntervalSince1970: end))
        values = result.map({$0.timeIntervalSince1970})
        print(start)
        print(end)
        print(values)
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if values.count > 0 {
            axis?.entries = values

            let date = lk_formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value)))
            return date
        } else {
            let date = lk_formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value)))
            return date
        }

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


enum TimeType {
    case tenMinutes
    case thirtyMinutes
    case oneHour
    case twoHours
}

func findDesiredTimes(start: Date, end: Date) -> [Date] {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: start, to: end)
    let totalMinutes = components.hour! * 60 + components.minute!
    
    let timeType: TimeType
    if totalMinutes < 60 {
        timeType = .tenMinutes
    } else if totalMinutes < 180 {
        timeType = .thirtyMinutes
    } else if totalMinutes < 360 {
        timeType = .oneHour
    } else {
        timeType = .twoHours
    }
    
    return generateTimeIntervals(start: start, end: end, type: timeType)
}

func generateTimeIntervals(start: Date, end: Date, type: TimeType) -> [Date] {
    let calendar = Calendar.current
    var current = start
    var result: [Date] = []
    
    while current <= end {
        let minutes = calendar.component(.minute, from: current)
        let hours = calendar.component(.hour, from: current)
        
        switch type {
        case .tenMinutes:
            if minutes % 10 == 0 {
                result.append(current)
            }
        case .thirtyMinutes:
            if minutes % 30 == 0 {
                result.append(current)
            }
        case .oneHour:
            if minutes == 0 {
                result.append(current)
            }
        case .twoHours:
            if minutes == 0 && hours % 2 == 0 {
                result.append(current)
            }
        }
        
        current = calendar.date(byAdding: .minute, value: 1, to: current)!
    }
    
    return result
}
