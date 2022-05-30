//
//  StatisticBuilder.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/5/26.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import LKLibrary
import UIKit

public class StatisticBuilder: LKBuilder {
    public typealias FieldType = StatisticBuilderField

    public typealias Model = StatisticModel

    public var fields: Set<StatisticBuilderField> = [
        StatisticBuilderField.barColor(.white),
        StatisticBuilderField.barWidth(0.5),
        StatisticBuilderField.style(.month),
    ]

    public func compare(field: StatisticBuilderField) throws {
        switch field {
        default:
            break
        }
    }

    public func makeModel() -> StatisticModel {
        let barColor = get(field: StatisticBuilderField.barColor(.white)) as! UIColor
        let style = get(field: StatisticBuilderField.style(.month)) as! StatisticBarStyle
        let barWidth = get(field: StatisticBuilderField.barWidth(0.5)) as! CGFloat

        return StatisticModel(barColor: barColor, style: style, barWidth: barWidth)
    }
}

public enum StatisticBarStyle: Int {
    case year
    case month
}

public enum StatisticBuilderField: LKBuilderField {
    case barColor(UIColor)
    case style(StatisticBarStyle)
    case barWidth(CGFloat)

    public var fieldName: String {
        switch self {
        case .barColor:
            return "barColor"
        case .style:
            return "style"
        case .barWidth:
            return "barWidth"
        }
    }

    public var value: Any? {
        switch self {
        case let .barColor(uIColor):
            return uIColor
        case let .style(statisticBarStyle):
            return statisticBarStyle
        case let .barWidth(cGFloat):
            return cGFloat
        }
    }

    public var isRequired: Bool {
        switch self {
        case .barColor:
            return true
        case .style:
            return true
        case .barWidth:
            return false
        }
    }

    public func validate() throws {
    }

    public var description: String {
        let a = String(describing: type(of: self))
        let b = fieldName
        return "\(a).\(b)"
    }
}

/**
 No extra logic required in the BuildableModel!
 */
public struct StatisticModel: LKBuildableModel {
    var barColor: UIColor
    var style: StatisticBarStyle
    var barWidth: CGFloat
}
