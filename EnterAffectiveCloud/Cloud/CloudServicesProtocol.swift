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
public protocol CSResponseDelegate: class {
    func websocketState(client: CSClient, state: CSState)
    func websocketConnect(client: CSClient)
    func websocketDisconnect(client: CSClient)

    func sessionCreate(client: CSClient, response: CSResponseJSONModel)
    func sessionRestore(client: CSClient, response: CSResponseJSONModel)
    func sessionClose(client: CSClient, response: CSResponseJSONModel)

    func biodataInitial(client: CSClient, response: CSResponseJSONModel)
    func biodataSubscribe(client: CSClient, response: CSResponseJSONModel)
    func biodataUnsubscribe(client: CSClient, response: CSResponseJSONModel)
    func biodataUpload(client: CSClient, response: CSResponseJSONModel)
    func biodataReport(client: CSClient, response: CSResponseJSONModel)

    func affectiveStart(client: CSClient, response: CSResponseJSONModel)
    func affectiveSubscribe(client: CSClient, response: CSResponseJSONModel)
    func affectiveUnsubscribe(client: CSClient, response: CSResponseJSONModel)
    func affectiveReport(client: CSClient, response: CSResponseJSONModel)
    func affectiveFinish(client: CSClient, response: CSResponseJSONModel)

    func error(client: CSClient, response: CSResponseJSONModel?, error: CSResponseError, message: String?)
    func error(client: CSClient, request: CSRequestJSONModel?, error: CSRequestError, message: String?)
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
    func biodataSubscribe(parameters options: BiodataSubscribeOptions)
    func biodataUnSubscribe(parameters options: BiodataSubscribeOptions)
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
public extension BiodataSubscribeOptions {
    static let eeg_wave_left = BiodataSubscribeOptions(rawValue: 1 << 0)
    static let eeg_wave_right = BiodataSubscribeOptions(rawValue: 1 << 1)
    static let eeg_alpha = BiodataSubscribeOptions(rawValue: 1 << 2)
    static let eeg_beta = BiodataSubscribeOptions(rawValue: 1 << 3)
    static let eeg_theta = BiodataSubscribeOptions(rawValue: 1 << 4)
    static let eeg_delta = BiodataSubscribeOptions(rawValue: 1 << 5)
    static let eeg_gamma = BiodataSubscribeOptions(rawValue: 1 << 6)
    static let eeg_quality = BiodataSubscribeOptions(rawValue: 1 << 7)
    static let hr_value = BiodataSubscribeOptions(rawValue: 1 << 8)
    static let hr_variability = BiodataSubscribeOptions(rawValue: 1 << 9)
    static let eeg_all = BiodataSubscribeOptions(rawValue: 1 << 10)
    static let hr_all = BiodataSubscribeOptions(rawValue: 1 << 11)
}

public struct BiodataSubscribeOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// Emotional Cloud Services
protocol CSEmotionServiceProcotol {
    func emotionStart(services: CSEmotionsAffectiveOptions)
    func emotionSubscribe(services: CSEmotionSubscribeOptions)
    func emotionUnSubscribe(services: CSEmotionSubscribeOptions)
    func emotionReport(services: CSEmotionsAffectiveOptions)
    func emotionClose(services: CSEmotionsAffectiveOptions)
}

//MARK: emotional services and type
public extension CSEmotionSubscribeOptions {
    static let attention = CSEmotionSubscribeOptions(rawValue: 1 << 0)
    static let relaxation = CSEmotionSubscribeOptions(rawValue: 1 << 1)
    static let pressure = CSEmotionSubscribeOptions(rawValue: 1 << 2)
    static let pleasure = CSEmotionSubscribeOptions(rawValue: 1 << 3)
    static let arousal = CSEmotionSubscribeOptions(rawValue: 1 << 4)
}

public struct CSEmotionSubscribeOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension CSEmotionsAffectiveOptions {
    static let attention = CSEmotionsAffectiveOptions(rawValue: 1 << 0)
    static let relaxation = CSEmotionsAffectiveOptions(rawValue: 1 << 1)
    static let pressure = CSEmotionsAffectiveOptions(rawValue: 1 << 2)
    static let pleasure = CSEmotionsAffectiveOptions(rawValue: 1 << 3)
    static let arousal = CSEmotionsAffectiveOptions(rawValue: 1 << 4)
}

public struct CSEmotionsAffectiveOptions: OptionSet {
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
