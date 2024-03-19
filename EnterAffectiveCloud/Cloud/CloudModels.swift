//
//  CloudModels.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import SmartCodable

enum BiodataType: String {
    case eeg
    case hr
    case hr2 = "hr-v2"
    case bcg
    case mceeg
    case pepr
}

//MARK: Request Models
public class AffectiveCloudRequestJSONModel: SmartCodable {
    var services: String = ""
    var operation: String = ""
    @SmartOptional var kwargs: CSKwargsJSONModel?
    var args: [String]?
    public required init() { }

    enum CodingKeys: String, CodingKey {
        case services
        case operation = "op"
        case kwargs
        case args
    }
}

public class CSRequestDataJSONModel: SmartCodable {
    var eeg: [Int]?
    var hr: [Int]?
    var pepr: [Int]?
    public required init() { }
}

class CSKwargsJSONModel: SmartCodable {
    var bioTypes: [String]?
    var tolerance: [String:SmartAny]?
    var additional: [String:SmartAny]?
    @SmartOptional var algorithmParam: BiodataAlgorithmParams?
    @SmartOptional var storageSettings: CSPersonalInfoJSONModel?
    var app_key: String?
    var sign: String?
    var userID: String?
    var timeStamp: String?
    var uploadCycle: Int?
    var device: String?
    @SmartOptional var data: CSRequestDataJSONModel?
    var sessionID: String?
    var reportType: String?
    var eegData: [Int]?
    var hrData: [Int]?
    var peprData: [Int]?
    var rec: [CSLabelSubmitJSONModel]?
    var affectiveTypes: [String]?
    var attenionServieces: [String]?
    var relaxationServices: [String]?
    var attenionChildServieces: [String]?
    var relaxationChildServices: [String]?
    var pressureServices: [String]?
    var pleasureServices: [String]?
    var arousalServices: [String]?
    var coherenceServices: [String]?
    var flowServices: [String]?
    required init() { }

    enum CodingKeys: String, CodingKey {
        case reportType = "gr"
        case sessionID = "session_id"
        case eegData = "eeg"
        case hrData = "hr-v2"
        case peprData = "pepr"
        case userID = "user_id"
        case bioTypes = "bio_data_type"
        case tolerance = "bio_data_tolerance"
        case additional = "additional_data"
        case affectiveTypes = "cloud_services"
        case attenionServieces = "attention"
        case relaxationServices = "relaxation"
        case attenionChildServieces = "attention_chd"
        case relaxationChildServices = "relaxation_chd"
        case pressureServices = "pressure"
        case pleasureServices = "pleasure"
        case arousalServices = "arousal"
        case timeStamp = "timestamp"
        case uploadCycle = "upload_cycle"
        case storageSettings = "storage_settings"
        case coherenceServices = "coherence"
        case algorithmParam = "algorithm_params"
        case flowServices = "meditation"
        case rec
        case data
        case device
        case sign
    }
}

//MARK: Response Models
public class AffectiveCloudResponseJSONModel: SmartCodable {
    public var code: Int = 0
    @SmartOptional public var request: AffectiveCloudRequestJSONModel?
    public var data: String?
    var message: String?
    public required init() { }

    enum CodingKeys: String, CodingKey {
        case code
        case request
        case data
        case message = "msg"
    }

   
    public var dataModel: SmartCodable? {
        
        return deserilizedStringToJsonModel(dic: self.data)
    }

    private func deserilizedStringToJsonModel(dic rawString: String?) -> SmartCodable? {
        guard let rawString = rawString ,let req = request else { return nil }
        switch (req.services, req.operation) {
        case ("session", "create"), ("biodata", "init"), ("affective", "start"),  ("affective", "finish"):
            if let data = CSResponseDataJSONModel.deserialize(json: rawString) {
                return data
            }
        case ("biodata", "subscribe"):
            if let biodataProcess = CSBiodataProcessJSONModel.deserialize(json: rawString), !biodataProcess.isNil() {
                return biodataProcess
            }

            if let data = CSResponseBiodataSubscribeJSONModel.deserialize(json: rawString), !data.isNil() {
                return data
            }

        case ("biodata", "unsubscribe"):
            if let data = CSResponseBiodataSubscribeJSONModel.deserialize(json: rawString) {
                return data
            }
        case ("biodata", "report"):
            if let biodataReport = CSBiodataReportJsonModel.deserialize(json: rawString) {
                return biodataReport
            }
        case ("affective", "subscribe"):
            if let responseSubscribe = CSAffectiveSubscribeJsonModel.deserialize(json: rawString), !responseSubscribe.isNil() {
                return responseSubscribe
            }

            if let affectiveProcess = CSAffectiveSubscribeProcessJsonModel.deserialize(json: rawString), !affectiveProcess.isNil() {
                return affectiveProcess
            }

        case ("affective", "unsubscribe"):
            if let response = CSAffectiveSubscribeJsonModel.deserialize(json: rawString) {
                return response
            }
        case ("affective", "report"):
            if let report = CSAffectiveReportJsonModel.deserialize(json: rawString) {
                return report
            }
        default:
            return nil
        }

        return nil
    }
}

