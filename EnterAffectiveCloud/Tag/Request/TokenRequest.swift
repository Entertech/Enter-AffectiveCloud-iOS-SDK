//
//  TokenRequest.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/5.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya
import Alamofire

final public class TokenRequest {

    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<TokenAPI>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    private let dispose = DisposeBag()
    private var isSuccess = false
    lazy var provider = MoyaProvider<TokenAPI>(requestClosure: requestTimeoutClosure)
    
    private lazy var requestToken = {
        (username: String, password: String) -> Observable<TokenModel> in
        return self.provider.rx.request(.create(username, password)).filterSuccessfulStatusCodes().asObservable().mapHandyJsonModel(TokenModel.self)
        //return self.provider.rx.request(.request(username: username, password: password)).filterSuccessfulStatusCodes().asObservable().mapHandyJsonModel(TokenModel.self)
    }
    /// 获取token
    /// - Parameters:
    ///   - appKey: 申请的appkey
    ///   - userId: 本地用户名的MD5
    ///   - sessionId: 情感云的session id
    ///   - version: 情感云版本号
    public func token(appKey: String, appSecret: String, userId: String, version: String) {
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let sign = sessionSign(appKey: appKey, appSecret: appSecret, userID: userId, timeStamp: timestamp)
        let username = UsernameModel()
        username.app_key = appKey
        username.sign = sign
        username.user_id = userId
        username.timestamp = timestamp
        username.version = version
        if let userJson = username.toJSONString() {
            self.requestToken(userJson, sign).subscribe(onNext: { (model) in
                TagService.shared.token = model.token
            }, onError: {[weak self] (error) in
                guard let self = self else {return}
                let err = error as! MoyaError
                if let errMsg = err.response?.data {
                    self.isSuccess = false
                    print(String(data: errMsg, encoding: .utf8) as Any)
                }
            }, onCompleted: {
                self.isSuccess = true
            }, onDisposed: nil).disposed(by: dispose)
        }
    }
    
    private func sessionSign(appKey: String, appSecret: String, userID: String, timeStamp: String) -> String {

        let hashID = userID.hashed(.md5)!.uppercased()
        let sign_str = String(format: "app_key=%@&app_secret=%@&timestamp=%@&user_id=%@",appKey, appSecret, timeStamp, hashID)
        let sign = sign_str.hashed(.md5)!.uppercased()
        return sign
    }
    
    public required init() {
    }
}
