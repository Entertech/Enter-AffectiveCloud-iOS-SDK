//
//  SurveyorsRodView.swift
//  Flowtime
//
//  Created by Enter on 2019/5/20.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class SurveyorsRodView: BaseView {

    private var _dotValue:Float = 0
    var rodBar: UIView = UIView()
    var rodDot: RodDot = RodDot()
    private var _scaleArray: [Int]?
    private var _textColor: UIColor?
    private var _rodColor: [UIColor]?
    private var _interval:[CGFloat]?
    
    init() {
        super.init(frame: CGRect.zero)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var isShowed = false
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isShowed {
            if let rodColor = _rodColor, let interval = _interval {
                initBarColor(rodColor, interval)
                setDotColor(rodColor.last!)
            }
            
            if let array = _scaleArray {
                setLabel(index: array, _textColor!)
            }
            isShowed = true
        }
    }
    
    override func setUI() {
        rodBar.layer.cornerRadius = 3
        rodBar.layer.masksToBounds = true
        rodDot.backgroundColor = .clear
        self.addSubview(rodBar)
        self.addSubview(rodDot)
    }
    
    override func setLayout() {
        super.setLayout()
        rodBar.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(6)
        }
        
        rodDot.snp.makeConstraints {
            $0.centerX.equalTo(rodBar.snp.left).offset(13)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(10)
            $0.height.equalTo(8)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    
    
    public var scaleArray: [Int] {
        get {
            return _scaleArray!
        }
        set {
            _scaleArray = newValue
            
        }
    }
    
    public func setBarColor(_ colors: [UIColor],_ interval: [CGFloat]) {
        _rodColor = colors
        _interval = interval
    }
    
    private func initBarColor(_ colors: [UIColor],_ interval: [CGFloat]) {
        let lineCount = interval.count - 1
        let barWidth = self.bounds.width - 6
        for i in (0..<lineCount) {
            let path = UIBezierPath()
            let startPointX = (interval[i] - CGFloat(scaleArray.first!)) / CGFloat(scaleArray.last! - scaleArray.first!) * barWidth
            let startPointY: CGFloat = rodBar.bounds.height / 2
            path.move(to: CGPoint(x: startPointX, y: startPointY))
            let endPointX = (interval[i+1] - CGFloat(scaleArray.first!)) / CGFloat(scaleArray.last! - scaleArray.first!) * barWidth
            path.addLine(to: CGPoint(x: endPointX, y: rodBar.bounds.height / 2))
            path.close()
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.lineWidth = rodBar.bounds.height
            layer.strokeColor = colors[i].cgColor
            layer.strokeStart = 0
            layer.strokeEnd = 1
            rodBar.layer.addSublayer(layer)
        }
    }
    
    public func setDotColor(_ color: UIColor) {
        let rodDotView = rodDot
        rodDotView.fillColor = color
        rodDotView.setNeedsDisplay()
    }
    
    public func setLabelColor(_ color: UIColor) {
        _textColor = color

    }
    
    private func setLabel(index:[Int], _ color: UIColor) {
        let viewWidth = (self.bounds.width - 15)
        let temp = index.last! - index.first!
        for e in index {
            let originX: CGFloat = CGFloat(e - index.first!) / CGFloat(temp) * viewWidth
            let scaleLabel = UILabel(frame: CGRect(origin: CGPoint(x:originX-1, y:0), size: CGSize(width: 18, height: 12)))
            scaleLabel.backgroundColor = UIColor.clear
            scaleLabel.text = String(e)
            scaleLabel.textAlignment = .center
            scaleLabel.font = UIFont.systemFont(ofSize: 10)
            scaleLabel.textColor = color
            self.addSubview(scaleLabel)
        }
        
        let barWidth = (self.bounds.width - 10)
        
        
        rodDot.snp.updateConstraints {
            $0.centerX.equalTo(rodBar.snp.left).offset( (CGFloat(_dotValue) - CGFloat(scaleArray.first!)) / CGFloat(scaleArray.last! - scaleArray.first!) * barWidth)
        }
    }
    
    public func setDotValue(index: Float) {
        _dotValue = index
        let barWidth = (self.bounds.width - 10)
        rodDot.snp.updateConstraints {
            $0.centerX.equalTo(rodBar.snp.left).offset( (CGFloat(_dotValue) - CGFloat(scaleArray.first!)) / CGFloat(scaleArray.last! - scaleArray.first!) * barWidth + 2)
        }
    }
    
    
    
}
