//
//  TagAPI.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Moya

enum TagAPI {
    case list
}

extension TagAPI: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/\(AppService.shared.cloudVersion)/dataLabelCase/"
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
        if let accessToken = AppService.shared.token {
            return ["Authorization" : "JWT "+accessToken]
        }
        return nil
    }
    
}
