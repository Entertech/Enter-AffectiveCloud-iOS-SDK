//
//  CloudModels.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import HandyJSON

enum BiodataType: String {
    case eeg
    case hr
    case hr2 = "hr-v2"
    case bcg
    case mceeg
    case pepr
}

//MARK: Request Models
public class AffectiveCloudRequestJSONModel: HandyJSON {
    var services: String = ""
    var operation: String = ""
    var kwargs: CSKwargsJSONModel?
    var args: [String]?
    public required init() { }

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.operation <-- "op"
    }
}

public class CSRequestDataJSONModel: HandyJSON {
    var eeg: [Int]?
    var hr: [Int]?
    var pepr: [Int]?
    public required init() { }
}

class CSKwargsJSONModel: HandyJSON {
    var bioTypes: [String]?
    var tolerance: [String:Any]?
    var additional: [String:Any]?
    var algorithmParam: BiodataAlgorithmParams?
    var storageSettings: CSPersonalInfoJSONModel?
    var app_key: String?
    var sign: String?
    var userID: String?
    var timeStamp: String?
    var uploadCycle: Int?
    var device: String?
    var data: CSRequestDataJSONModel?
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
    required init() { }

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.reportType <-- "gr"
        mapper <<<
            self.sessionID <-- "session_id"
        mapper <<<
            self.eegData <-- "eeg"
        mapper <<<
            self.hrData <-- "hr-v2"
        mapper <<<
            self.peprData <-- "pepr"
        mapper <<<
            self.userID <-- "user_id"
        mapper <<<
            self.bioTypes <-- "bio_data_type"
        mapper <<<
            self.tolerance <-- "bio_data_tolerance"
        mapper <<<
            self.additional <-- "additional_data"
        mapper <<<
            self.affectiveTypes <-- "cloud_services"
        mapper <<<
            self.attenionServieces <-- "attention"
        mapper <<<
            self.relaxationServices <-- "relaxation"
        mapper <<<
            self.attenionChildServieces <-- "attention_chd"
        mapper <<<
            self.relaxationChildServices <-- "relaxation_chd"
        mapper <<<
            self.pressureServices <-- "pressure"
        mapper <<<
            self.pleasureServices <-- "pleasure"
        mapper <<<
            self.arousalServices <-- "arousal"
        mapper <<<
            self.timeStamp <-- "timestamp"
        mapper <<<
            self.uploadCycle <-- "upload_cycle"
        mapper <<<
            self.storageSettings <-- "storage_settings"
        mapper <<<
            self.coherenceServices <-- "coherence"
        mapper <<<
            self.algorithmParam <-- "algorithm_params"
    }
}

//MARK: Response Models
public class AffectiveCloudResponseJSONModel: HandyJSON {
    public var code: Int = 0
    public var request: AffectiveCloudRequestJSONModel?
    private var data: [String: Any]?
    var message: String?
    public required init() { }

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.message <-- "msg"
    }

   
    public var dataModel: HandyJSON? {
        return self.deserilizedStringToJsonModel(dic: self.data ?? ["": ""])
    }

    private func deserilizedStringToJsonModel(dic rawString: [String: Any]) -> HandyJSON? {
        guard let req = request else { return nil }
        switch (req.services, req.operation) {
        case ("session", "create"), ("biodata", "init"), ("affective", "start"),  ("affective", "finish"):
            if let data = CSResponseDataJSONModel.deserialize(from: rawString) {
                return data
            }
        case ("biodata", "subscribe"):
            if let biodataProcess = CSBiodataProcessJSONModel.deserialize(from: rawString), !biodataProcess.isNil() {
                return biodataProcess
            }

            if let data = CSResponseBiodataSubscribeJSONModel.deserialize(from: rawString), !data.isNil() {
                return data
            }

        case ("biodata", "unsubscribe"):
            if let data = CSResponseBiodataSubscribeJSONModel.deserialize(from: rawString) {
                return data
            }
        case ("biodata", "report"):
            if let biodataReport = CSBiodataReportJsonModel.deserialize(from: rawString) {
                return biodataReport
            }
        case ("affective", "subscribe"):
            DLog(rawString.description)
            if let responseSubscribe = CSAffectiveSubscribeJsonModel.deserialize(from: rawString), !responseSubscribe.isNil() {
                return responseSubscribe
            }

            if let affectiveProcess = CSAffectiveSubscribeProcessJsonModel.deserialize(from: rawString), !affectiveProcess.isNil() {
                return affectiveProcess
            }

        case ("affective", "unsubscribe"):
            if let response = CSAffectiveSubscribeJsonModel.deserialize(from: rawString) {
                return response
            }
        case ("affective", "report"):
            if let report = CSAffectiveReportJsonModel.deserialize(from: rawString) {
                return report
            }
        default:
            return nil
        }

        return nil
    }
}

