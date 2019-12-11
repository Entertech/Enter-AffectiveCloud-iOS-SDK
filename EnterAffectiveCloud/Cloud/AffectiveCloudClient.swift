//
//  CSClient.swift
//  Enter-AffectiveComputing-iOS-SDK
//
//  Created by Anonymous on 2019/8/13.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

public class AffectiveCloudClient {
    public weak var affectiveCloudDelegate: AffectiveCloudResponseDelegate! {
        didSet {
            self.cloudService?.delegate = affectiveCloudDelegate
        }
    }

    private var cloudService: AffectiveCloudServices?
    public init(websocketURL: URL, appKey: String, appSecret: String, userID: String) {
        self.cloudService = AffectiveCloudServices(wssURL: websocketURL)
        self.cloudService?.client = self
        self.cloudService?.appKey = appKey
        self.cloudService?.userID = userID
        self.cloudService?.appSecret = appSecret
        self.websocketConnect()
    }

    public init(websocketURLString: String, appKey: String, appSecret: String, userID: String) {
        self.cloudService = AffectiveCloudServices(ws: websocketURLString)
        self.cloudService?.client = self
        self.cloudService?.appKey = appKey
        self.cloudService?.userID = userID
        self.cloudService?.appSecret = appSecret
        self.websocketConnect()
    }

    //MARK: - websocket
    public func websocketConnect() {
        self.cloudService?.webSocketConnect()
    }

    public func websocketDisconnect() {
        self.cloudService?.webSocketDisConnect()
    }
    
    public func isWebsocketConnected() -> Bool {
        if self.cloudService?.state == .connected {
            return true
        } else {
            return false
        }
    }
    
    public func close() {
        if let services = cloudService?.affectiveService  {
            finishAffectiveDataServices(services: services)
            
        }
        closeSession()
        websocketDisconnect()
        self.cloudService = nil
    }

    //MARK: - session
    /// start cloud service.
    /// start succeed you will get `sessionCreate(response: CSResponseJSONModel)` response  in CSResponseDelegate
    ///
    /// - Parameter appKey: your app key from Cloud Service platform
    /// - Parameter appSecret: your app secret from Cloud Service platform
    /// - Parameter userName: your username from Cloud Service platform
    /// - Parameter userID: the unique ID of your app user
    public func createAndAuthenticateSession() {
        self.cloudService?.sessionCreate()
    }

    /// close cloud service
    /// firstly close biodata and affective services,  secondly close session finally close cloud service.
    public func closeSession() {
        self.cloudService?.sessionClose()
    }

    /// restore cloud service session
    public func restoreSession() {
        self.cloudService?.sessionRestore()
    }

    //MARK: - biodata
    /// start biodata services with parameter
    /// - Parameter services: biodata services. ps: .eeg and .hr
    /// - Parameter tolerance: 0-4 
    public func initBiodataServices(services: BiodataTypeOptions, tolerance: [String:Any]?=nil, sex: String? = nil, age: Int? = nil, sn: [String: Any]? = nil, source: [String: Any]? = nil,
    mode: String? = nil, cases: String? = nil) {
        self.cloudService?.bioService = services
        self.cloudService?.bioTolerance = tolerance
        self.cloudService?.sex = sex
        self.cloudService?.age = age
        self.cloudService?.sn = sn
        self.cloudService?.source = source
        self.cloudService?.mode = mode
        self.cloudService?.cased = cases
    }

    /// raw eeg data(the data from hardware) cache
    private var _eegBuffer = Data()
    /// the standard size of eeg data that upload to cloud service
    private let _eegBufferSize = 600
    /// Append brain raw data to cloud service from your hardware
    /// this is necessory if you want to use follow services:
    /// Biodata services: .eeg_wave_left、.eeg_wave_right、.eeg_alpha、.eeg_quality and so on.
    /// Affective services: .attention、.relaxtion and .pleasure
    /// - Parameter data: the brain raw data from the hardware
    public func appendBiodata(eegData: Data) {
        guard let _ = self.cloudService else { return }
        
        guard self.cloudService!.socket.isConnected else {
            _eegBuffer.removeAll()
            return
        }
        _eegBuffer.append(eegData)
        if _eegBuffer.count < _eegBufferSize {
            return
        }
        DLog("append brain data")
        let results = stride(from: _eegBuffer.startIndex, to: _eegBuffer.endIndex, by: _eegBufferSize).map({ start -> Data in
            let range = start..<(start + _eegBufferSize)
            let tempData = _eegBuffer.subdata(in: range)
            return tempData
        })

        for element in results {
            let data_int = element.map { Int($0) }
            self.cloudService?.biodataUpload(options: .EEG, eegData: data_int)
            if _eegBuffer.count >= _eegBufferSize {
                _eegBuffer.removeFirst(_eegBufferSize)
            }
        }
    }


