//
//  CloudServicesProtocol.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/14.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import SwiftyJSON

/// cloud services response delegate
/// you can handle or display cloud data in your UI level use this delegate
public protocol AffectiveCloudResponseDelegate: class {
    func websocketState(client: AffectiveCloudClient, state: CSState)
    func websocketConnect(client: AffectiveCloudClient)
    func websocketDisconnect(client: AffectiveCloudClient)

    func sessionCreateAndAuthenticate(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func sessionRestore(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func sessionClose(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)

    func biodataServicesInit(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func biodataServicesSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func biodataServicesUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func biodataServicesUpload(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func biodataServicesReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)

    func affectiveDataStart(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func affectiveDataSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func affectiveDataUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func affectiveDataReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)
    func affectiveDataFinish(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel)

    func error(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel?, error: AffectiveCloudResponseError, message: String?)
    func error(client: AffectiveCloudClient, request: AffectiveCloudRequestJSONModel?, error: AffectiveCloudRequestError, message: String?)
}

//MARK: websocket services
/// this protocol include the services about websocket
/// and session (this session is customed by our server not web session)
protocol WebSocketServiceProcotol {
    func webSocketConnect()
    func webSocketSend(jsonString data: String)
    func webSocketDisConnect()
    func sessionCreate(appKey: String, sign: String, userID: String, timestamp: String)
    func sessionRestore()
    func sessionClose()
}

//MARK: biodata service and type
protocol BiodataServiceProtocol {
    func biodataInitial(options: BiodataTypeOptions)
    func biodataSubscribe(parameters options: BiodataParameterOptions)
    func biodataUnSubscribe(parameters options: BiodataParameterOptions)
    func biodataUpload(options: BiodataTypeOptions, eegData: [Int]?, hrData: [Int]?)
    func biodataReport(options: BiodataTypeOptions)
}

public extension BiodataTypeOptions {
    static let EEG = BiodataTypeOptions(rawValue: 1 << 0)
    static let HeartRate = BiodataTypeOptions(rawValue: 1 << 1)
}

public struct BiodataTypeOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// Biodata Parameter options: eg: eegl_wave, eegr_wave, eeg_alpha_power
public extension BiodataParameterOptions {
    static let eeg_wave_left = BiodataParameterOptions(rawValue: 1 << 0)
    static let eeg_wave_right = BiodataParameterOptions(rawValue: 1 << 1)
    static let eeg_alpha = BiodataParameterOptions(rawValue: 1 << 2)
    static let eeg_beta = BiodataParameterOptions(rawValue: 1 << 3)
    static let eeg_theta = BiodataParameterOptions(rawValue: 1 << 4)
    static let eeg_delta = BiodataParameterOptions(rawValue: 1 << 5)
    static let eeg_gamma = BiodataParameterOptions(rawValue: 1 << 6)
    static let eeg_quality = BiodataParameterOptions(rawValue: 1 << 7)
    static let hr_value = BiodataParameterOptions(rawValue: 1 << 8)
    static let hr_variability = BiodataParameterOptions(rawValue: 1 << 9)
    static let eeg_all = BiodataParameterOptions(rawValue: 1 << 10)
    static let hr_all = BiodataParameterOptions(rawValue: 1 << 11)
}

public struct BiodataParameterOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// Emotional Cloud Services
protocol CSEmotionServiceProcotol {
    func emotionStart(services: AffectiveDataServiceOptions)
    func emotionSubscribe(services: AffectiveDataSubscribeOptions)
    func emotionUnSubscribe(services: AffectiveDataSubscribeOptions)
    func emotionReport(services: AffectiveDataServiceOptions)
    func emotionClose(services: AffectiveDataServiceOptions)
}

//MARK: emotional services and type
public extension AffectiveDataSubscribeOptions {
    static let attention = AffectiveDataSubscribeOptions(rawValue: 1 << 0)
    static let relaxation = AffectiveDataSubscribeOptions(rawValue: 1 << 1)
    static let pressure = AffectiveDataSubscribeOptions(rawValue: 1 << 2)
    static let pleasure = AffectiveDataSubscribeOptions(rawValue: 1 << 3)
    static let arousal = AffectiveDataSubscribeOptions(rawValue: 1 << 4)
}

public struct AffectiveDataSubscribeOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension AffectiveDataServiceOptions {
    static let attention = AffectiveDataServiceOptions(rawValue: 1 << 0)
    static let relaxation = AffectiveDataServiceOptions(rawValue: 1 << 1)
    static let pressure = AffectiveDataServiceOptions(rawValue: 1 << 2)
    static let pleasure = AffectiveDataServiceOptions(rawValue: 1 << 3)
    static let arousal = AffectiveDataServiceOptions(rawValue: 1 << 4)
}

public struct AffectiveDataServiceOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct CSAffectiveReportOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension CSAffectiveReportOptions {
    static let attention_all = CSAffectiveReportOptions(rawValue: 1 << 0)
    static let attention_average = CSAffectiveReportOptions(rawValue: 1 << 1)
    static let attention_curve = CSAffectiveReportOptions(rawValue: 1 << 2)

    static let relaxation_all = CSAffectiveReportOptions(rawValue: 1 << 3)
    static let relaxation_average = CSAffectiveReportOptions(rawValue: 1 << 4)
    static let relaxation_curve = CSAffectiveReportOptions(rawValue: 1 << 5)

    static let pressure_all = CSAffectiveReportOptions(rawValue: 1 << 6)
    static let pressure_average = CSAffectiveReportOptions(rawValue: 1 << 7)
    static let pressure_curve = CSAffectiveReportOptions(rawValue: 1 << 8)

    static let pleasure_all = CSAffectiveReportOptions(rawValue: 1 << 9)
    static let pleasure_average = CSAffectiveReportOptions(rawValue: 1 << 10)
    static let pleasure_curve = CSAffectiveReportOptions(rawValue: 1 << 11)

    static let arousal_all = CSAffectiveReportOptions(rawValue: 1 << 12)
    static let arousal_average = CSAffectiveReportOptions(rawValue: 1 << 13)
    static let arousal_curve = CSAffectiveReportOptions(rawValue: 1 << 14)
}