// Data model
public class CSResponseDataJSONModel: HandyJSON {
    public var sessionID: String?
    public var biodataList: [String]?
    public var affectiveList: [String]?
    public var attentionServiceList: [String]?
    public var relaxationServiceList: [String]?
    public var attentionChildServiceList: [String]?
    public var relaxationChildServiceList: [String]?
    public var pressureServiceList: [String]?
    public var pleasureServiceList: [String]?
    public var arousalServiceList: [String]?
    public var coherenceServiceList: [String]?

    public required init() { }
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.sessionID <-- "session_id"
        mapper <<<
            self.biodataList <-- "bio_data_type"
        mapper <<<
            self.affectiveList <-- "cloud_service"
    }
}


/*
 *  subscription
 */
public class CSResponseBiodataSubscribeJSONModel: HandyJSON {
    public var eegServiceList: [String]?
    public var hrServiceList: [String]?
    public var peprServiceList: [String]?
    public required init() {}

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.eegServiceList <-- "sub_eeg_fields"
        mapper <<<
            self.hrServiceList <-- "sub_hr_fields"
        mapper <<<
            self.peprServiceList <-- "sub_pepr_fields"
    }

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.eegServiceList == nil)&&(self.hrServiceList == nil)
    }
}

/* Realtime Biodata
 * eeg: 实时脑电数据
 * hr: 实时心率数据
 */
public class CSBiodataProcessJSONModel: HandyJSON {
    public var eeg: CSBiodataEEGJsonModel?
    public var hr: CSBiodataHRJsonModel?
    public var pepr: CSBiodataPEPRJsonModel?
    public required init() {}

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.eeg == nil)&&(self.hr == nil)&&(self.pepr == nil)
    }
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.hr <-- "hr-v2"
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
public class CSBiodataEEGJsonModel: HandyJSON {
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
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.waveLeft <-- "eegl_wave"
        mapper <<<
            self.waveRight <-- "eegr_wave"
        mapper <<<
            self.alpha <-- "eeg_alpha_power"
        mapper <<<
            self.belta <-- "eeg_beta_power"
        mapper <<<
            self.theta <-- "eeg_theta_power"
        mapper <<<
            self.delta <-- "eeg_delta_power"
        mapper <<<
            self.gamma <-- "eeg_gamma_power"
        mapper <<<
            self.quality <-- "eeg_quality"
        mapper <<<
            self.alphaLeft <-- "eegl_alpha_power"
        mapper <<<
            self.beltaLeft <-- "eegl_beta_power"
        mapper <<<
            self.thetaLeft <-- "eegl_theta_power"
        mapper <<<
            self.deltaLeft <-- "eegl_delta_power"
        mapper <<<
            self.gammaLeft <-- "eegl_gamma_power"
        mapper <<<
            self.alphaRight <-- "eegr_alpha_power"
        mapper <<<
            self.beltaRight <-- "eegr_beta_power"
        mapper <<<
            self.thetaRight <-- "eegr_theta_power"
        mapper <<<
            self.deltaRight <-- "eegr_delta_power"
        mapper <<<
            self.gammaRight <-- "eegr_gamma_power"
       
    }
}

/* Realtime hear rate
 *
 * hr: 心率值
 * hrv: 心率变异性
 *
 */
public class CSBiodataHRJsonModel: HandyJSON {
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
public class CSBiodataPEPRJsonModel: HandyJSON {
    public var bcgQuality: Int?
    public var rwQuality: Int?
    public var hr: Int?
    public var rr: Int?
    public var hrv: Float?
    public var bcgWave: [Float]?
    public var rwWave: [Float]?
    public required init() {}
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.bcgWave <-- "bcg_wave"
        mapper <<<
            self.rwWave <-- "rw_wave"
        mapper <<<
            self.bcgQuality <-- "bcg_quality"
        mapper <<<
            self.rwQuality <-- "rw_quality"
    }
}

/* Biodata Report
 *
 * eeg: 脑电综合报表
 * hr: 心率综合报表
 */
