//
//  TokenRequest.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/5.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import RxSwift
import Moya
import Alamofire
import Foundation

final public class TokenRequest {

    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<TokenAPI>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 10
            done(.success(request))
        } catch {
            return
        }
    }
    private let dispose = DisposeBag()
    /// 0:nil 1:success -1:faild
    public var state = 0
    lazy var provider = MoyaProvider<TokenAPI>(requestClosure: requestTimeoutClosure)
    
    private lazy var requestToken = {
        (username: String, password: String) -> Observable<TokenModel> in
        return self.provider.rx.request(.create(username, password)).filterSuccessfulStatusCodes().asObservable().map(TokenModel.self)

    }
    /// 获取token
    /// - Parameters:
    ///   - appKey: appkey
    ///   - appSecret: app secret
    ///   - userId: user id
    ///   - version: affective cloud version, example:"v1"
    public func token(appKey: String, appSecret: String, userId: String, version: String, completionHandler:@escaping (Result<Void, Error>) -> Void) {
        AppService.shared.cloudVersion = version
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let sign = sessionSign(appKey: appKey, appSecret: appSecret, userID: userId, timeStamp: timestamp)
        let username = UsernameModel()
        username.app_key = appKey
        username.sign = sign
        username.user_id = userId.hashed(.md5)!.uppercased()
        username.timestamp = timestamp
        username.version = version
        do {
            let jsonData = try JSONEncoder().encode(username)
            let userJson = String(decoding: jsonData, as: UTF8.self)
            
            self.requestToken(userJson, sign).subscribe(onNext: { (model) in
                AppService.shared.token = model.token
                completionHandler(.success(()))
            }, onError: {[weak self] (error) in
                guard let self = self else {return}
                let err = error as! MoyaError
                if let errMsg = err.response?.data {
                    self.state = -1
                    print(String(data: errMsg, encoding: .utf8) as Any)
                }
                completionHandler(.failure(error))
            }, onCompleted: {
                self.state = 1
            }, onDisposed: nil).disposed(by: dispose)
        }catch {
            
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
