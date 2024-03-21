//
//  SyncBiodataClient.swift
//  EnterAffectiveCloud
//
//  Created by Enter M1 on 2023/11/8.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation
import Starscream
import Gzip
import SmartCodable

protocol SyncRealtimeBiodataDelegate {
    func syncEEG(left: [Float], right: [Float], alpha: Float, beta: Float, theta: Float, delta: Float, gamma: Float, quality: Int)
    func syncHR(hr: Float, hrv: Float)
    func syncPEPR(hr: Float, rr: Float, hrv: Float, bcgWave: [Float], rwWave: [Float], bcgQuality: Int, rwQuality: Int)
    func syncRelaxation(_ data: Float)
    func syncAttention(_ data: Float)
    func syncFlow(_ data: Float)
    func syncCoherence(_ data: Float)
    func syncPressure(_ data: Float)
}

public protocol SyncRealtimeBiodataError: AnyObject {
    func error(message: String)
}

public class SyncRealtimeBiodata: SyncRealtimeBiodataDelegate {
    let socket: WebSocket
    var isContinue = false
    var disconnectCount = 0
    public weak var delegate: SyncRealtimeBiodataError?
    
    public init(websocketURL: URL) {
        self.socket = WebSocket(url: websocketURL)
        self.socket.delegate = self
    }
    
    public func start() {
        guard !socket.isConnected else {return}
        webSocketConnect()
    }
    
    public func stop() {
        isContinue = false
        webSocketDisConnect()
    }
    
    
    //MARK: WebSocketServiceProcotol
    public func webSocketConnect() {
        self.socket.connect()
    }

    private func webSocketSend(jsonString json: String) {

        guard socket.isConnected else {return}
        if let data = json.data(using: .utf8), let compressData =  try? data.gzipped() {
            self.socket.write(data: compressData)
        }
        
    }

    public func webSocketDisConnect() {
        self.socket.disconnect()
    }
    
    public func syncEEG(left: [Float], right: [Float], alpha: Float, beta: Float, theta: Float, delta: Float, gamma: Float, quality: Int) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncBiodataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "biodata"
        request.operation = "subscribe"
        model.request = request
        
        let data = CSBiodataProcessJSONModel()
        
        let eeg = CSBiodataEEGJsonModel()
        eeg.waveLeft = left
        eeg.waveRight = right
        eeg.alpha = alpha
        eeg.belta = beta
        eeg.theta = theta
        eeg.delta = delta
        eeg.gamma = gamma
        eeg.quality = Float(quality)
        data.eeg = eeg
        model.data = data
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
        
    }
    
    public func syncHR(hr: Float, hrv: Float) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncBiodataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "biodata"
        request.operation = "subscribe"
        model.request = request
        
        let data = CSBiodataProcessJSONModel()
        let hrData = CSBiodataHRJsonModel()
        hrData.hr = hr
        hrData.hrv = hrv
        data.hr = hrData
        model.data = data
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
    }
    
    public func syncPEPR(hr: Float, rr: Float, hrv: Float, bcgWave: [Float], rwWave: [Float], bcgQuality: Int, rwQuality: Int) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncBiodataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "biodata"
        request.operation = "subscribe"
        model.request = request
        
        let data = CSBiodataProcessJSONModel()
        let peprData = CSBiodataPEPRJsonModel()
        peprData.hr = Int(hr)
        peprData.hrv = hrv
        peprData.rr = rr
        peprData.bcgWave = bcgWave
        peprData.rwWave = rwWave
        peprData.bcgQuality = bcgQuality
        peprData.rwQuality = rwQuality
        data.pepr = peprData
        model.data = data
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
    }
    
    public func syncRelaxation(_ data: Float) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncAffectiveDataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "affective"
        request.operation = "subscribe"
        model.request = request
        let dataModel = CSAffectiveSubscribeProcessJsonModel()
        let valueModel = CSAffectiveJsonModel()
        valueModel.relaxation = data
        dataModel.relaxation = valueModel
        model.data = dataModel
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
    }
    
    public func syncAttention(_ data: Float) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncAffectiveDataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "affective"
        request.operation = "subscribe"
        model.request = request
        let dataModel = CSAffectiveSubscribeProcessJsonModel()
        let valueModel = CSAffectiveJsonModel()
        valueModel.attention = data
        dataModel.attention = valueModel
        model.data = dataModel
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
    }
    
    public func syncFlow(_ data: Float) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncAffectiveDataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "affective"
        request.operation = "subscribe"
        model.request = request
        let dataModel = CSAffectiveSubscribeProcessJsonModel()
        let valueModel = CSAffectiveJsonModel()
        valueModel.flow = data
        dataModel.flow = valueModel
        model.data = dataModel
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
    }
    
    public func syncCoherence(_ data: Float) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncAffectiveDataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "affective"
        request.operation = "subscribe"
        model.request = request
        let dataModel = CSAffectiveSubscribeProcessJsonModel()
        let valueModel = CSAffectiveJsonModel()
        valueModel.coherence = data
        dataModel.coherence = valueModel
        model.data = dataModel
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
    }
    
    public func syncPressure(_ data: Float) {
        guard self.socket.isConnected else {return}
        guard isContinue else {return}
        let model = SyncAffectiveDataJSONModel()
        model.code = 0
        let request = AffectiveCloudRequestJSONModel()
        request.services = "affective"
        request.operation = "subscribe"
        model.request = request
        let dataModel = CSAffectiveSubscribeProcessJsonModel()
        let valueModel = CSAffectiveJsonModel()
        valueModel.pressure = data
        dataModel.pressure = valueModel
        model.data = dataModel
        if let message = model.toJSONString() {
            webSocketSend(jsonString: message)
        }
    }
    
    
}

extension SyncRealtimeBiodata: WebSocketDelegate {
    public func websocketDidConnect(socket: Starscream.WebSocketClient) {
        disconnectCount = 0
    }
    
    public func websocketDidDisconnect(socket: Starscream.WebSocketClient, error: Error?) {
        if let error = error as? WSError {
            DLog("\(error.message)")
            if isContinue {
                delegate?.error(message: error.message)
            }
            
        }
        disconnectCount += 1
        if disconnectCount < 10 && isContinue {
            self.webSocketConnect()
        }
        
    }
    
    public func websocketDidReceiveMessage(socket: Starscream.WebSocketClient, text: String) {

        
    }
    
    public func websocketDidReceiveData(socket: Starscream.WebSocketClient, data: Data) {
        if let unGzipData = try? data.gunzipped() {
            let text = String(decoding: unGzipData, as: UTF8.self)
            let json = AffectiveCloudResponseJSONModel.deserialize(json: text)
            if json?.code == 0 {
                isContinue = true
            } else {
                delegate?.error(message: json?.message ?? "")
                isContinue = false
            }
        }
    }
    
    
}
