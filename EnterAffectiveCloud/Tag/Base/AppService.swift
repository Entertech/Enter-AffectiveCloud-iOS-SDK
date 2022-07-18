//
//  TagService.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/5.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import Moya


public class AppService: NSObject {
    public static let shared = AppService()
    public var token: String?
    public var cloudVersion: String = "v1"
}
