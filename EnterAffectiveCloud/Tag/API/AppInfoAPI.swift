//
//  AppInfoAPI.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Moya

enum AppInfoAPI {
    case list
    case read(Int)
}

extension AppInfoAPI: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/\(AppService.shared.cloudVersion)/appInfo/"
        case .read(let id):
            return "/\(AppService.shared.cloudVersion)/appInfo/\(id)"
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
