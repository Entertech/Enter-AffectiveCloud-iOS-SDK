//
//  SurveyorsRodView.swift
//  Flowtime
//
//  Created by Enter on 2019/5/20.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class SurveyorsRodView: UIView, NibLoadable {

    @IBOutlet weak var rodBar: UIView!
    @IBOutlet weak var rodDot: UIView!
    private var _scaleArray: [Int]?
    private var _textColor: UIColor?
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        let view = SurveyorsRodView.loadFromNib()
        self.addSubview(view)
        contentView = view
        view.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
        let view = SurveyorsRodView.loadFromNib()
        self.addSubview(view)
        contentView = view
        view.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public var scaleArray: [Int] {
        get {
            return _scaleArray!
        }
        set {
            _scaleArray = newValue
            if let newColor = _textColor {
                setLabel(index: newValue, newColor)
            }
            
        }
    }
    
    public func setBarColor(_ colors: [UIColor],_ interval: [CGFloat]) {
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
        let rodDotView = rodDot as! RodDot
        rodDotView.fillColor = color
        rodDotView.setNeedsDisplay()
    }
    
    public func setLabelColor(_ color: UIColor) {
        _textColor = color
        if let array = _scaleArray {
            setLabel(index: array, color)
        }
    }
    
    private func setLabel(index:[Int], _ color: UIColor) {
        let viewWidth = (self.bounds.width - 15)
        let temp = index.last! - index.first!
        for e in index {
            let originX: CGFloat = CGFloat(e - index.first!) / CGFloat(temp) * viewWidth
            let scaleLabel = UILabel(frame: CGRect(origin: CGPoint(x:originX + 3 > viewWidth ? originX-3 : originX+3, y:0), size: CGSize(width: 18, height: 12)))
            scaleLabel.backgroundColor = UIColor.clear
            scaleLabel.text = String(e)
            scaleLabel.textAlignment = .left
            scaleLabel.font = UIFont.systemFont(ofSize: 10)
            scaleLabel.textColor = color
            self.addSubview(scaleLabel)
        }
    }
    
    public func setDotValue(index: Float) {
        let barWidth = (self.bounds.width - 6)
        rodDot.center.x = (CGFloat(index) - CGFloat(scaleArray.first!)) / CGFloat(scaleArray.last! - scaleArray.first!) * barWidth + 3
    }
    
    
    
}
