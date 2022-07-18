//
//  AppInfo.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

final public class AppInfoModel: Codable  {
    public var app_id: Int?
    public var name: String?
    public var app_key: String?
    public var access: Int? //应用权限
    public var state: Int?  //应用状态
    public var app_type: Int?
    public var charge_mode: Int?
    public var parent: Int?
    public var user: Int?
    required public init() {}
}