// Data model
public class CSResponseDataJSONModel: SmartCodable {
    public var sessionID: String?
    public var biodataList: [String]?
    public var affectiveList: [String]?
    public required init() { }
    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
        case biodataList = "bio_data_type"
        case affectiveList = "cloud_service"
    }
}


/*
 *  subscription
 */
public class CSResponseBiodataSubscribeJSONModel: SmartCodable {
    public var eegServiceList: [String]?
    public var hrServiceList: [String]?
    public var peprServiceList: [String]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case eegServiceList = "sub_eeg_fields"
        case hrServiceList = "sub_hr_fields"
        case peprServiceList = "sub_pepr_fields"
    }

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.eegServiceList == nil)&&(self.hrServiceList == nil)&&(self.peprServiceList == nil)
    }
}

/* Realtime Biodata
 * eeg: 实时脑电数据
 * hr: 实时心率数据
 */
public class CSBiodataProcessJSONModel: SmartCodable {
    @SmartOptional public var eeg: CSBiodataEEGJsonModel?
    @SmartOptional public var hr: CSBiodataHRJsonModel?
    @SmartOptional public var pepr: CSBiodataPEPRJsonModel?
    public required init() {}

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.eeg == nil)&&(self.hr == nil)&&(self.pepr == nil)
    }

    enum CodingKeys: String, CodingKey {
        case hr = "hr-v2"
        case eeg
        case pepr
    }
    
}


/* Realtime brain rhythm
 *
 * waveRight: 脑电波片段：右通道。数组长度 100 (-2.4 * e6 ~ 2.4 * e6)
 * waveLeft: 脑电波片段：左通道。数组长度 100 (-2.4 * e6 ~ 2.4 * e6)
 * alpha: 脑电α频段能量占比 (0 ~ 1)
 * belta: 脑电β频段能量占比 (0 ~ 1)
 * theta: 脑电θ频段能量占比 (0 ~ 1)
 * delta: 脑电δ频段能量占比 (0 ~ 1)
 * gamma: 脑电γ频段能量占比 (0 ~ 1)
 * eeg_quality: 脑电信号质量进度 (0 ~ 4)，
 *              数值越大信号越好。
 */
public class CSBiodataEEGJsonModel: SmartCodable {
    public var waveRight: [Float]?
    public var waveLeft: [Float]?
    public var alpha: Float?
    public var belta: Float?
    public var theta: Float?
    public var delta: Float?
    public var gamma: Float?
    public var alphaLeft: Float?
    public var beltaLeft: Float?
    public var thetaLeft: Float?
    public var deltaLeft: Float?
    public var gammaLeft: Float?
    public var qualityLeft: Float?
    public var alphaRight: Float?
    public var beltaRight: Float?
    public var thetaRight: Float?
    public var deltaRight: Float?
    public var gammaRight: Float?
    public var quality: Float?
    public required init() {}
    
    enum CodingKeys: String, CodingKey {
        case waveLeft = "eegl_wave"
        case waveRight = "eegr_wave"
        case alpha = "eeg_alpha_power"
        case belta = "eeg_beta_power"
        case theta = "eeg_theta_power"
        case delta = "eeg_delta_power"
        case gamma = "eeg_gamma_power"
        case quality = "eeg_quality"
        case alphaLeft = "eegl_alpha_power"
        case beltaLeft = "eegl_beta_power"
        case thetaLeft = "eegl_theta_power"
        case deltaLeft = "eegl_delta_power"
        case gammaLeft = "eegl_gamma_power"
        case alphaRight = "eegr_alpha_power"
        case beltaRight = "eegr_beta_power"
        case thetaRight = "eegr_theta_power"
        case deltaRight = "eegr_delta_power"
        case gammaRight = "eegr_gamma_power"
    }
    
    
}

