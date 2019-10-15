//
//  EEGView.swift
//  Flowtime
//
//  Created by Enter on 2019/5/21.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class EEGView: UIView {
    
    var eegArray: [Float]?
    var lineColor: UIColor?
    var height: CGFloat = 0
    var width: CGFloat = 0
    var minWidth: CGFloat = 0
    var minHeight: CGFloat = 0
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = self.bounds.height
        width = self.bounds.width
        minWidth = width / 200.0
        minHeight = height / 600
    
    }
    
    func setLineColor(_ color: UIColor) {
        lineColor = color
        height = self.bounds.height
        width = self.bounds.width
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 1, y: 0))
        linePath.addLine(to: CGPoint(x: 1, y: height))
        let shaperLayer = CAShapeLayer()
        shaperLayer.lineWidth = 0.8
        shaperLayer.backgroundColor = UIColor.clear.cgColor
        shaperLayer.strokeColor = UIColor.black.cgColor
        shaperLayer.path = linePath.cgPath
        self.layer.addSublayer(shaperLayer)
        
        for i in stride(from: 60, to: width, by: 70) {
            let dashPath = UIBezierPath()
            dashPath.move(to: CGPoint(x: i, y: 0))
            dashPath.addLine(to: CGPoint(x: i, y: height))
            let dashLayer = CAShapeLayer()
            dashLayer.lineWidth = 0.6
            dashLayer.backgroundColor = UIColor.clear.cgColor
            dashLayer.strokeColor = UIColor.lightGray.cgColor
            dashLayer.path = dashPath.cgPath
            dashLayer.lineJoin = .round
            dashLayer.lineDashPhase = 0
            dashLayer.lineDashPattern = [NSNumber(value: 4), NSNumber(value: 2)]
            self.layer.addSublayer(dashLayer)
        }
    }
    
    func setArray(_ array: [Float]) {
        eegArray = array
        setNeedsDisplay()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let array = eegArray{
            let originY = height / 2
            var eegNode: [CGPoint] = Array.init()
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            for (index,e) in array.enumerated() {
                if index > 200 {
                    break
                }
                let pointX = 1 + CGFloat(index) * minWidth
                let pointY = originY - CGFloat(e) * minHeight
                let node = CGPoint(x: pointX, y: pointY)
                eegNode.append(node)
            }
            context.setStrokeColor(lineColor!.cgColor)
            context.setLineWidth(1.5)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: 1, y: originY))
            context.addLines(between: eegNode)
            context.strokePath()
        }
        
    }


}
