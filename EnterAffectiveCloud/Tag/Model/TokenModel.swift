//
//  TokenModel.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/5.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

final public class UsernameModel: Codable  {
    public var app_key: String?
    public var sign: String?
    public var user_id: String?
    public var timestamp: String?
    public var version: String?
    required public init() {}
}

final public class TokenModel: Codable {
    public var token: String?
    
    required public init() {}
}
