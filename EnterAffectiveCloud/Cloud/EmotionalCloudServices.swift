//
//  EmotionalCloudServices.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/14.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import Starscream
import HandyJSON
import Gzip

// web socket services
class EmotionalCloudServices: WebSocketServiceProcotol {

    /// receive response data use delegate method
    weak var delegate: CSResponseDelegate?

    var isSessionConnected = false
    //MARK: initial websocket
    var state: CSState = .none {
        didSet {
            if state != oldValue {
                self.delegate?.websocketState(client: self.client, state: state)
            }
        }
    }
    let socket: WebSocket
    var client: CSClient!
    init(ws: String) {
        self.socket = WebSocket(url: URL(string: ws)!)
        self.socket.delegate = self
        self.state = .none
    }

    init(wssURL: URL) {
        self.socket = WebSocket(url: wssURL)
        self.socket.delegate = self
        self.state = .none
    }

    //MARK: WebSocketServiceProcotol
    func webSocketConnect() {
        self.socket.connect()
        self.delegate?.websocketState(client: self.client, state: .connected)
        self.delegate?.websocketConnect(client: self.client)
    }

    func webSocketSend(jsonString json: String) {
        //compressed data with gzip
        if let data = json.data(using: .utf8), let compressData =  try? data.gzipped() {
            self.socket.write(data: compressData)
        }
    }

    func webSocketDisConnect() {
        self.socket.disconnect()
        self.delegate?.websocketState(client: self.client, state: .disconnected)
        self.delegate?.websocketDisconnect(client: self.client)
    }

