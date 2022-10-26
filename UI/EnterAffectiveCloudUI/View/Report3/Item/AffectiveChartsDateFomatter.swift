//
//  AffectiveChartsDateFomatter.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/14.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
/*
DateFormatter 创建实例很耗时，如果多次创建 DateFormatter 实例，它可能会减慢app 响应速度，甚至更快地耗尽手机电池的电量。
*/
public let lk_formatter = DateFormatter()

public var lk_calendar = Calendar.current

// MARK: - 一、基本扩展
public extension DateFormatter {

   // MARK: 1.1、格式化快捷方式
   /// 格式化快捷方式
   /// - Parameter format: 格式
   convenience init(format: String) {
       self.init()
       dateFormat = format
   }
}
