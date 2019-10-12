//
//  RodDot.swift
//  Flowtime
//
//  Created by Enter on 2019/5/20.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class RodDot: UIView {

    public var fillColor: UIColor?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        UIColor.clear.set()
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let height = self.bounds.height
        let width = self.bounds.width
        context.beginPath()
        context.move(to: CGPoint(x: width / 2.0, y: 0.2))
        context.addLine(to: CGPoint(x: 0, y: height))
        context.addLine(to: CGPoint(x: width, y: height))
        context.closePath()
        fillColor?.setFill()
        context.drawPath(using: .fill)
        
    }


}