/* Realtime hear rate
 *
 * hr: 心率值
 * hrv: 心率变异性
 *
 */
public class CSBiodataHRJsonModel: SmartCodable {
    public var hr: Float?
    public var hrv: Float?
    public required init() {}
}

/* Realtime hear rate
 *
 * 'bcg_wave': [float],  # 脉搏波波形
 * 'rw_wave': [float],  # 呼吸波波形
 * 'bcg_quality': int,  # 脉搏波信号质量等级
 * 'rw_quality': int,  # 呼吸波信号质量等级
 * 'hr': int,  # 心率
 * 'rr': int,  # 呼吸率
 * 'hrv': float  # 心率变异性
 *
 */
public class CSBiodataPEPRJsonModel: SmartCodable {
    public var bcgQuality: Int?
    public var rwQuality: Int?
    public var hr: Int?
    public var rr: Float?
    public var hrv: Float?
    public var bcgWave: [Float]?
    public var rwWave: [Float]?
    public required init() {}
    
    enum CodingKeys: String, CodingKey {
        case bcgWave = "bcg_wave"
        case rwWave = "rw_wave"
        case bcgQuality = "bcg_quality"
        case rwQuality = "rw_quality"
        case hr
        case rr
        case hrv
    }
}

/* Biodata Report
 *
 * eeg: 脑电综合报表
 * hr: 心率综合报表
 */
public class CSBiodataReportJsonModel: SmartCodable {
    @SmartOptional public var eeg: CSBiodataReportEEGJsonModel?
    @SmartOptional public var hr: CSBiodataReportHRJsonModel?
    @SmartOptional public var pepr: CSBiodataReportPEPRJsonModel?

    public required init() {}

    enum CodingKeys: String, CodingKey {
        case hr = "hr-v2"
        case eeg
        case pepr
    }
}

/* Brain rhythm Report
 *
 * alphaCurve: 脑电α频段能量变化曲线
 * betaCurve: 脑电β频段能量变化曲线
 * thetaCurve: 脑电θ频段能量变化曲线
 * deltaCurve: 脑电δ频段能量变化曲线
 * gammaCurve: 脑电γ频段能量变化曲线
 *
 */
public class CSBiodataReportEEGJsonModel: SmartCodable {
    public var alphaCurve: [Float]?
    public var betaCurve: [Float]?
    public var thetaCurve: [Float]?
    public var deltaCurve: [Float]?
    public var gammaCurve: [Float]?
    public var alphaLeftCurve: [Float]?
    public var betaLeftCurve: [Float]?
    public var thetaLeftCurve: [Float]?
    public var deltaLeftCurve: [Float]?
    public var gammaLeftCurve: [Float]?
    public var alphaRightCurve: [Float]?
    public var betaRightCurve: [Float]?
    public var thetaRightCurve: [Float]?
    public var deltaRightCurve: [Float]?
    public var gammaRightCurve: [Float]?
    public required init() {}
    
    enum CodingKeys: String, CodingKey {
        case alphaCurve = "eeg_alpha_curve"
        case betaCurve = "eeg_beta_curve"
        case thetaCurve = "eeg_theta_curve"
        case deltaCurve = "eeg_delta_curve"
        case gammaCurve = "eeg_gamma_curve"
        case alphaLeftCurve = "eegl_alpha_curve"
        case betaLeftCurve = "eegl_beta_curve"
        case thetaLeftCurve = "eegl_theta_curve"
        case deltaLeftCurve = "eegl_delta_curve"
        case gammaLeftCurve = "eegl_gamma_curve"
        case alphaRightCurve = "eegr_alpha_curve"
        case betaRightCurve = "eegr_beta_curve"
        case thetaRightCurve = "eegr_theta_curve"
        case deltaRightCurve = "eegr_delta_curve"
        case gammaRightCurve = "eegr_gamma_curve"
    }
}

/*  Heart Rate Report
 *
 * average:心率平均值
 * max: 心率最大值
 * min: 心率最小值
 * hrList: 心率值全程记录
 * hrvList: 心率变异性全程记录

 */
public class CSBiodataReportHRJsonModel: SmartCodable {
    public var average: Float?
    public var max: Float?
    public var min: Float?
    public var hrList: [Float]?
    public var hrvList: [Float]?
    public var hrvAvg : Float?

    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "hr_avg"
        case max = "hr_max"
        case min = "hr_min"
        case hrList = "hr_rec"
        case hrvList = "hrv_rec"
        case hrvAvg = "hrv_avg"
    }
}