    func sessionCreate(appKey: String, sign: String, userID: String, timestamp: String) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }
        let requestModel = CSRequestJSONModel()
        requestModel.services = CSServicesType.session.rawValue
        requestModel.operation = CSSessionOperation.create.rawValue
        requestModel.kwargs = CSKwargsJSONModel()
        requestModel.kwargs?.app_key = appKey
        requestModel.kwargs?.sign = sign
        requestModel.kwargs?.userID = userID.hashed(.md5, output: .hex)!.uppercased()
        requestModel.kwargs?.timeStamp = timestamp

        if let jsonstring = requestModel.toJSONString() {
            self.webSocketSend(jsonString: jsonstring)
        } else {
            self.delegate?.error(client: self.client, request: requestModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    private var session_id: String?
    func sessionRestore() {
        guard let session = session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: The session id is empty, restore failed! Try restart cloud service.")
            return
        }
        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.session.rawValue
        jsonModel.operation = CSSessionOperation.restore.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.sessionID = session
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func sessionClose() {
        guard let _ = session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: The session id is empty,session close failed!!")
            return
        }

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.session.rawValue
        jsonModel.operation = CSSessionOperation.close.rawValue
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    //MARK: Private
    private func biodataTypeList(with options: BiodataTypeOptions) -> [String] {
        var servicesList = [String]()
        if options.contains(.EEG) {
            servicesList.append("eeg")
        }
        if options.contains(.HeartRate) {
            servicesList.append("hr")
        }
        return servicesList
    }

    private func biodataParamList(with options: BiodataSubscribeOptions) -> Set<String> {
        var parametersList = Set<String>()
        if options.contains(.eeg_all) {
            parametersList.insert("eegl_wave")
            parametersList.insert("eegr_wave")
            parametersList.insert("eeg_alpha_power")
            parametersList.insert("eeg_beta_power")
            parametersList.insert("eeg_theta_power")
            parametersList.insert("eeg_delta_power")
            parametersList.insert("eeg_gamma_power")
            parametersList.insert("eeg_quality")
        }
        if options.contains(.eeg_wave_left) {
            parametersList.insert("eegl_wave")
        }
        if options.contains(.eeg_wave_right) {
            parametersList.insert("eegr_wave")
        }
        if options.contains(.eeg_alpha) {
            parametersList.insert("eeg_alpha_power")
        }
        if options.contains(.eeg_beta) {
            parametersList.insert("eeg_beta_power")
        }
        if options.contains(.eeg_theta) {
            parametersList.insert("eeg_theta_power")
        }
        if options.contains(.eeg_delta) {
            parametersList.insert("eeg_delta_power")
        }
        if options.contains(.eeg_gamma) {
            parametersList.insert("eeg_gamma_power")
        }
        if options.contains(.eeg_quality) {
            parametersList.insert("eeg_quality")
        }

        if options.contains(.hr_all) {
            parametersList.insert("hr")
            parametersList.insert("hrv")
        }
        if options.contains(.hr_value) {
            parametersList.insert("hr")
        }
        if options.contains(.hr_variability) {
            parametersList.insert("hrv")
        }

        return parametersList
    }

    private func reportTypeString(options: BiodataTypeOptions) -> String {
        var servicesList = [String]()
        if options.contains(.EEG) {
            servicesList.append("eeg")
        }

        if options.contains(.HeartRate) {
            servicesList.append("hr")
        }

        return servicesList.joined(separator: ",")
    }

    // Extension Properties
    private var biodataInitialList: BiodataTypeOptions?
    private var emotionAffectiveInitialList: CSEmotionsAffectiveOptions?
}

//MARK: BiodataServiceProtocol imp
extension EmotionalCloudServices: BiodataServiceProtocol {

    func biodataInitial(options: BiodataTypeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: session is empty,please create session or restore session!")
            return
        }

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.initial.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        let biodataTypes = self.biodataTypeList(with: options)
        jsonModel.kwargs?.bioTypes = biodataTypes
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func biodataSubscribe(parameters options: BiodataSubscribeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        var biodataTypes = [String]()
        let biodataParamList = self.biodataParamList(with: options)
        let eegParamList: [String] = biodataParamList.filter { $0.contains("eeg") }
        let hrParamList: [String] = biodataParamList.filter { $0.contains("hr") }
        if eegParamList.count > 0 {
            biodataTypes.append("eeg")
        }
        if hrParamList.count > 0 {
            biodataTypes.append("hr")
        }

        if let flag = self.biodataInitialList?.contains(.EEG), eegParamList.count > 0 {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noBiodataService, message: "CSRequestError: EEG service unavailable: you must init eeg biodata service first!")
            }
            return
        }

        if let flag = self.biodataInitialList?.contains(.HeartRate), hrParamList.count > 0 {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noBiodataService, message: "CSRequestError: Heart rate service unavailable: you must init hr biodata service first!")
            }
            return
        }

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.subscribe.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.bioTypes = biodataTypes
        jsonModel.kwargs?.hrParams = hrParamList
        jsonModel.kwargs?.eegParams = eegParamList

        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func biodataUnSubscribe(parameters options: BiodataSubscribeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.unsubscribe.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.eegParams = self.biodataParamList(with: options).filter { $0.contains("eeg") }
        jsonModel.kwargs?.hrParams = self.biodataParamList(with: options).filter { $0.contains("hr") }
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func biodataUpload(options: BiodataTypeOptions, eegData: [Int]? = nil, hrData: [Int]? = nil) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.upload.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        if options.contains(.EEG) {
            if let flag = self.biodataInitialList?.contains(.EEG), flag {
                jsonModel.kwargs?.eegData = eegData
            } else {
                self.delegate?.error(client: self.client, request: nil, error: .noBiodataService, message: "CSRequestError: EEG service unavailable: you must initial eeg biodata service first!")
                return
            }
        }
        if options.contains(.HeartRate) {
            if let flag = self.biodataInitialList?.contains(.HeartRate), flag {
                jsonModel.kwargs?.hrData = hrData
            } else {
                self.delegate?.error(client: self.client, request: nil, error: .noBiodataService, message: "CSRequestError: Heart rate service unavailable: you must initial hr biodata service first!")
                return
            }
        }
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func biodataReport(options: BiodataTypeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        if let flag = self.biodataInitialList?.contains(.EEG), options.contains(.EEG) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noBiodataService, message: "CSRequestError: EEG service unavailable! generate report failed!")
                return
            }
        }

        if let flag = self.biodataInitialList?.contains(.HeartRate), options.contains(.HeartRate) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noBiodataService, message: "CSRequestError: Heart rate service unavailable! generate report failed!")
                return
            }
        }

        let biodataTypes = self.biodataTypeList(with: options)
        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.report.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.bioTypes = biodataTypes
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }
}

//MARK: EmotionServiceProcotol
extension EmotionalCloudServices: CSEmotionServiceProcotol {

