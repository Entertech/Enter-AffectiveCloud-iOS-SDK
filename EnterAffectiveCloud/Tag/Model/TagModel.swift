//
//  AppServiceModel.swift
//  EnterAffectiveCloud
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import HandyJSON

final public class TagModel: HandyJSON {
    
    public var id: Int?
    public var model: [TagModeModel]?
    public var tag: [TagDescModel]?
    public var name_cn: String?
    public var name_en: String?
    public var desc: String?
    public var app: Int?
    required public init() {}
}

public class TagModeModel: HandyJSON {
    required public init() {}
    
    public var id: Int?
    public var name_cn: String?
    public var name_en: String?
    public var desc: String?
}

public class TagDescModel: HandyJSON {
    required public init() {}
    
    public var id: Int?
    public var dim: [DimModel]?
    public var name_cn: String?
    public var name_en: String?
    public var desc: String?
}

public class DimModel: HandyJSON {
    required public init() {}
    
    public var id: Int?
    public var name_cn: String?
    public var name_en: String?
    public var value: String?
    public var desc: String?
}

