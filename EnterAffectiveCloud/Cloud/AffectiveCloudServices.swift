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
class AffectiveCloudServices: WebSocketServiceProcotol {
    

    /// receive response data use delegate method
    weak var delegate: AffectiveCloudResponseDelegate?

    //MARK: initial websocket
    var state: CSState = .none {
        didSet {
            if state != oldValue {
                self.delegate?.websocketState(client: self.client, state: state)
                
                NotificationCenter.default.post(name: NSNotification.Name.websocketConnectNotify, object: nil, userInfo: ["connect" : state.rawValue])
                
            }
        }
    }
    var bIsLog: Bool = false
    var appKey: String? // could key
    var userID: String?
    var appSecret: String?
    var bioService: BiodataTypeOptions?
    var bioTolerance: [String:Any]?
    var bioSubscription: BiodataParameterOptions?
    var affectiveService: AffectiveDataServiceOptions?
    var affectiveSubscription: AffectiveDataSubscribeOptions?
    var uploadCycle: Int = 0
    var sex: String?
    var age: Int?
    var sn: [String: Any]?
    var source: [String: Any]?
    var mode: [Int]?
    var cased: [Int]?
    
    var isSessionCreated = false
    let socket: WebSocket
    var client: AffectiveCloudClient!
    var logUrlStr: String?
    var logUrl: URL?
    init(ws: String) {
        self.socket = WebSocket(url: URL(string: ws)!)
        self.socket.delegate = self
    }

    init(wssURL: URL) {
        self.socket = WebSocket(url: wssURL)
        self.socket.delegate = self
    }

    //MARK: WebSocketServiceProcotol
    func webSocketConnect() {
        self.socket.connect()
    }

    func webSocketSend(jsonString json: String) {
        logService(log: json)
        //compressed data with gzip
        if let data = json.data(using: .utf8), let compressData =  try? data.gzipped() {
            self.socket.write(data: compressData)
        }
    }

    func webSocketDisConnect() {
        self.socket.disconnect()
    }
    
