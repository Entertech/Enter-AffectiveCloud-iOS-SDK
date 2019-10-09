//
//  ToolBox+Ex.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/8.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

extension Notification.Name {
    /// 通知
    static let websocketConnectNotify = Notification.Name(rawValue:"websocketConnectNotify")
    static let biodataServicesSubscribeNotify = Notification.Name(rawValue:"biodataServicesSubscribeNotify")
    static let biodataServicesReportNotify = Notification.Name(rawValue:"biodataServicesReportNotify")
    static let affectiveDataSubscribeNotify = Notification.Name(rawValue:"affectiveDataSubscribeNotify")
    static let affectiveDataReportNotify = Notification.Name(rawValue:"affectiveDataReportNotify")
}
