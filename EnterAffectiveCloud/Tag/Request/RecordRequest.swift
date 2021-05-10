//
//  RecordRequest.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2021/5/10.
//  Copyright © 2021 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya
import Alamofire

final public class RecordRequest {
    public required init() {
    }

    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<RecordAPI>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 10
            done(.success(request))
        } catch {
            return
        }
    }
    private let dispose = DisposeBag()
    lazy var provider = MoyaProvider<RecordAPI>(requestClosure: requestTimeoutClosure)
    
    
    /// Get record list, search by user id
    /// - Parameters:
    ///   - userId: The user id you set
    ///   - completionHandler: completionHandler with Result value
    public func getRecordListByUser(userId: String, completionHandler:@escaping (Result<[RecordModel], Error>) -> Void) {
        provider.rx.request(.listByUser(userId)).filterSuccessfulStatusCodes().asObservable()
            .mapHandyJsonModelList(RecordModel.self)
            .subscribe { modelList in
                completionHandler(.success(modelList))
            } onError: { error in
                completionHandler(.failure(error))
            }.disposed(by: dispose)
    }
    
    /// Get single record, search by recordId id
    /// - Parameters:
    ///   - recordId: The record id, you can get from 'getRecordListByUser'  method
    ///   - completionHandler: completionHandler with Result value
    public func getRecord(recordId: Int, completionHandler:@escaping (Result<RecordModel, Error>) -> Void) {
        provider.rx.request(.record(recordId)).filterSuccessfulStatusCodes().asObservable()
            .mapHandyJsonModel(RecordModel.self)
            .subscribe { model in
                completionHandler(.success(model))
            } onError: { error in
                completionHandler(.failure(error))
            }.disposed(by: dispose)

    }
    
    /// delete record, search by sesson id
    /// - Parameters:
    ///   - recordId: The record id, you can get from 'getRecordListByUser'  method
    ///   - completionHandler: completionHandler with Result value
    public func deleteRecord(recordId: Int, completionHandler:@escaping (Result<Void, Error>) -> Void) {
        provider.rx.request(.delete(recordId)).filterSuccessfulStatusCodes().asObservable()
            .subscribe { response in
                completionHandler(.success(()))
            } onError: { error in
                completionHandler(.failure(error))
            }.disposed(by: dispose)
    }
    
}