    func sessionCreate() {
        guard let key = self.appKey, let secret = self.appSecret, let userID = self.userID  else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: The appKey id is empty, session create failed! Try restart cloud service.")
            return
        }
        let timeStamp = "\(Int(Date().timeIntervalSince1970))"
        let sign = sessionSign(appKey: key, appSecret: secret, userID: userID, timeStamp: timeStamp)
        
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }
        let requestModel = AffectiveCloudRequestJSONModel()
        requestModel.services = CSServicesType.session.rawValue
        requestModel.operation = CSSessionOperation.create.rawValue
        requestModel.kwargs = CSKwargsJSONModel()
        requestModel.kwargs?.app_key = key
        requestModel.kwargs?.sign = sign
        requestModel.kwargs?.userID = userID.hashed(.md5, output: .hex)!.uppercased()
        requestModel.kwargs?.timeStamp = timeStamp
        requestModel.kwargs?.uploadCycle = self.uploadCycle

        if let jsonstring = requestModel.toJSONString() {
            self.webSocketSend(jsonString: jsonstring)
        } else {
            self.delegate?.error(client: self.client, request: requestModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
        
    }
    
    private func sessionSign(appKey: String, appSecret: String, userID: String, timeStamp: String) -> String {

        let hashID = userID.hashed(.md5)!.uppercased()
        let sign_str = String(format: "app_key=%@&app_secret=%@&timestamp=%@&user_id=%@",appKey, appSecret, timeStamp, hashID)
        let sign = sign_str.hashed(.md5)!.uppercased()
        return sign
    }


    var session_id: String?  {
        willSet {
            if let value = newValue {
                UserDefaults.standard.setValue(value, forKey: "ac_session")
            } else {
                UserDefaults.standard.removeObject(forKey: "ac_session")
            }
            
        }
    }
    func sessionRestore() {
        
        guard let session = session_id, let key = self.appKey, let secret = self.appSecret, let userID = self.userID else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: The session id is empty, restore failed! Try restart cloud service.")
            return
        }
        let timeStamp = "\(Int(Date().timeIntervalSince1970))"
        
        let sign = sessionSign(appKey: key, appSecret: secret, userID: userID, timeStamp: timeStamp)
        
        let jsonModel = AffectiveCloudRequestJSONModel()
        jsonModel.services = CSServicesType.session.rawValue
        jsonModel.operation = CSSessionOperation.restore.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.sessionID = session
        jsonModel.kwargs?.app_key = key
        jsonModel.kwargs?.sign = sign
        jsonModel.kwargs?.userID = userID.hashed(.md5, output: .hex)!.uppercased()
        jsonModel.kwargs?.timeStamp = timeStamp
        jsonModel.kwargs?.uploadCycle = self.uploadCycle
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

        let jsonModel = AffectiveCloudRequestJSONModel()
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
    
    private func biodataSubscribeList(with options: BiodataParameterOptions) -> [String] {
        var servicesList = [String]()
        if options.contains(.eeg) {
            servicesList.append("eeg")
        }
        if options.contains(.hr) {
            servicesList.append("hr")
        }
        return servicesList
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
    private var emotionAffectiveInitialList: AffectiveDataServiceOptions?
}

//MARK: BiodataServiceProtocol imp
extension AffectiveCloudServices: BiodataServiceProtocol {

    func biodataInitial(options: BiodataTypeOptions, tolerance: [String:Any]?=nil,
                        sex: String? = nil, age: Int? = nil, sn: [String: Any]? = nil, source: [String: Any]? = nil,
                        mode: [Int]? = nil, cases: [Int]? = nil) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: session is empty,please create session or restore session!")
            return
        }

        let jsonModel = AffectiveCloudRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.initial.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        let biodataTypes = self.biodataTypeList(with: options)
        jsonModel.kwargs?.bioTypes = biodataTypes
        if let tolerance = tolerance {
            jsonModel.kwargs?.tolerance = tolerance
        }
    
        let storage = CSPersonalInfoJSONModel()
        if sex != nil || age != nil {
            let user = CSUserInfoJSONModel()
            user.sex = sex
            user.age = age
            storage.user = user
        }
        
        if mode != nil || cases != nil {
            let label = CSLabelInfoJSONModel()
            label.mode = mode
            label.cased = cases
            storage.label = label
        }

        storage.device = sn
        storage.data = source
        
        jsonModel.kwargs?.storageSettings = storage
  
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func biodataSubscribe(parameters options: BiodataParameterOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let biodataList = self.biodataSubscribeList(with: options)

        let jsonModel = AffectiveCloudRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.subscribe.rawValue
        jsonModel.args = biodataList

        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func biodataUnSubscribe(parameters options: BiodataParameterOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let jsonModel = AffectiveCloudRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.unsubscribe.rawValue
        jsonModel.args = self.biodataSubscribeList(with: options)
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

        let jsonModel = AffectiveCloudRequestJSONModel()
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
        let jsonModel = AffectiveCloudRequestJSONModel()
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
    
    func biodataTagSubmit(recArray: [CSLabelSubmitJSONModel]) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }
        
        let jsonModel = AffectiveCloudRequestJSONModel()
        jsonModel.services = CSServicesType.biodata.rawValue
        jsonModel.operation = CSBiodataOperation.submit.rawValue
        jsonModel.kwargs = CSKwargsJSONModel()
        jsonModel.kwargs?.rec = recArray
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
        
    }
}

//MARK: EmotionServiceProcotol
extension AffectiveCloudServices: CSEmotionServiceProcotol {