/*  PEPR  Report
 *
 * average:心率平均值
 * max: 心率最大值
 * min: 心率最小值
 * hrList: 心率值全程记录
 * hrvList: 心率变异性全程记录
 * rrList
 */
public class CSBiodataReportPEPRJsonModel: SmartCodable {
    public var average: Float?
    public var max: Float?
    public var min: Float?
    public var hrList: [Float]?
    public var hrvList: [Float]?
    public var hrvAvg : Float?
    public var rrList: [Float]?
    public var rrAvg: [Float]?
    
    public required init() {}
    enum CodingKeys: String, CodingKey {
        case average = "hr_avg"
        case max = "hr_max"
        case min = "hr_min"
        case hrList = "hr_rec"
        case hrvList = "hrv_rec"
        case hrvAvg = "hrv_avg"
        case rrList = "rr_rec"
        case rrAvg = "rr_avg"
    }
}

//MARK: Affective
public class CSAffectiveSubscribeJsonModel: SmartCodable {
    public var attentionList: [String]?
    public var relaxationList: [String]?
    public var attentionChildList: [String]?
    public var relaxationChildList: [String]?
    public var pressureList: [String]?
    public var pleasureList: [String]?
    public var arousalList: [String]?
    public var coherenceList: [String]?
    public var flowList: [String]?
    public required init() {}
    
    enum CodingKeys: String, CodingKey {
        case attentionList = "sub_attention_fields"
        case relaxationList = "sub_relaxation_fields"
        case attentionChildList = "sub_attention_chd_fields"
        case relaxationChildList = "sub_relaxation_chd_fields"
        case pressureList = "sub_pressure_fields"
        case pleasureList = "sub_pleasure_fields"
        case arousalList = "sub_arousal_fields"
        case coherenceList = "sub_coherence_fields"
        case flowList = "sub_meditation_fields"
    }

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.attentionList == nil)&&(self.relaxationList == nil)&&(self.pressureList == nil)&&(self.pleasureList == nil)&&(self.arousalList == nil)&&(self.attentionChildList == nil)&&(self.relaxationChildList == nil)&&(self.coherenceList == nil)&&(self.flowList == nil)
    }
}

public class CSAffectiveJsonModel: SmartCodable {
    public required init() {}
    public var attention: Float?
    public var relaxation: Float?
    public var attention_chd: Float?
    public var relaxation_chd: Float?
    public var pressure: Float?
    public var pleasure: Float?
    public var arousal: Float?
    public var coherence: Float?
    public var flow: Float?
    enum CodingKeys: String, CodingKey {
        case flow = "meditation"
        case attention
        case relaxation
        case attention_chd
        case relaxation_chd
        case pressure
        case pleasure
        case arousal
        case coherence
    }
}

/* Realtime affective
 *
 * attention: 注意力值（0 ~ 100）
 * relaxation: 放松度值（0 ~100）
 * pressure: 压力水平值 （0 ~ 100）
 * pleasure: 愉悦度 (0 ~ 100)
 * arousal: 激活度 (0 ~ 100)
 */
public class CSAffectiveSubscribeProcessJsonModel: SmartCodable {
    @SmartOptional public var attention: CSAffectiveJsonModel?
    @SmartOptional public var relaxation: CSAffectiveJsonModel?
    @SmartOptional public var attention_chd: CSAffectiveJsonModel?
    @SmartOptional public var relaxation_chd: CSAffectiveJsonModel?
    @SmartOptional public var pressure: CSAffectiveJsonModel?
    @SmartOptional public var pleasure: CSAffectiveJsonModel?
    @SmartOptional public var arousal: CSAffectiveJsonModel?
    @SmartOptional public var coherence: CSAffectiveJsonModel?
    @SmartOptional public var flow: CSAffectiveJsonModel?

    public required init() {}
    
    enum CodingKeys: String, CodingKey {
        case flow = "meditation"
        case attention
        case relaxation
        case attention_chd
        case relaxation_chd
        case pressure
        case pleasure
        case arousal
        case coherence
    }

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.attention?.attention == nil)&&(self.relaxation?.relaxation == nil)&&(self.pressure?.pressure == nil)&&(self.pleasure?.pleasure == nil)&&(self.arousal?.arousal == nil)&&(self.attention_chd?.attention_chd == nil)&&(self.relaxation_chd?.relaxation_chd == nil)&&(self.coherence?.coherence == nil)&&(self.flow?.flow==nil)
    }
}


