//
//  CloudType.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/16.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation

public enum CSState: String {
    case connected
    case disconnected
    case none
}

public enum CSServicesType: String {
    case session
    case biodata
    case affective
}

public enum CSSessionOperation: String {
    case create
    case restore
    case close
}

public enum CSBiodataOperation: String {
    case initial = "init"
    case subscribe
    case unsubscribe
    case upload
    case report
}

public enum CSEmotionOperation: String {
    case start
    case subscribe
    case unsubscribe
    case report
    case finish
}

public enum AffectiveCloudRequestError: Error {
    case unSocketConnected
    case unStart
    case noBiodataService
    case noAffectiveService
    case noSession
    case networkUnAvaiabled
    case jsonError
    case unKnow
}

public enum AffectiveCloudResponseError: Error {
    case requestException
    case notFoundServer
    case auth
    case operation
    case unKnow
}
