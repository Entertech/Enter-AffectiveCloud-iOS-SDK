//
//  AppServiceModel.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Foundation

final public class TagModel: Codable {
    
    public var id: Int?
    public var mode: [TagModeModel]?
    public var tag: [TagDescModel]?
    public var name_cn: String?
    public var name_en: String?
    public var desc: String?
    public var app: Int?
    required public init() {}
}

public class TagModeModel: Codable {
    required public init() {}
    
    public var id: Int?
    public var name_cn: String?
    public var name_en: String?
    public var desc: String?
}

public class TagDescModel: Codable {
    required public init() {}
    
    public var id: Int?
    public var dim: [DimModel]?
    public var name_cn: String?
    public var name_en: String?
    public var desc: String?
}

public class DimModel: Codable {
    required public init() {}
    
    public var id: Int?
    public var name_cn: String?
    public var name_en: String?
    public var value: String?
    public var desc: String?
}