    func emotionStart(services: CSEmotionsAffectiveOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.affective.rawValue
        jsonModel.operation = CSEmotionOperation.start.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.affectiveTypes = self.serviceList(options: services)

        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func emotionSubscribe(services: CSEmotionSubscribeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        self.checkEmotionAffectiveIsInitial(subscribeList: services)

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.affective.rawValue
        jsonModel.operation = CSEmotionOperation.subscribe.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        let paramList = self.subscribeList(options: services)
        let attentionParams: [String] = paramList.filter { $0.contains("attention") }
        let relaxationParams: [String]  = paramList.filter { $0.contains("relaxation") }
        let pressureParams: [String]  = paramList.filter { $0.contains("pressure") }
        let pleasureParams: [String] = paramList.filter { $0.contains("pleasure") }
        let arousalParams: [String] = paramList.filter { $0.contains("arousal") }
        if attentionParams.count > 0 {
            jsonModel.kwargs?.attenionServieces = attentionParams
        }

        if relaxationParams.count > 0 {
            jsonModel.kwargs?.relaxationServices = relaxationParams
        }

        if pressureParams.count > 0 {
            jsonModel.kwargs?.pressureServices = pressureParams
        }

        if pleasureParams.count > 0 {
            jsonModel.kwargs?.pleasureServices = pleasureParams
        }

        if arousalParams.count > 0 {
            jsonModel.kwargs?.arousalServices = arousalParams
        }

        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func emotionUnSubscribe(services: CSEmotionSubscribeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }


        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.affective.rawValue
        jsonModel.operation = CSEmotionOperation.unsubscribe.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        let paramList = self.subscribeList(options: services)
        let attentionParams: [String] = paramList.filter { $0.contains("attention") }
        let relaxationParams: [String]  = paramList.filter { $0.contains("relaxation") }
        let pressureParams: [String]  = paramList.filter { $0.contains("pressure") }
        let pleasureParams: [String] = paramList.filter { $0.contains("pleasure") }
        let arousalParams: [String] = paramList.filter { $0.contains("arousal") }
        if attentionParams.count > 0 {
            jsonModel.kwargs?.attenionServieces = attentionParams
        }

        if relaxationParams.count > 0 {
            jsonModel.kwargs?.relaxationServices = relaxationParams
        }

        if pressureParams.count > 0 {
            jsonModel.kwargs?.pressureServices = pressureParams
        }

        if pleasureParams.count > 0 {
            jsonModel.kwargs?.pleasureServices = pleasureParams
        }

        if arousalParams.count > 0 {
            jsonModel.kwargs?.arousalServices = arousalParams
        }

        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func emotionReport(services: CSEmotionsAffectiveOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        self.checkEmotionAffectiveIsInitial(affectiveList: services)

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.affective.rawValue
        jsonModel.operation = CSEmotionOperation.report.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.affectiveTypes = self.serviceList(options: services)

        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func emotionClose(services: CSEmotionsAffectiveOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let jsonModel = CSRequestJSONModel()
        jsonModel.services = CSServicesType.affective.rawValue
        jsonModel.operation = CSEmotionOperation.finish.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.affectiveTypes = self.serviceList(options: services)
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    private func serviceList(options: CSEmotionsAffectiveOptions) -> [String] {
        var list = [String]()
        if options.contains(.attention) {
            list.append("attention")
        }

        if options.contains(.relaxation) {
            list.append("relaxation")
        }

        if options.contains(.pressure) {
            list.append("pressure")
        }

        if options.contains(.pleasure) {
            list.append("pleasure")
        }

        if options.contains(.arousal) {
            list.append("arousal")
        }

        return list
    }

    private func paramList(options: CSAffectiveReportOptions) -> Set<String> {
        var list = Set<String>()
        if options.contains(.attention_all) {
            list.insert("attention_avg")
            list.insert("attention_rec")
        }

        if options.contains(.attention_average) {
            list.insert("attention_avg")
        }

        if options.contains(.attention_curve) {
            list.insert("attention_rec")
        }

        if options.contains(.relaxation_all) {
            list.insert("relaxation_avg")
            list.insert("relaxation_rec")
        }

        if options.contains(.relaxation_average) {
            list.insert("relaxation_avg")
        }

        if options.contains(.relaxation_curve) {
            list.insert("relaxation_rec")
        }

        if options.contains(.pressure_all) {
            list.insert("pressure_avg")
            list.insert("pressure_rec")
        }

        if options.contains(.pressure_average) {
            list.insert("pressure_avg")
        }

        if options.contains(.pressure_curve) {
            list.insert("pressure_rec")
        }
        return list
    }

    private func subscribeList(options: CSEmotionSubscribeOptions)-> [String] {
        var list = [String]()
        if options.contains(.attention) {
            list.append("attention")
        }

        if options.contains(.relaxation) {
            list.append("relaxation")
        }

        if options.contains(.pressure) {
            list.append("pressure")
        }

        if options.contains(.pleasure) {
            list.append("pleasure")
        }

        if options.contains(.arousal) {
            list.append("arousal")
        }

        return list
    }

    private func checkEmotionAffectiveIsInitial(subscribeList: CSEmotionSubscribeOptions) {
        if let flag = self.emotionAffectiveInitialList?.contains(.attention),
            subscribeList.contains(.attention) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Attention unvailable, please start attention service first!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.relaxation),
            subscribeList.contains(.relaxation) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Relaxation unvailable, please start relaxation service first!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.pleasure),
            subscribeList.contains(.pleasure) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Pleasure unvailable, please start pleasure service first!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.pressure),
            subscribeList.contains(.pressure) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Pressure unvailable, please start pressure service first!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.arousal),
            subscribeList.contains(.arousal) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Arousal unvailable, please start arousal service first!")
                return
            }
        }
    }

    private func checkEmotionAffectiveIsInitial(affectiveList: CSEmotionsAffectiveOptions) {
        if let flag = self.emotionAffectiveInitialList?.contains(.attention),
            affectiveList.contains(.attention) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Attention unvailable, generate report failed!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.relaxation),
            affectiveList.contains(.relaxation) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Relaxation unvailable, generate report failed!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.pleasure),
            affectiveList.contains(.pleasure) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Pleasure unvailable, generate report failed!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.pressure),
            affectiveList.contains(.pressure) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Pressure unvailable, generate report failed!")
                return
            }
        }

        if let flag = self.emotionAffectiveInitialList?.contains(.arousal),
            affectiveList.contains(.arousal) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Arousal unvailable, generate report failed!")
                return
            }
        }
    }
}