public class CSBiodataReportJsonModel: HandyJSON {
    public var eeg: CSBiodataReportEEGJsonModel?
    public var hr: CSBiodataReportHRJsonModel?
    public var pepr: CSBiodataReportPEPRJsonModel?

    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.hr <-- "hr-v2"
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
public class CSBiodataReportEEGJsonModel: HandyJSON {
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
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.alphaCurve <-- "eeg_alpha_curve"
        mapper <<<
            self.betaCurve <-- "eeg_beta_curve"
        mapper <<<
            self.thetaCurve <-- "eeg_theta_curve"
        mapper <<<
            self.deltaCurve <-- "eeg_delta_curve"
        mapper <<<
            self.gammaCurve <-- "eeg_gamma_curve"
        mapper <<<
            self.alphaLeftCurve <-- "eegl_alpha_curve"
        mapper <<<
            self.betaLeftCurve <-- "eegl_beta_curve"
        mapper <<<
            self.thetaLeftCurve <-- "eegl_theta_curve"
        mapper <<<
            self.deltaLeftCurve <-- "eegl_delta_curve"
        mapper <<<
            self.gammaLeftCurve <-- "eegl_gamma_curve"
        mapper <<<
            self.alphaRightCurve <-- "eegr_alpha_curve"
        mapper <<<
            self.betaRightCurve <-- "eegr_beta_curve"
        mapper <<<
            self.thetaRightCurve <-- "eegr_theta_curve"
        mapper <<<
            self.deltaRightCurve <-- "eegr_delta_curve"
        mapper <<<
            self.gammaRightCurve <-- "eegr_gamma_curve"
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
public class CSBiodataReportHRJsonModel: HandyJSON {
    public var average: Float?
    public var max: Float?
    public var min: Float?
    public var hrList: [Float]?
    public var hrvList: [Float]?
    public var hrvAvg : Float?

    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "hr_avg"
        mapper <<<
            self.max <-- "hr_max"
        mapper <<<
            self.min <-- "hr_min"
        mapper <<<
            self.hrList <-- "hr_rec"
        mapper <<<
            self.hrvList <-- "hrv_rec"
        mapper <<<
            self.hrvAvg <-- "hrv_avg"
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
public class CSBiodataReportPEPRJsonModel: HandyJSON {
    public var average: Float?
    public var max: Float?
    public var min: Float?
    public var hrList: [Float]?
    public var hrvList: [Float]?
    public var hrvAvg : Float?
    public var rrList: [Float]?
    public var rrAvg: [Float]?
    
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "hr_avg"
        mapper <<<
            self.max <-- "hr_max"
        mapper <<<
            self.min <-- "hr_min"
        mapper <<<
            self.hrList <-- "hr_rec"
        mapper <<<
            self.hrvList <-- "hrv_rec"
        mapper <<<
            self.hrvAvg <-- "hrv_avg"
        mapper <<<
            self.hrvList <-- "rr_rec"
        mapper <<<
            self.hrvAvg <-- "rr_avg"
    }
}

//MARK: Affective
public class CSAffectiveSubscribeJsonModel: HandyJSON {
    public var attentionList: [String]?
    public var relaxationList: [String]?
    public var attentionChildList: [String]?
    public var relaxationChildList: [String]?
    public var pressureList: [String]?
    public var pleasureList: [String]?
    public var arousalList: [String]?
    public var coherenceList: [String]?
    public required init() {}

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.attentionList <-- "sub_attention_fields"
        mapper <<<
            self.relaxationList <-- "sub_relaxation_fields"
        mapper <<<
            self.attentionChildList <-- "sub_attention_chd_fields"
        mapper <<<
            self.relaxationChildList <-- "sub_relaxation_chd_fields"
        mapper <<<
            self.pressureList <-- "sub_pressure_fields"
        mapper <<<
            self.pleasureList <-- "sub_pleasure_fields"
        mapper <<<
            self.arousalList <-- "sub_arousal_fields"
        mapper <<<
            self.coherenceList <-- "sub_coherence_fields"
    }

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.attentionList == nil)&&(self.relaxationList == nil)&&(self.pressureList == nil)&&(self.pleasureList == nil)&&(self.arousalList == nil)&&(self.attentionChildList == nil)&&(self.relaxationChildList == nil)&&(self.coherenceList == nil)
    }
}

public class CSAffectiveJsonModel: HandyJSON {
    public required init() {}
    public var attention: Float?
    public var relaxation: Float?
    public var attention_chd: Float?
    public var relaxation_chd: Float?
    public var pressure: Float?
    public var pleasure: Float?
    public var arousal: Float?
    public var coherence: Float?
}

/* Realtime affective
 *
 * attention: 注意力值（0 ~ 100）
 * relaxation: 放松度值（0 ~100）
 * pressure: 压力水平值 （0 ~ 100）
 * pleasure: 愉悦度 (0 ~ 100)
 * arousal: 激活度 (0 ~ 100)
 */
