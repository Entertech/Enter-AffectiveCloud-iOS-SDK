//
//  TagAPI.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Moya

enum TagAPI {
    case list(String)
}

extension TagAPI: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list(let version):
            return "/\(version)/dataLabelCase/"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        if let accessToken = TagService.shared.token {
            return ["Accpet" : "application/json; version=v1", "Authorization" : "JWT "+accessToken]
        }
        return nil
    }
    
}
