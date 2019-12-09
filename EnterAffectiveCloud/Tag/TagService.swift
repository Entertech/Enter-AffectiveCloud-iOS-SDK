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
import HandyJSON


class TagService: NSObject {
    static let shared = TagService()
    var token: String?
}

extension ObservableType where Element == Response {
    public func mapHandyJsonModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            
            return Observable.just(response.mapHandyJsonModel(T.self))
            
        }
    }
}

extension Response {
    func mapHandyJsonModel<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        if let modelT = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
            return modelT
        }
        return JSONDeserializer<T>.deserializeFrom(json: "{\"msg\":\"Error JSON\"}")!
    }
}


extension ObservableType where Element == Response {
    public func mapHandyJsonModelList<T: HandyJSON>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            
            return Observable.just(response.mapHandyJsonArrayModel(T.self))
        }
    }
}

extension Response {
    func mapHandyJsonArrayModel<T: HandyJSON>(_ type: T.Type) -> [T] {
        let jsonString = String.init(data: data, encoding: .utf8)
        if let modelT = [T].deserialize(from: jsonString) {
            return modelT as! [T]
        }
        return []
    }
}