extension EmotionalCloudServices: WebSocketDelegate {
    //MARK: web socket delegate
    func websocketDidConnect(socket: WebSocketClient) {
        self.state = .connected
        self.delegate?.websocketConnect(client: self.client)
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.state = .disconnected
        self.session_id = nil
        self.isSessionConnected = false
        self.delegate?.websocketDisconnect(client: self.client)
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        DLog("response data is \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        if let unGzipData = try? data.gunzipped() {
            let text = String(decoding: unGzipData, as: UTF8.self)
            DLog("response data is \(text)")
            if let responseModel = CSResponseJSONModel.deserialize(from: text) {
                if self.handleErrorWithResponse(model: responseModel) { return }
                self.handleResponse(with: responseModel)
            } else {
                self.delegate?.error(client: self.client, response: nil, error: .unKnow, message: "Json deserialize failed, the model is empty!")
            }
        } else {
            self.delegate?.error(client: self.client, response: nil, error: .unKnow, message: "ungzip failed , the model is empty!")
        }
    }

    // check response status code, if error return `true`
    private func handleErrorWithResponse(model: CSResponseJSONModel) -> Bool {
        switch model.code {
        case 400:
            self.delegate?.error(client: self.client, response: model, error: .requestException, message: "The Request error!!")
            return true
        case 404:
            self.delegate?.error(client: self.client, response: model, error: .notFoundServer, message: "Can't found Server!")
            return true
        case 407:
            self.delegate?.error(client: self.client, response: model, error: .auth, message: "The app_key or sign error!")
            return true
        default:
            break
        }
        return false
    }