/* Affective Report
 *
 * attention: 注意力
 * relaxation: 放松度
 * pressure: 压力水平
 * pleasure: 愉悦度
 * arousal: 激活度
 *
 */
public class CSAffectiveReportJsonModel: SmartCodable {
    @SmartOptional public var attention: CSReportAttentionJsonModel?
    @SmartOptional public var relaxation: CSReportRelaxtionJsonModel?
    @SmartOptional public var attentionChild: CSReportAttentionChildJsonModel?
    @SmartOptional public var relaxationChild: CSReportRelaxtionChildJsonModel?
    @SmartOptional public var pressure: CSReportPressureJsonModel?
    @SmartOptional public var pleasure: CSReportPleasureJsonModel?
    @SmartOptional public var arousal: CSReportArousalJsonModel?
    @SmartOptional public var coherence: CSReportCoherenceJsonModel?
    @SmartOptional public var flow: CSReportFlowJsonModel?
    public required init() {}
    
    enum CodingKeys: String, CodingKey {
        case flow = "meditation"
        case attention
        case relaxation
        case attentionChild = "attention_chd"
        case relaxationChild = "relaxation_chd"
        case pressure
        case pleasure
        case arousal
        case coherence
    }
}

public class CSReportAttentionJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "attention_avg"
        case list = "attention_rec"
    }
}

public class CSReportRelaxtionJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "relaxation_avg"
        case list = "relaxation_rec"
    }
}

public class CSReportFlowJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "meditation_avg"
        case list = "meditation_rec"
    }
}

public class CSReportAttentionChildJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "attention_chd_avg"
        case list = "attention_chd_rec"
    }
}

public class CSReportRelaxtionChildJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "relaxation_chd_avg"
        case list = "relaxation_chd_rec"
    }
}

public class CSReportPressureJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "pressure_avg"
        case list = "pressure_rec"
    }
}

public class CSReportPleasureJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}

    enum CodingKeys: String, CodingKey {
        case average = "pleasure_avg"
        case list = "pleasure_rec"
    }
}

public class CSReportArousalJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    enum CodingKeys: String, CodingKey {
        case average = "arousal_avg"
        case list = "arousal_rec"
    }
}

public class CSReportCoherenceJsonModel: SmartCodable {
    public var average: Float?
    public var list: [Float]?
    public var flag: [Float]?
    public var duration: Float?
    public required init() {}
    enum CodingKeys: String, CodingKey {
        case average = "coherence_avg"
        case list = "coherence_rec"
        case flag = "coherence_flag"
        case duration = "coherence_duration"
    }
}

public class CSPersonalInfoJSONModel: SmartCodable {
    @SmartOptional var user: CSUserInfoJSONModel?
    var device: [String: String]?
    var data: [String: String]?
    @SmartOptional var label: CSLabelInfoJSONModel?
    var allow: Bool = true
    public required init() { }
}

public class CSUserInfoJSONModel: SmartCodable {
    var sex: String?
    var age: Int?
    public required init() { }
}

public class CSLabelInfoJSONModel: SmartCodable {
    var mode: [Int]?
    var cased: [Int]?
    public required init() { }
    enum CodingKeys: String, CodingKey {
        case cased = "case"
        case mode
    }
}

public class CSLabelSubmitJSONModel: SmartCodable {
    public var st: Int? //start time
    public var et: Int? //end
    public var tag: [String: SmartAny]?
    public var note: [String]?
    public required init() { }
  
}

public enum FilterMode: String,SmartCaseDefaultable {
    public static var defaultCase: FilterMode = .basic
    
    case basic
    case smart
    case hard
}

public enum PowerMode: String, SmartCaseDefaultable {
    public static var defaultCase: PowerMode = .db
    
    case db
    case rate
}

public class AlgorithmParamJSONModel: SmartCodable {
    //public var eeg:
    public var tolerance: Int?
    public var filterMode: FilterMode?
    public var powerMode: PowerMode?
    public var channelPower: Bool?
    public required init() { }

    enum CodingKeys: String, CodingKey {
        case filterMode = "filter_mode"
        case powerMode = "power_mode"
        case channelPower = "channel_power_verbose"
        case tolerance
    }
    
}

public class BiodataAlgorithmParams :SmartCodable {
    public required init() { }
    @SmartOptional public var eeg: AlgorithmParamJSONModel?
}


