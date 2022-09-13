//
//  RecordAPI.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2021/5/8.
//  Copyright © 2021 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Moya

enum RecordAPI {
    case listByUser(String, Int, Int)
    case listBySession(String, Int, Int)
    case record(Int)
    case delete(Int)
}

extension RecordAPI: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .listByUser:
            return "/\(AppService.shared.cloudVersion)/sourceDataRecords/"
        case .listBySession:
            return "/\(AppService.shared.cloudVersion)/sourceDataRecords/"
        case .record(let id):
            return "/\(AppService.shared.cloudVersion)/sourceDataRecords/\(id)/"
        case .delete(let id):
            return "/\(AppService.shared.cloudVersion)/sourceDataRecords/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .listByUser:
            return .get
        case .listBySession:
            return .get
        case .record:
            return .get
        case .delete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .listByUser(let user,let page, let pageSize):
            return .requestParameters(parameters: ["user_id":user,"page":page, "page_size":pageSize], encoding: URLEncoding.default)
        case .listBySession(let sesson, let page, let pageSize):
            return .requestParameters(parameters: ["session_id":sesson,"page":page, "page_size":pageSize], encoding: URLEncoding.default)
        case .record(_):
            return .requestPlain
        case .delete(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = AppService.shared.token {
            return ["Authorization" : "JWT "+accessToken]
        }
        return nil
    }
}
