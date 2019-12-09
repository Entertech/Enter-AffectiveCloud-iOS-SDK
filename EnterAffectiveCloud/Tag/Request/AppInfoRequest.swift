//
//  AppInfoRequest.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya
import Alamofire

final public class AppInfoRequest: NSObject {
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<AppInfoAPI>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    private let dispose = DisposeBag()
    lazy var provider = MoyaProvider<AppInfoAPI>(requestClosure: requestTimeoutClosure)
    
    public lazy var list = { (version:String) -> Observable<[AppInfoModel]> in
        return self.provider.rx.request(.list(version)).filterSuccessfulStatusCodes().asObservable().mapHandyJsonModelList(AppInfoModel.self)
    }
    
    public lazy var read = { (version:String, id: Int) -> Observable<AppInfoModel> in
        return self.provider.rx.request(.read(version, id)).filterSuccessfulStatusCodes().asObservable().mapHandyJsonModel(AppInfoModel.self)
        
    }
    
    public required init() {
    }
}
