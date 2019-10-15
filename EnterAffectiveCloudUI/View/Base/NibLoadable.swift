//
//  NibLoadable.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/11.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

protocol NibLoadable {
}
extension NibLoadable where Self : UIView {
    //在协议里面不允许定义class 只能定义static
    static func loadFromNib(_ nibname: String? = nil) -> Self {//Self (大写) 当前类对象
        //self(小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
        
        return Bundle.init(identifier: "cn.entertech.EnterAffectiveCloudUI")!.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
