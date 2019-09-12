//
//  CloudModels.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON

//MARK: Request Models
public class AffectiveCloudRequestJSONModel: HandyJSON {
    var services: String = ""
    var operation: String = ""
    var kwargs: CSKwargsJSONModel?
    public required init() { }

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.operation <-- "op"
    }
}

public class CSRequestDataJSONModel: HandyJSON {
    var eeg: [Int]?
    var hr: [Int]?
    public required init() { }
}

class CSKwargsJSONModel: HandyJSON {
    var bioTypes: [String]?
    var tolerance: [String:Any]?
    var app_key: String?
    var sign: String?
    var userID: String?
    var timeStamp: String?
    var device: String?
    var data: CSRequestDataJSONModel?
    var sessionID: String?
    var reportType: String?
    var eegParams: [String]?
    var hrParams: [String]?
    var eegData: [Int]?
    var hrData: [Int]?

    var affectiveTypes: [String]?
    var attenionServieces: [String]?
    var relaxationServices: [String]?
    var attenionChildServieces: [String]?
    var relaxationChildServices: [String]?
    var pressureServices: [String]?
    var pleasureServices: [String]?
    var arousalServices: [String]?
    required init() { }

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.reportType <-- "gr"
        mapper <<<
            self.sessionID <-- "session_id"
        mapper <<<
            self.eegParams <-- "eeg"
        mapper <<<
            self.hrParams <-- "hr"
        mapper <<<
            self.eegData <-- "eeg"
        mapper <<<
            self.hrData <-- "hr"
        mapper <<<
            self.userID <-- "user_id"
        mapper <<<
            self.bioTypes <-- "bio_data_type"
        mapper <<<
            self.tolerance <-- "bio_data_toleranc"
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

    // ugly imp: 用来给业务层访问 data 字段对应的 model。
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

    public required init() { }
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.sessionID <-- "session_id"
        mapper <<<
            self.biodataList <-- "bio_data_type"
        mapper <<<
            self.affectiveList <-- "cloud_services"
    }
}


/*
 *  订阅状态返回的服务数据列表
 */
public class CSResponseBiodataSubscribeJSONModel: HandyJSON {
    public var eegServiceList: [String]?
    public var hrServiceList: [String]?
    public required init() {}

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.eegServiceList <-- "sub_eeg_fields"
        mapper <<<
            self.hrServiceList <-- "sub_hr_fields"
    }

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.eegServiceList == nil)&&(self.hrServiceList == nil)
    }
}

/* 脑电生物信号实时分析结果
 * eeg: 实时脑电数据
 * hr: 实时心率数据
 */
public class CSBiodataProcessJSONModel: HandyJSON {
    public var eeg: CSBiodataEEGJsonModel?
    public var hr: CSBiodataHRJsonModel?
    public required init() {}

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.eeg == nil)&&(self.hr == nil)
    }
}

/* 情感云实时返回的脑电分析结果
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
    public  var theta: Float?
    public var delta: Float?
    public var gamma: Float?
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
    }
}

/* 情感云实时返回的心率分析结果
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

/* 生物信号报表
 *
 * eeg: 脑电综合报表
 * hr: 心率综合报表
 */
public class CSBiodataReportJsonModel: HandyJSON {
    public var eeg: CSBiodataReportEEGJsonModel?
    public var hr: CSBiodataReportHRJsonModel?

    public required init() {}
}

/*  情感云 `脑电` 综合分析数据报表
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
    }
}

/*  情感云 `心率` 综合分析数据报表
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

//MARK: Affective
public class CSAffectiveSubscribeJsonModel: HandyJSON {
    public var attentionList: [String]?
    public var relaxationList: [String]?
    public var attentionChildList: [String]?
    public var relaxationChildList: [String]?
    public var pressureList: [String]?
    public var pleasureList: [String]?
    public var arousalList: [String]?
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
    }

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.attentionList == nil)&&(self.relaxationList == nil)&&(self.pressureList == nil)&&(self.pleasureList == nil)&&(self.arousalList == nil)&&(self.attentionChildList == nil)&&(self.relaxationChildList == nil)
    }
}

public class CSAffectiveJsonModel: HandyJSON {
    public required init() {}
    public var attention: Float?
    public var relaxation: Float?
    public var attentionChild: Float?
    public var relaxationChild: Float?
    public var pressure: Float?
    public var pleasure: Float?
    public var arousal: Float?
}

/* 情感计算实时分析结果
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
    public var attentionChild: CSAffectiveJsonModel?
    public var relaxationChild: CSAffectiveJsonModel?
    public var pressure: CSAffectiveJsonModel?
    public var pleasure: CSAffectiveJsonModel?
    public var arousal: CSAffectiveJsonModel?

    public required init() {}

    /// all property is nil the isNil: true
    ///
    public func isNil()-> Bool {
        return (self.attention?.attention == nil)&&(self.relaxation?.relaxation == nil)&&(self.pressure?.pressure == nil)&&(self.pleasure?.pleasure == nil)&&(self.arousal?.arousal == nil)&&(self.attentionChild?.attentionChild == nil)&&(self.relaxationChild?.relaxationChild == nil)
    }
}


/* 情感云综合分析结果
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
