//
//  Log.swift
//  Enter-AffectiveComputing-iOS-SDK
//
//  Created by Anonymous on 2019/8/14.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

import Foundation

var __isDebug = true

func DLog(_ items: Any...) {
    if __isDebug {
        print("[FLOWTIME DEBUG]: \(items)")
    }
}
