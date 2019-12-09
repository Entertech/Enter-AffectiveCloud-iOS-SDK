//
//  TokenAPI.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/5.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Moya

enum TokenAPI {
    case create(String, String)
}

extension TokenAPI : TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        return "/api-token-auth/"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .create(username, password):
            return .requestParameters(parameters: ["username":username, "password":password], encoding: URLEncoding.default)
        }

    }
    
    var headers: [String : String]? {
        return ["Accpet" : "application/json; version=v1"]
    }
    
}