public class CSAffectiveSubscribeProcessJsonModel: HandyJSON {
    public var attention: CSAffectiveJsonModel?
    public var relaxation: CSAffectiveJsonModel?
    public var attention_chd: CSAffectiveJsonModel?
    public var relaxation_chd: CSAffectiveJsonModel?
    public var pressure: CSAffectiveJsonModel?
    public var pleasure: CSAffectiveJsonModel?
    public var arousal: CSAffectiveJsonModel?
    public var coherence: CSAffectiveJsonModel?

    public required init() {}

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.attention?.attention == nil)&&(self.relaxation?.relaxation == nil)&&(self.pressure?.pressure == nil)&&(self.pleasure?.pleasure == nil)&&(self.arousal?.arousal == nil)&&(self.attention_chd?.attention_chd == nil)&&(self.relaxation_chd?.relaxation_chd == nil)&&(self.coherence?.coherence == nil)
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
public class CSAffectiveReportJsonModel: HandyJSON {
    public var attention: CSReportAttentionJsonModel?
    public var relaxation: CSReportRelaxtionJsonModel?
    public var attentionChild: CSReportAttentionChildJsonModel?
    public var relaxationChild: CSReportRelaxtionChildJsonModel?
    public var pressure: CSReportPressureJsonModel?
    public var pleasure: CSReportPleasureJsonModel?
    public var arousal: CSReportArousalJsonModel?
    public var coherence: CSReportCoherenceJsonModel?
    public required init() {}
}

public class CSReportAttentionJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "attention_avg"
        mapper <<<
            self.list <-- "attention_rec"
    }
}

public class CSReportRelaxtionJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "relaxation_avg"
        mapper <<<
            self.list <-- "relaxation_rec"
    }
}

public class CSReportAttentionChildJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "attention_chd_avg"
        mapper <<<
            self.list <-- "attention_chd_rec"
    }
}

public class CSReportRelaxtionChildJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "relaxation_chd_avg"
        mapper <<<
            self.list <-- "relaxation_chd_rec"
    }
}

public class CSReportPressureJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "pressure_avg"
        mapper <<<
            self.list <-- "pressure_rec"
    }
}

public class CSReportPleasureJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "pleasure_avg"
        mapper <<<
            self.list <-- "pleasure_rec"
    }
}

public class CSReportArousalJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "arousal_avg"
        mapper <<<
            self.list <-- "arousal_rec"
    }
}

public class CSReportCoherenceJsonModel: HandyJSON {
    public var average: Float?
    public var list: [Float]?
    public var flag: [Float]?
    public var duration: Float?
    public required init() {}
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.average <-- "coherence_avg"
        mapper <<<
            self.list <-- "coherence_rec"
        mapper <<<
            self.flag <-- "coherence_flag"
        mapper <<<
            self.duration <-- "coherence_duration"
    }
}

public class CSPersonalInfoJSONModel: HandyJSON {
    var user: CSUserInfoJSONModel?
    var device: [String: Any]?
    var data: [String: Any]?
    var label: CSLabelInfoJSONModel?
    var allow: Bool = true
    public required init() { }
}

public class CSUserInfoJSONModel: HandyJSON {
    var sex: String?
    var age: Int?
    public required init() { }
}

public class CSLabelInfoJSONModel: HandyJSON {
    var mode: [Int]?
    var cased: [Int]?
    public required init() { }
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.cased <-- "case"
    }
}

public class CSLabelSubmitJSONModel: HandyJSON {
    public var st: Int? //start time
    public var et: Int? //end
    public var tag: [String: Any]?
    public var note: [String]?
    public required init() { }
  
}

public enum FilterMode: String,HandyJSONEnum {
    case basic
    case smart
    case hard
}

public enum PowerMode: String, HandyJSONEnum {
    case db
    case rate
}

public class AlgorithmParamJSONModel: HandyJSON {
    //public var eeg:
    public var tolerance: Int?
    public var filterMode: FilterMode?
    public var powerMode: PowerMode?
    public var channelPower: Bool?
    public required init() { }
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.filterMode <-- "filter_mode"
        mapper <<<
            self.powerMode <-- "power_mode"
        mapper <<<
            self.channelPower <-- "channel_power_verbose"
    }
    
}

public class BiodataAlgorithmParams :HandyJSON {
    public required init() { }
    public var eeg: AlgorithmParamJSONModel?
}


