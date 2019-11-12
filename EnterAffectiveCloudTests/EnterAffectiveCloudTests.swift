//
//  EnterAffectiveCloudTests.swift
//  EnterAffectiveCloudTests
//
//  Created by Enter on 2019/11/1.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import XCTest
import EnterAffectiveCloud
import HandyJSON

class EnterAffectiveCloudTests: XCTestCase, AffectiveCloudResponseDelegate {

    let testWs = "wss://server-test.affectivecloud.cn/ws/algorithm/v1/"
    let kCloudServiceAppKey = "6eabf68e-760e-11e9-bd82-0242ac140006"
    let kCloudServiceAppSecret = "68a09cf8e4e06718b037c399f040fb7e"
    var aClient: AffectiveCloudClient?
    var isRestore: Bool = false
    
    override func setUp() {

        self.aClient = AffectiveCloudClient(websocketURLString: self.testWs)
        self.aClient?.affectiveCloudDelegate = self
    

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        aClient?.closeSession()
        aClient?.websocketDisconnect()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //var finish  = (false, false)

        let eegPath = Bundle.init(for: EnterAffectiveCloudTests.classForCoder()).path(forResource: "flowtime_eegdata", ofType: "txt")
        if let eegPath = eegPath  {
            do {
                let eegString = try String(contentsOf: URL(fileURLWithPath: eegPath), encoding: .utf8)
                let eegArray:[String] = eegString.components(separatedBy: ",")
                let eegValueArray = eegArray.map { (subs) -> Int in
                    return Int(subs)!
                }
                
                    
                    for i in stride(from: 0, to: eegValueArray.count-1, by: 600) {
                        var array: [Int] = []
                        for j in 0..<600 {
                            array.append(eegValueArray[i+j])
                        }
                        let data = Data(bytes: array, count: 2)
                        self.aClient?.appendBiodata(eegData: data)
                        Thread.sleep(forTimeInterval: 0.36)
                        
                    }
                    
                
            } catch {
                print(error)
            }
        }
        
        let hrPath = Bundle.init(for: EnterAffectiveCloudTests.classForCoder()).path(forResource: "flowtime_hrdata", ofType: "txt")
        if let hrPath = hrPath  {
            do {
                let hrString = try String(contentsOf: URL(fileURLWithPath: hrPath), encoding: .utf8)
                let hrArray:[String] = hrString.components(separatedBy: ",")
                let hrValueArray = hrArray.map { (subs) -> Int in
                    return Int(subs.trimmingCharacters(in: .newlines))!
                }

                for i in stride(from: 0, to: hrValueArray.count-1, by: 1) {
                    let array = [hrValueArray[i]]
                    let data = Data(bytes: array, count: 1)
                    self.aClient?.appendBiodata(eegData: data)
                    Thread.sleep(forTimeInterval: 0.2)
                }
            } catch {
                print(error)
            }
        }

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func websocketState(client: AffectiveCloudClient, state: CSState) {
        
    }
    
    func websocketConnect(client: AffectiveCloudClient) {
        if isRestore {
            client.restoreSession()
        } else {
            client.createAndAuthenticateSession(appKey: kCloudServiceAppKey, appSecret: kCloudServiceAppSecret, userID: "1")
        }
    }
    
    func websocketDisconnect(client: AffectiveCloudClient) {
        isRestore = true
    }
    
    func sessionCreateAndAuthenticate(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        // 开启生物信号
        client.initBiodataServices(services: [.EEG, .HeartRate])
        client.subscribeBiodataServices(services: [.eeg_all, .hr_all])

        // 开启情感数据
        client.startAffectiveDataServices(services: [.attention, .relaxation, .pleasure, .pressure])
        client.subscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
    }
    
    func sessionRestore(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func sessionClose(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        isRestore = false
    }
    
    func biodataServicesInit(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func biodataServicesSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let subscribe = response.dataModel?.toJSONString() {
            print(subscribe)
        }
    }
    
    func biodataServicesUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func biodataServicesUpload(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func biodataServicesReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func affectiveDataStart(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func affectiveDataSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let subscribe = response.dataModel?.toJSONString() {
            print(subscribe)
        }
    }
    
    func affectiveDataUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func affectiveDataReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func affectiveDataFinish(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        
    }
    
    func error(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel?, error: AffectiveCloudResponseError, message: String?) {
        
    }
    
    func error(client: AffectiveCloudClient, request: AffectiveCloudRequestJSONModel?, error: AffectiveCloudRequestError, message: String?) {
        
    }

}
