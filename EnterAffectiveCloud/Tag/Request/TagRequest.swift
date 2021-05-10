//
//  TagRequest.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya
import Alamofire

final public class TagRequest {
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<TagAPI>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    private let dispose = DisposeBag()
    lazy var provider = MoyaProvider<TagAPI>(requestClosure: requestTimeoutClosure)
    
    public lazy var list = { () -> Observable<[TagModel]> in
        return self.provider.rx.request(.list).filterSuccessfulStatusCodes().asObservable().mapHandyJsonModelList(TagModel.self)
    }
    
    
    public required init() {
    }
}
