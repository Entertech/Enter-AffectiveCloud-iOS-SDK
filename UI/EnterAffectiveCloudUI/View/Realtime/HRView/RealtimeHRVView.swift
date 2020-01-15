//
//  RealtimeHRVView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/1/14.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

protocol HRVValueProtocol {
    var rxHRVValue: BehaviorSubject<Int> {set get}
}

class RealtimeHRVView: BaseView {

       //MARK:- Public param
     /// 主色调显示
     public var mainColor = UIColor.colorWithHexString(hexColor: "#FF6682")  {
         didSet {
             self.titleLabel.textColor = mainColor.changeAlpha(to: 1.0)
         }
     }
     private var textFont = "PingFangSC-Semibold"
     /// 字体颜色
     public var textColor = UIColor.colorWithHexString(hexColor: "232323")  {
         didSet {
            titleLabel.textColor = textColor
             
         }
     }
    
    public var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
     
     /// 是否显示信息按钮
     public var isShowInfoIcon: Bool = true{
         didSet {
             infoBtn.isHidden = !isShowInfoIcon
         }
         
     }
     /// 圆角
     public var borderRadius: CGFloat = 8.0  {
         didSet {
            self.layer.cornerRadius = borderRadius
            self.layer.masksToBounds = true
             self.maskCorner = borderRadius
         }
     }
     /// 背景色
     public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF") {
         didSet {
             self.backgroundColor = bgColor
         }
     }
     
     /// 信息按钮打开的网页
     public var infoUrlString = "https://www.notion.so/Heart-Rate-4d64215ac50f4520af7ff516c0f0e00b"
     /// 按钮图片
     public var buttonImageName: String = "" {
         didSet {
             self.infoBtn.setImage(UIImage(named: buttonImageName), for: .normal)
         }
     }

    
    private let titleLabel = UILabel()
    private let infoBtn = UIButton()
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private var minWidth: CGFloat = 0
    private var minHeight: CGFloat = 0
    private var waveArray: [Float]?
    
    override func setUI() {
        self.addSubview(titleLabel)
        self.addSubview(infoBtn)
        
        titleLabel.font = UIFont(name: textFont, size: 14)
        titleLabel.textColor = textColor
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(17)
        }
        
        infoBtn.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = self.bounds.height - 80
        width = self.bounds.width - 20
        minWidth = width / 200.0
        minHeight = height / 100
        setLine()
    }
    
    private func setLine() {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 17, y: 50))
        linePath.addLine(to: CGPoint(x: 17, y: 50+height))
        let shaperLayer = CAShapeLayer()
        shaperLayer.lineWidth = 0.8
        shaperLayer.backgroundColor = UIColor.clear.cgColor
        shaperLayer.strokeColor = textColor.cgColor
        shaperLayer.path = linePath.cgPath
        self.layer.addSublayer(shaperLayer)
        
        for i in stride(from: 60, to: width, by: 70) {
            let dashPath = UIBezierPath()
            dashPath.move(to: CGPoint(x: i, y: 50))
            dashPath.addLine(to: CGPoint(x: i, y: 50+height))
            let dashLayer = CAShapeLayer()
            dashLayer.lineWidth = 0.6
            dashLayer.backgroundColor = UIColor.clear.cgColor
            dashLayer.strokeColor = textColor.changeAlpha(to: 0.3).cgColor
            dashLayer.path = dashPath.cgPath
            dashLayer.lineJoin = .round
            dashLayer.lineDashPhase = 0
            dashLayer.lineDashPattern = [NSNumber(value: 4), NSNumber(value: 2)]
            self.layer.addSublayer(dashLayer)
        }
    }
    
    public func appendArray(_ value: Int) {

            if let _ = waveArray {
                waveArray?.append(Float(value))
                waveArray?.remove(at: 0)
            } else {
                waveArray = Array(repeating: 0.0, count: 200)
                waveArray?.append(Float(value))
            }

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let array = waveArray {
            let originY = height / 2 + 50
            var eegNode1: [CGPoint] = Array.init()
            for (index,e) in array.enumerated() {
                if index > 200 {
                    break
                }
                let pointX = 1 + CGFloat(index) * minWidth
                let pointY1 = originY - CGFloat(e) * minHeight
                let node1 = CGPoint(x: pointX, y: pointY1)
                eegNode1.append(node1)
            }
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.setStrokeColor(self.mainColor.cgColor)
            context.setLineWidth(2)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: 17, y: originY))
            context.addLines(between: eegNode1)
            context.strokePath()
        }
        

    }
}
