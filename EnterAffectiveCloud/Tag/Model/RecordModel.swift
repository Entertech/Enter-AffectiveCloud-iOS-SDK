//
//  RecordModel.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2021/5/8.
//  Copyright © 2021 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

final public class RecordModel: Codable {
    
    public var record_id: Int?
    public var client_id: String?
    public var session_id: String?
    public var device: String?
    public var data_type: String?
    public var start_time: Date?
    public var close_time: Date?
    public var rec: String?
    public var sex: String?
    public var age: Int?
    public var url: String?
    public var app: Int?
    public var mode: [Int]?
    public var cas: [Int]?
    required public init() {}
    
    enum CodingKeys: String, CodingKey {
        case record_id
        case client_id
        case session_id
        case device
        case data_type
        case start_time
        case close_time
        case rec
        case sex
        case age
        case url
        case app
        case mode
        case cas = "case"
    }
}