    /// Handle response data
    /// you can get data use `CSResponseDelegate` in your code
    private func handleResponse(with model: CSResponseJSONModel) {
        if let request = model.request {
            switch (request.services, request.operation) {
            case (CSServicesType.session.rawValue, CSSessionOperation.create.rawValue):
                if let dataModel = model.dataModel as? CSResponseDataJSONModel,
                    let id = dataModel.sessionID {
                    self.session_id = id
                    self.isSessionConnected = true
                }
                self.delegate?.sessionCreate(client: self.client, response: model)
            case (CSServicesType.session.rawValue, CSSessionOperation.restore.rawValue):
                self.delegate?.sessionRestore(client: self.client, response: model)
            case (CSServicesType.session.rawValue, CSSessionOperation.close.rawValue):
                self.delegate?.sessionClose(client: self.client, response: model)
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.initial.rawValue):
                if let biodata = model.dataModel as? CSResponseDataJSONModel,
                    let list = biodata.biodataList {
                    self.appendBiodataInitialList(list: list)
                }
                self.delegate?.biodataInitial(client: self.client, response: model)
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.subscribe.rawValue):
                if let data = model.dataModel as? CSBiodataProcessJSONModel {
                    DLog("log biodata subscribe is \(data)")
                }

//                if let data = model.dataModel as? CSResponseBiodataSubscribeJSONModel,
//                    let list = data.eegServiceList {
//                    self.appendBiodataSubscribeList(list: list)
//                }
//
//                if let data = model.dataModel as? CSResponseBiodataSubscribeJSONModel,
//                    let list = data.hrServiceList {
//                    self.appendBiodataSubscribeList(list: list)
//                }

                self.delegate?.biodataSubscribe(client: self.client, response: model)
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.unsubscribe.rawValue):
                self.delegate?.biodataUnsubscribe(client: self.client, response: model)
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.upload.rawValue):
                self.delegate?.biodataUpload(client: self.client, response: model)
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.report.rawValue):
                self.delegate?.biodataReport(client: self.client, response: model)
            case (CSServicesType.affective.rawValue, CSEmotionOperation.start.rawValue):
                if let dataModel = model.dataModel as? CSResponseDataJSONModel,
                    let list = dataModel.affectiveList {
                    self.appendEmotionAffectiveInitialList(list: list)
                }
                self.delegate?.affectiveStart(client: self.client, response: model)
            case (CSServicesType.affective.rawValue, CSEmotionOperation.subscribe.rawValue):
                if let dataModel = model.dataModel as? CSAffectiveSubscribeProcessJsonModel {
                    DLog("affective data is \(dataModel.isNil())")
                }
                self.delegate?.affectiveSubscribe(client: self.client, response: model)
            case (CSServicesType.affective.rawValue, CSEmotionOperation.unsubscribe.rawValue):
                self.delegate?.affectiveUnsubscribe(client: self.client, response: model)
            case (CSServicesType.affective.rawValue, CSEmotionOperation.report.rawValue):
                self.delegate?.affectiveReport(client: self.client, response: model)
            case (CSServicesType.affective.rawValue, CSEmotionOperation.finish.rawValue):
                self.delegate?.affectiveFinish(client: self.client, response: model)
            default:
                break
            }
        } else {
            self.delegate?.error(client: self.client, response: model, error: .operation, message: "The opeartion is unknow in response data!")
        }
    }


    /// append the initial biodata services to cache list from the response data
    private func appendBiodataInitialList(list: [String]) {
        if list.contains("eeg") {
            if let _ = self.biodataInitialList {
                self.biodataInitialList?.insert(.EEG)
            } else {
                self.biodataInitialList = BiodataTypeOptions(arrayLiteral: .EEG)
            }
        }
        if list.contains("hr") {
            if let _ = self.biodataInitialList {
                self.biodataInitialList?.insert(.HeartRate)
            } else {
                self.biodataInitialList = BiodataTypeOptions(arrayLiteral: .HeartRate)
            }
        }
    }

    /// append the initial affective services to cache list from the response data
    private func appendEmotionAffectiveInitialList(list: [String]) {
        if list.contains("relaxation") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.relaxation)
            } else {
                self.emotionAffectiveInitialList = CSEmotionsAffectiveOptions(arrayLiteral: .relaxation)
            }
        }
        if list.contains("attention") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.attention)
            } else {
                self.emotionAffectiveInitialList = CSEmotionsAffectiveOptions(arrayLiteral: .attention)
            }
        }
        if list.contains("pleasure") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.pleasure)
            } else {
                self.emotionAffectiveInitialList = CSEmotionsAffectiveOptions(arrayLiteral: .pleasure)
            }
        }
        if list.contains("pressure") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.pressure)
            } else {
                self.emotionAffectiveInitialList = CSEmotionsAffectiveOptions(arrayLiteral: .pressure)
            }
        }
        if list.contains("arousal") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.arousal)
            } else {
                self.emotionAffectiveInitialList = CSEmotionsAffectiveOptions(arrayLiteral: .arousal)
            }
        }
    }
}