    /// raw heart rate data(the data from hardware) cache
    private var _hrBuffer = Data()
    /// the standard size of heart rate that upload to cloud service
    private let _hrBufferSize = 2
    /// Append heart rate data to cloud service from your hardware
    /// this is necessory if you want to use follow services:
    /// Affective services: .arousal 、.pressure
    /// - Parameter data: the heart data from the hardware
    public func appendBiodata(hrData: Data) {
        guard let _ = self.cloudService else {return}
        
        guard self.cloudService!.socket.isConnected else {
            _hrBuffer.removeAll()
            return
        }
        _hrBuffer.append(hrData)
        if _hrBuffer.count < _hrBufferSize {
            return
        }
        let startIndex = _hrBuffer.startIndex
        let results = stride(from: startIndex, to: _hrBuffer.endIndex, by: _hrBufferSize).map({ start -> Data in
            let range = start..<(start + self._hrBufferSize)
            let tempData = self._hrBuffer.subdata(in: range)
            return tempData
        })

        for element in results {
            let data_int = element.map { Int($0) }
            DLog("upload hr data")
            self.cloudService?.biodataUpload(options: .HeartRate, hrData: data_int)
            if _hrBuffer.count >= _hrBufferSize {
                _hrBuffer.removeFirst(_hrBufferSize)
            }
            
        }
    }
    
    var sessionId: String? {
        get {
            return self.cloudService?.session_id
        }
    }

    /// By subscribing the specificed service,
    /// you will get the analyzed data in `biodataSubscribe(response: CSResponseJSONModel)` in CSResponseDelegate
    /// - Parameter services: biodata service .  reference: `BiodataSubscribeOptions`
    public func subscribeBiodataServices(services: BiodataParameterOptions) {
        //self.cloudService.biodataSubscribe(parameters: services)
        self.cloudService?.bioSubscription = services
    }

    /// unsubscribe the specificed service
    /// cloud service will stop response the analyzed data in the service.
    /// - Parameter services: biodata service .  reference: `BiodataSubscribeOptions`
    public func unsubscribeBiodataServices(services: BiodataParameterOptions) {
        self.cloudService?.biodataUnSubscribe(parameters: services)
    }

    /// generate the report according your service
    /// you will get the report data in `biodataReport(response: CSResponseJSONModel)` in CSResponseDelegate
    /// - Parameter services: biodata service .  reference: `BiodataSubscribeOptions`
    public func getBiodataReport(services: BiodataTypeOptions) {
        self.cloudService?.biodataReport(options: services)
    }

    //MARK: - Emotion

    /// start emotion(affective) services with parameter
    /// - Parameter services: emotion services list: like: .attention  .relaxation  .pleasure  .pressure and .arousal
    public func startAffectiveDataServices(services: AffectiveDataServiceOptions) {
        //self.cloudService.emotionStart(services: services)
        self.cloudService?.affectiveService = services
    }

    /// generate the report according your service
    /// you will get the report data in `affectiveReport(response: CSResponseJSONModel)` in CSResponseDelegate
    /// - Parameter services: emotion serivce
    public func getAffectiveDataReport(services: AffectiveDataServiceOptions) {
        self.cloudService?.emotionReport(services: services)
    }

    /// By subscribing the specificed service
    /// you will get the analyzed data in `affectiveSubscribe(response: CSResponseJSONModel)` in CSResponseDelegate
    /// - Parameter services: emotion service
    public func subscribeAffectiveDataServices(services: AffectiveDataSubscribeOptions) {
        //self.cloudService.emotionSubscribe(services: services)
        self.cloudService?.affectiveSubscription = services
    }

    /// unsubscribe the specificed service
    /// cloud service will stop response the analyzed data with the specified service.
    /// - Parameter services: emotion services
    public func unsubscribeAffectiveDataServices(services: AffectiveDataSubscribeOptions) {
        self.cloudService?.emotionUnSubscribe(services: services)
    }

    /// close emotion service with the sepecified service
    /// - Parameter services: emotion services
    public func finishAffectiveDataServices(services: AffectiveDataServiceOptions) {
        self.cloudService?.emotionClose(services: services)
    }
    
    public func submitTag(rec: [CSLabelSubmitJSONModel]) {
        self.cloudService?.biodataTagSubmit(recArray: rec)
    }
}
