//
//  ReportSemiCircle.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/23.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

public class PrivateReportSemiCircle: UIView {

    public var largeValue:CGFloat = 100
    public var smallValue:CGFloat = 0
    public var currentValue:CGFloat = 0
    public var shaperColor = UIColor.colorWithHexString(hexColor: "5e75ff")
    public var text = "Relaxation" {
        willSet {
            label.text =  newValue
        }
    }
    
    var circlePath: UIBezierPath?
    let bgLayer: CAShapeLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    let label = UILabel()
    let bgColor = UIColor.colorWithHexString(hexColor: "f1f5f6")
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else { return }
        label.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        drawLayer()
    }
    
    func initFunction() {
        self.backgroundColor = .clear
        self.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func drawLayer() {
        if let _ = bgLayer.superlayer {
            bgLayer.removeFromSuperlayer()
        }
        if let _ = shapeLayer.superlayer {
            shapeLayer.removeFromSuperlayer()
        }
        let w1 = self.bounds.width
        let h1 = self.bounds.height
        circlePath = UIBezierPath.init(arcCenter: CGPoint(x: w1/2, y: h1-5), radius: (w1-10.0)/2, startAngle: CGFloat.pi, endAngle: CGFloat.pi*2, clockwise: true)
        
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = 8
        bgLayer.strokeColor = bgColor.cgColor
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        bgLayer.lineCap = .round
        bgLayer.path = circlePath?.cgPath
        self.layer.addSublayer(bgLayer)
        
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.strokeColor = shaperColor.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = currentValue / (largeValue - smallValue)
        shapeLayer.lineCap = .round
        shapeLayer.path = circlePath?.cgPath
        self.layer.addSublayer(shapeLayer)
    }

}

public class ReportSemiCircle2: UIView {
    public var largeValue:CGFloat = 100
    public var smallValue:CGFloat = 0
    public var currentValue:CGFloat = 0
    public let needleLayer = CAShapeLayer()
    public var gradientLayer: CAGradientLayer = CAGradientLayer()

    public var isShowLine = true
    
    public var colors: [Any] = [UIColor.colorWithHexString(hexColor:"5E75FF").cgColor,
                                UIColor.colorWithHexString(hexColor: "FFB2C0").cgColor]
    
    private let bgColor = UIColor.colorWithHexString(hexColor: "f1f5f6")
    private let shaperColor = UIColor.colorWithHexString(hexColor: "FFB2C0")
    private var circlePath: UIBezierPath?
    private let bgLayer: CAShapeLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = circlePath  {
            
        } else  {
            drawLayer()
        }

    }
    
    func initFunction() {
        self.backgroundColor = .clear
    }
    
    func drawLayer() {
        if let _ = bgLayer.superlayer {
            bgLayer.removeFromSuperlayer()
        }
        if let _ = shapeLayer.superlayer {
            shapeLayer.removeFromSuperlayer()
        }
        if let _ = gradientLayer.superlayer {
            gradientLayer.removeFromSuperlayer()
        }
        if let _ = needleLayer.superlayer {
            needleLayer.removeFromSuperlayer()
        }
        let w1 = self.bounds.width
        let h1 = self.bounds.height
        circlePath = UIBezierPath.init(arcCenter: CGPoint(x: w1/2, y: h1-5), radius: (w1-60.0)/2, startAngle: CGFloat.pi*1.05, endAngle: CGFloat.pi*1.95, clockwise: true)
        
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = 50
        bgLayer.strokeColor = bgColor.cgColor
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        bgLayer.lineCap = .butt
        bgLayer.path = circlePath?.cgPath
        self.layer.addSublayer(bgLayer)
        
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 50
        shapeLayer.strokeColor = shaperColor.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = currentValue / (largeValue - smallValue)
        shapeLayer.lineCap = .butt
        shapeLayer.path = circlePath?.cgPath
        self.layer.addSublayer(shapeLayer)
        
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.addSublayer(gradientLayer)
        
        gradientLayer.mask = shapeLayer
        
        if isShowLine {
            
            needleLayer.frame = self.bounds
            needleLayer.fillColor = UIColor.clear.cgColor
            needleLayer.lineWidth = 60
            needleLayer.strokeColor = UIColor.colorWithHexString(hexColor: "FF6682").cgColor
            needleLayer.strokeStart = currentValue / (largeValue - smallValue)
            needleLayer.strokeEnd = currentValue / (largeValue - smallValue) + 0.003
            needleLayer.lineCap = .butt
            needleLayer.path = circlePath?.cgPath
            self.layer.addSublayer(needleLayer)
        }
        
    }
}
