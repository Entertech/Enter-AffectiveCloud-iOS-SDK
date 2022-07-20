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
    
    public var bIsLogToLocal = false {
        willSet {
            self.cloudService?.bIsLogToLocal = newValue
        }
    }
    
    public var bIsLogWhenDebug = true {
        willSet {
            __isDebug = newValue
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

    public init(websocketURLString: String, appKey: String?=nil, appSecret: String?=nil, userID: String?=nil) {
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
        
    }

    //MARK: - session
    /// start cloud service.
    /// start succeed you will get `sessionCreate(response: CSResponseJSONModel)` response  in CSResponseDelegate
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
    /// - Parameters:
    ///   - services: biodata services. ps: .eeg and .hr
    ///   - tolerance: 0-4, default 2
    ///   - uploadCycle: upload interval, default 3 (3*0.6second)
    ///   - filterMode: filterMode
    ///   - powerMode: powerMode
    ///   - channelPowerVerbose: channelPowerVerbose
    public func initBiodataServices(services: BiodataTypeOptions, tolerance: Int? = 2, uploadCycle:UInt = 3, filterMode: FilterMode? = .smart, powerMode: PowerMode? = .rate, channelPowerVerbose: Bool? = false) {
        self.cloudService?.uploadCycle = Int(uploadCycle)
        if uploadCycle == 0 {
            _hrBufferSize = 2
            _eegBufferSize = 600
        } else {
            _hrBufferSize = minHrCycle * Int(uploadCycle)
            _eegBufferSize = minEegCycle * Int(uploadCycle)
            _peprBufferSize = minPeprCycle * Int(uploadCycle)
        }
        self.cloudService?.bioService = services
        let param = BiodataAlgorithmParams()
        let eeg = AlgorithmParamJSONModel()
        if let tolerance = tolerance {
            eeg.tolerance = tolerance
        }
        if let filterMode = filterMode {
            eeg.filterMode = filterMode
        }
        if let powerMode = powerMode {
            eeg.powerMode = powerMode
        }
        if let verbose = channelPowerVerbose {
            eeg.channelPower = verbose
        }
        param.eeg = eeg
        self.cloudService?.bioEEGParam = param
    }
    
    /// set up experiment param
    /// - Parameters:
    ///   - sex: user's gender for experiment
    ///   - age: user's age for experiment
    ///   - sn: user's series number for experiment
    ///   - source: source description for experiment
    ///   - mode: mode description for experiment
    ///   - cases: cases description for experiment
    public func initExperimentService(sex: String? = nil, age: Int? = nil, sn: [String: Any]? = nil, source: [String: Any]? = nil,
    mode: [Int]? = nil, cases: [Int]? = nil) {
        self.cloudService?.sex = sex
        self.cloudService?.age = age
        self.cloudService?.sn = sn
        self.cloudService?.source = source
        self.cloudService?.mode = mode
        self.cloudService?.cased = cases
    }

    private var minEegCycle = 1000
    /// raw eeg data(the data from hardware) cache
    private var _eegBuffer = Data()
    /// the standard size of eeg data that upload to cloud service
    private var _eegBufferSize = 3000
    /// Append brain raw data to cloud service from your hardware
    /// this is necessory if you want to use follow services:
    /// Biodata services: .eeg_wave_left、.eeg_wave_right、.eeg_alpha、.eeg_quality and so on.
    /// Affective services: .attention、.relaxtion and .pleasure
    /// - Parameter data: the brain raw data from the hardware
    public func appendBiodata(eegData: Data) {
        guard let _ = self.cloudService else { return }
        guard let _ = self.sessionId else {return}
        
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


    private var minHrCycle = 3
    /// raw heart rate data(the data from hardware) cache
    private var _hrBuffer = Data()
    /// the standard size of heart rate that upload to cloud service
    private var _hrBufferSize = 9
    private var _limitDate = Date()
    /// Append heart rate data to cloud service from your hardware
    /// this is necessory if you want to use follow services:
    /// Affective services: .arousal 、.pressure
    /// - Parameter data: the heart data from the hardware
    public func appendBiodata(hrData: Data, options: BiodataTypeOptions = .HeartRateV2) {
        guard let _ = self.cloudService else {return}
        guard let _ = self.sessionId else {return}
        guard self.cloudService!.socket.isConnected else {
            _hrBuffer.removeAll()
            return
        }
        _hrBuffer.append(hrData)
        if _hrBuffer.count < _hrBufferSize {
            return
        }
        let current = Date()
        let stride = abs(current.timeIntervalSince(_limitDate))
        if stride < 0.6*Double(self.cloudService?.uploadCycle ?? 3) - 0.2 {
            return
        }
        let array = [UInt8](_hrBuffer).map { value in
            return Int(value)
        }
        let preArray = Array(array.prefix(_hrBufferSize))
        self.cloudService?.biodataUpload(options: options, hrData: preArray)
        _hrBuffer.removeFirst(_hrBufferSize)
        _limitDate = current
        
//        let startIndex = _hrBuffer.startIndex
//        let results = stride(from: startIndex, to: _hrBuffer.endIndex, by: _hrBufferSize).map({ start -> Data in
//            let range = start..<(start + self._hrBufferSize)
//            let tempData = self._hrBuffer.subdata(in: range)
//            return tempData
//        })
//
//        for element in results {
//            let data_int = element.map { Int($0) }
//            DLog("upload hr data")
//            self.cloudService?.biodataUpload(options: options, hrData: data_int)
//            if _hrBuffer.count >= _hrBufferSize {
//                _hrBuffer.removeFirst(_hrBufferSize)
//            }
//        }
    }
    
    private var minPeprCycle = 225
    
    private var _peprBuffer = Data()
    
    private var _peprBufferSize = 675
    
    public func appendBiodata(peprData: Data, options: BiodataTypeOptions = .PEPR) {
        guard let cloudService = self.cloudService else {return}
        guard self.sessionId != nil else {return}
        guard cloudService.socket.isConnected else {
            _peprBuffer.removeAll()
            return
        }
        _peprBuffer.append(peprData)
        if _peprBuffer.count < _peprBufferSize {
            return
        }
        let results = [UInt8](_peprBuffer)
        let data_int = results.map { Int($0) }
        _peprBuffer.removeAll()
        self.cloudService?.biodataUpload(options: options, peprData: data_int)
        
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
        self.cloudService?.bioSubscription = services
    }

    /// Unsubscribe the specificed service
    /// cloud service will stop response the analyzed data in the service.
    /// - Parameter services: biodata service .  reference: `BiodataSubscribeOptions`
    public func unsubscribeBiodataServices(services: BiodataParameterOptions) {
        self.cloudService?.biodataUnSubscribe(parameters: services)
    }

    /// Generate the report according your service
    /// you will get the report data in `biodataReport(response: CSResponseJSONModel)` in CSResponseDelegate
    /// - Parameter services: biodata service .  reference: `BiodataSubscribeOptions`
    public func getBiodataReport(services: BiodataTypeOptions) {
        self.cloudService?.biodataReport(options: services)
    }

    //MARK: - Emotion

    /// start emotion(affective) services with parameter
    /// - Parameter services: emotion services list: like: .attention  .relaxation  .pleasure  .pressure and .arousal
    public func startAffectiveDataServices(services: AffectiveDataServiceOptions) {
        self.cloudService?.affectiveService = services
    }

    /// Generate the report according your service
    /// you will get the report data in `affectiveReport(response: CSResponseJSONModel)` in CSResponseDelegate
    /// - Parameter services: emotion serivce
    public func getAffectiveDataReport(services: AffectiveDataServiceOptions) {
        self.cloudService?.emotionReport(services: services)
    }

    /// By subscribing the affective service
    /// you will get the analyzed data in `affectiveSubscribe(response: CSResponseJSONModel)` in CSResponseDelegate
    /// - Parameter services: emotion service
    public func subscribeAffectiveDataServices(services: AffectiveDataSubscribeOptions) {
        self.cloudService?.affectiveSubscription = services
    }

    /// Unsubscribe the affective service
    /// cloud service will stop response the analyzed data with the specified service.
    /// - Parameter services: emotion services
    public func unsubscribeAffectiveDataServices(services: AffectiveDataSubscribeOptions) {
        self.cloudService?.emotionUnSubscribe(services: services)
    }

    /// Close Affective service with the sepecified service
    /// - Parameter services: emotion services
    public func finishAffectiveDataServices(services: AffectiveDataServiceOptions) {
        self.cloudService?.emotionClose(services: services)
    }
    
    /// Experiment tag
    /// - Parameter rec: tag infomation struct array
    public func submitTag(rec: [CSLabelSubmitJSONModel]) {
        self.cloudService?.biodataTagSubmit(recArray: rec)
    }
}
