//
//  BaseView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

open class BaseView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {}
    
    func setLayout() {}
    
    func parentViewController() -> UIViewController? {

        var n = self.next
        
        while n != nil {
            
            if (n is UIViewController) {
                
                return n as? UIViewController
            }
            
            n = n?.next
        }
        
        return nil
    }

}