    func emotionStart(services: AffectiveDataServiceOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let jsonModel = AffectiveCloudRequestJSONModel()
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

    func emotionSubscribe(services: AffectiveDataSubscribeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        self.checkEmotionAffectiveIsInitial(subscribeList: services)

        let jsonModel = AffectiveCloudRequestJSONModel()
        jsonModel.services = CSServicesType.affective.rawValue
        jsonModel.operation = CSEmotionOperation.subscribe.rawValue
        let paramList = self.emotionSubscribeList(options: services)
        jsonModel.args = paramList
 
        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func emotionUnSubscribe(services: AffectiveDataSubscribeOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }


        let jsonModel = AffectiveCloudRequestJSONModel()
        jsonModel.services = CSServicesType.affective.rawValue
        jsonModel.operation = CSEmotionOperation.unsubscribe.rawValue
        let paramList = self.emotionSubscribeList(options: services)
        jsonModel.args = paramList

        if let jsonString = jsonModel.toJSONString() {
            self.webSocketSend(jsonString: jsonString)
        } else {
            self.delegate?.error(client: self.client, request: jsonModel, error: .jsonError, message: "CSRequestError: Json string is nil!")
        }
    }

    func emotionReport(services: AffectiveDataServiceOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        self.checkEmotionAffectiveIsInitial(affectiveList: services)

        let jsonModel = AffectiveCloudRequestJSONModel()
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

    func emotionClose(services: AffectiveDataServiceOptions) {
        guard self.socket.isConnected else {
            self.delegate?.error(client: self.client, request: nil, error: .unSocketConnected, message: "CSRequestError: Pleace check socket is connected!")
            return
        }

        guard let _ = self.session_id else {
            self.delegate?.error(client: self.client, request: nil, error: .noSession, message: "CSRequestError: Session is empty,please create session or restore session!")
            return
        }

        let jsonModel = AffectiveCloudRequestJSONModel()
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

    private func serviceList(options: AffectiveDataServiceOptions) -> [String] {
        var list = [String]()
        if options.contains(.attention) {
            list.append("attention")
        }

        if options.contains(.relaxation) {
            list.append("relaxation")
        }
        
        if options.contains(.attention_child) {
            list.append("attention_chd")
        }
        
        if options.contains(.relaxation_child) {
            list.append("relaxation_chd")
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
        
        if options.contains(.coherence) {
            list.append("coherence")
        }

        return list
    }
    
    private func emotionSubscribeList(options: AffectiveDataSubscribeOptions) -> [String] {
        var list = [String]()
        if options.contains(.attention) {
            list.append("attention")
        }

        if options.contains(.relaxation) {
            list.append("relaxation")
        }
        
        if options.contains(.attention_child) {
            list.append("attention_chd")
        }
        
        if options.contains(.relaxation_child) {
            list.append("relaxation_chd")
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
        
        if options.contains(.coherence) {
            list.append("coherence")
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
        
        if options.contains(.attention_child_all) {
            list.insert("attention_chd_avg")
            list.insert("attention_chd_rec")
        }
        
        if options.contains(.attention_child_average) {
            list.insert("attention_chd_avg")
        }
        
        if options.contains(.attention_child_curve) {
            list.insert("attention_chd_rec")
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
        
        if options.contains(.relaxation_child_all) {
            list.insert("relaxation_chd_avg")
            list.insert("relaxation_chd_rec")
        }
        
        if options.contains(.relaxation_child_average) {
            list.insert("relaxation_chd_avg")
        }
        
        if options.contains(.relaxation_child_curve) {
            list.insert("relaxation_chd_rec")
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
        if options.contains(.coherence_all) {
            list.insert("coherence_avg")
            list.insert("coherence_rec")
        }
        if options.contains(.coherence_average) {
            list.insert("coherence_avg")
        }
        if options.contains(.coherence_curve) {
            list.insert("coherence_rec")
        }
        return list
    }

    private func checkEmotionAffectiveIsInitial(subscribeList: AffectiveDataSubscribeOptions) {
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
        
        if let flag = self.emotionAffectiveInitialList?.contains(.attention_child),
            subscribeList.contains(.attention_child) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Attention Child unvailable, please start attention service first!")
                return
            }
        }
        
        if let flag = self.emotionAffectiveInitialList?.contains(.relaxation_child),
            subscribeList.contains(.relaxation_child) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Relaxation Child unvailable, please start relaxation service first!")
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
        
        if let flag = self.emotionAffectiveInitialList?.contains(.coherence),
            subscribeList.contains(.coherence){
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Coherence unvailable, please start coherence service first!")
                return
            }
        }
    }

    private func checkEmotionAffectiveIsInitial(affectiveList: AffectiveDataServiceOptions) {
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
        
        if let flag = self.emotionAffectiveInitialList?.contains(.attention_child),
            affectiveList.contains(.attention_child) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Attention child unvailable, generate report failed!")
                return
            }
        }
        
        if let flag = self.emotionAffectiveInitialList?.contains(.relaxation_child),
            affectiveList.contains(.relaxation_child) {
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Relaxation child unvailable, generate report failed!")
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
        
        if let flag = self.emotionAffectiveInitialList?.contains(.coherence),
            affectiveList.contains(.coherence){
            if !flag {
                self.delegate?.error(client: self.client, request: nil, error: .noAffectiveService, message: "CSRequestError: Coherence unvailable, please start coherence service first!")
                return
            }
        }
    }
    
    func logService(log: String) {
        if bIsLog {
            if let url = logUrlStr {
                if logUrl == nil {
                    logUrl = URL.init(fileURLWithPath: url)
                }
                DispatchQueue.global().async {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let logStr = "\(formatter.string(from: Date())) \(log) \n"
                    let data = Data(logStr.utf8)
                    do {
                        try data.write(to: self.logUrl!, options: .atomic)
                        //try logStr.write(toFile: url, atomically: true, encoding: .utf8)
                    } catch let error as Error {
                        print("log erorr \(error.localizedDescription)")
                    }
                    
                
                }
                
            }
        }
    }
}

extension AffectiveCloudServices: WebSocketDelegate {
    //MARK: web socket delegate
    func websocketDidConnect(socket: WebSocketClient) {
        if self.state == .connected {
            return
        }
        self.state = .connected
        self.delegate?.websocketConnect(client: self.client)
        if let _ = session_id {
            if !isSessionCreated {
                sessionRestore()
            }
        } else {
            sessionCreate()
        }
        logService(log: "WS Connect")
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if self.state == .disconnected {
            return
        }
        self.state = .disconnected
        self.delegate?.websocketDisconnect(client: self.client, error: error)
        self.isSessionCreated = false
        logService(log: "WS Disconnect")
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        DLog("response data is \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        if let unGzipData = try? data.gunzipped() {
            let text = String(decoding: unGzipData, as: UTF8.self)
            DLog("response data is \(text)")
            if let responseModel = AffectiveCloudResponseJSONModel.deserialize(from: text) {
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
    private func handleErrorWithResponse(model: AffectiveCloudResponseJSONModel) -> Bool {
        switch model.code {
        case 400:
            self.delegate?.error(client: self.client, response: model, error: .requestException, message: "Request exception!!")
            return true
        case 404:
            self.delegate?.error(client: self.client, response: model, error: .notFoundServer, message: "Service not exist!")
            return true
        case 407:
            self.delegate?.error(client: self.client, response: model, error: .auth, message: "The app_key or sign error!")
            return true
        case 401..<5000:
            self.delegate?.error(client: self.client, response: model, error: .unKnow, message: "Error Code: \(model.code), \(model.message ?? "Unknow error")")
            return true
        default:
            break
        }
        return false
    }

    /// Handle response data
    /// you can get data use `CSResponseDelegate` in your code
    private func handleResponse(with model: AffectiveCloudResponseJSONModel) {
        self.logService(log: model.toJSONString() ?? "Nothing")
        if let request = model.request {
            switch (request.services, request.operation) {
            case (CSServicesType.session.rawValue, CSSessionOperation.create.rawValue):
                if let dataModel = model.dataModel as? CSResponseDataJSONModel,
                    let id = dataModel.sessionID {
                    self.logUrlStr = id
                    self.session_id = id
                    self.isSessionCreated = true
                    if let bioServices = self.bioService  {
                        self.biodataInitial(options: bioServices, tolerance: self.bioTolerance, sex: sex, age: age, sn: sn, source: source, mode: mode, cases: cased)
                    }
                    if let affService = self.affectiveService {
                        self.emotionStart(services: affService)
                    }
                    
                }
                self.delegate?.sessionCreateAndAuthenticate(client: self.client, response: model)
            case (CSServicesType.session.rawValue, CSSessionOperation.restore.rawValue):
                self.delegate?.sessionRestore(client: self.client, response: model)
                if model.code == 0 {
                    self.isSessionCreated = true
                    if let bioServices = self.bioService  {
                        self.biodataInitial(options: bioServices, tolerance: self.bioTolerance, sex: sex, age: age, sn: sn, source: source, mode: mode, cases: cased)
                    }
                    if let affService = self.affectiveService {
                        self.emotionStart(services: affService)
                    }
                }
                
            case (CSServicesType.session.rawValue, CSSessionOperation.close.rawValue):
                self.delegate?.sessionClose(client: self.client, response: model)
                self.isSessionCreated = false
                self.session_id = nil
                self.logUrlStr = nil
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.initial.rawValue):
                if let biodata = model.dataModel as? CSResponseDataJSONModel,
                    let list = biodata.biodataList {
                    self.appendBiodataInitialList(list: list)
                    if let subs = self.bioSubscription {
                        
                        self.biodataSubscribe(parameters: subs)
                    }
                }
                self.delegate?.biodataServicesInit(client: self.client, response: model)
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

                self.delegate?.biodataServicesSubscribe(client: self.client, response: model)
                NotificationCenter.default.post(name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil, userInfo: ["biodataServicesSubscribe":model])
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.submit.rawValue):
                NotificationCenter.default.post(name: NSNotification.Name.biodataTagSubmitNotify, object: nil, userInfo: ["biodataTagSubmit":model])
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.unsubscribe.rawValue):
                self.delegate?.biodataServicesUnsubscribe(client: self.client, response: model)
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.upload.rawValue):
                self.delegate?.biodataServicesUpload(client: self.client, response: model)
            case (CSServicesType.biodata.rawValue, CSBiodataOperation.report.rawValue):
                self.delegate?.biodataServicesReport(client: self.client, response: model)
                NotificationCenter.default.post(name: NSNotification.Name.biodataServicesReportNotify, object: nil, userInfo: ["biodataServicesReport":model])
            case (CSServicesType.affective.rawValue, CSEmotionOperation.start.rawValue):
                if let dataModel = model.dataModel as? CSResponseDataJSONModel{
                    if let list = dataModel.affectiveList {
                        self.appendEmotionAffectiveInitialList(list: list)
                    }
                }
                if model.code == 0 {
                    if let subs = self.affectiveSubscription {
                        self.emotionSubscribe(services: subs)
                    }
                }
                self.delegate?.affectiveDataStart(client: self.client, response: model)
            case (CSServicesType.affective.rawValue, CSEmotionOperation.subscribe.rawValue):
                if let dataModel = model.dataModel as? CSAffectiveSubscribeProcessJsonModel {
                    DLog("affective data is \(dataModel.isNil())")
                }
                self.delegate?.affectiveDataSubscribe(client: self.client, response: model)
                NotificationCenter.default.post(name: NSNotification.Name.affectiveDataSubscribeNotify, object: nil, userInfo: ["affectiveDataSubscribe":model])
            case (CSServicesType.affective.rawValue, CSEmotionOperation.unsubscribe.rawValue):
                self.delegate?.affectiveDataUnsubscribe(client: self.client, response: model)
            case (CSServicesType.affective.rawValue, CSEmotionOperation.report.rawValue):
                self.delegate?.affectiveDataReport(client: self.client, response: model)
                NotificationCenter.default.post(name: NSNotification.Name.affectiveDataReportNotify, object: nil, userInfo: ["affectiveDataReport":model])
            case (CSServicesType.affective.rawValue, CSEmotionOperation.finish.rawValue):
                self.delegate?.affectiveDataFinish(client: self.client, response: model)
                
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
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .relaxation)
            }
        }
        if list.contains("attention") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.attention)
            } else {
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .attention)
            }
        }
        if list.contains("relaxation_chd") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.relaxation_child)
            } else {
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .relaxation)
            }
        }
        if list.contains("attention_chd") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.attention_child)
            } else {
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .attention)
            }
        }
        if list.contains("pleasure") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.pleasure)
            } else {
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .pleasure)
            }
        }
        if list.contains("pressure") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.pressure)
            } else {
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .pressure)
            }
        }
        if list.contains("arousal") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.arousal)
            } else {
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .arousal)
            }
        }
        
        if list.contains("coherence") {
            if let _ = self.emotionAffectiveInitialList {
                self.emotionAffectiveInitialList?.insert(.coherence)
            } else {
                self.emotionAffectiveInitialList = AffectiveDataServiceOptions(arrayLiteral: .coherence)
            }
        }
    }
}
