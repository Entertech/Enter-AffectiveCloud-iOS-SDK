//
//  BrainwaveView.swift
//  Flowtime
//
//  Created by Enter on 2019/5/16.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

enum LeftOrRightBrain {
    case left
    case right
}

class BrainwaveView: BaseView {
    
    var leftColor: UIColor?
    var rightColor: UIColor?

    var rightBrainLabel: UILabel = UILabel()
    var leftBrainLabel: UILabel = UILabel()
    var rightDot: UILabel = UILabel()
    var leftDot: UILabel = UILabel()
    var titleLabel: UILabel = UILabel()
    var infoButton: UIButton = UIButton()
    var rightBrain: EEGView = EEGView()
    var leftBrain: EEGView = EEGView()
    
    public var leftData: [Float]?
    public var rightData: [Float]?
    
    private let leftLock = NSLock()
    private let rightLock = NSLock()
    
    private var leftTimer: Timer?
    private var rightTimer: Timer?
    
    init() {
        super.init(frame: CGRect.zero)
 
        rightData = Array(repeating: 0, count: 200)
        leftData = Array(repeating: 0, count: 200)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
        rightData = Array(repeating: 0, count: 200)
        leftData = Array(repeating: 0, count: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        rightData = Array(repeating: 0, count: 200)
        leftData = Array(repeating: 0, count: 200)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let leftColor = leftColor, let rightColor = rightColor {
            rightBrain.setLineColor(rightColor)
            leftBrain.setLineColor(leftColor)
        }
    }
    
    override func setUI() {
        self.addSubview(titleLabel)
        self.addSubview(infoButton)
        self.addSubview(leftDot)
        self.addSubview(rightDot)
        self.addSubview(leftBrainLabel)
        self.addSubview(rightBrainLabel)
        self.addSubview(leftBrain)
        self.addSubview(rightBrain)
        
        infoButton.setImage(UIImage.init(named: "icon_info_black", in: Bundle.init(for: self.classForCoder), with: .none), for: .normal)
        
        leftDot.layer.cornerRadius = 4
        leftDot.layer.masksToBounds = true
        
        rightDot.layer.cornerRadius = 4
        rightDot.layer.masksToBounds = true
        
        leftBrainLabel.font = UIFont.systemFont(ofSize: 12)
        rightBrainLabel.font = UIFont.systemFont(ofSize: 12)
        
        leftBrain.backgroundColor = .clear
        rightBrain.backgroundColor = .clear
        
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
        }
        
        infoButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp_centerYWithinMargins)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        rightBrainLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(infoButton.snp_bottomMargin).offset(10)
        }
        
        rightDot.snp.makeConstraints {
            $0.right.equalTo(rightBrainLabel.snp_leftMargin).offset(-6)
            $0.centerY.equalTo(rightBrainLabel.snp_centerYWithinMargins)
        }
        
        leftBrainLabel.snp.makeConstraints {
            $0.right.equalTo(rightDot.snp_leftMargin).offset(-32)
            $0.centerY.equalTo(rightDot.snp_centerYWithinMargins)
        }
        
        leftDot.snp.makeConstraints {
            $0.right.equalTo(leftBrainLabel.snp_leftMargin).offset(-6)
            $0.centerY.equalTo(leftBrainLabel.snp_centerYWithinMargins)
        }
        
        leftBrain.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
            $0.top.equalTo(rightBrainLabel.snp_bottomMargin).offset(20)
        }
        
        rightBrain.snp.makeConstraints  {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
            $0.top.equalTo(leftBrain.snp_bottomMargin).offset(16)
        }
    }
    
    public func setLineColor(left: UIColor, right: UIColor) {
        leftColor  = left
        rightColor = right
    }
    

    private let drawingWaveSample = 10
    public func setEEGArray(_ data: [Float],_ leftOrRight: LeftOrRightBrain) {
        
        let margin = max(data.count / 10, 1)
        for index in stride(from: 0, to: data.count, by: margin) {
            var value = data[index]
            if value > 300 {
                value = 300
            } else if value < -300 {
                value = -300
            }
            if leftOrRight == .right {
                rightLock.lock()
                rightData?.append(value)
                rightLock.unlock()
            } else {
                leftLock.lock()
                leftData?.append(value)
                leftLock.unlock()
            }
            
        }
        if leftOrRight == .right {
            guard let _ = rightTimer else {
                rightTimer = Timer(timeInterval: 0.04, repeats: true) {[weak self] (timer) in
                    self!.drawWave(.right)
                }
                RunLoop.current.add(rightTimer!, forMode: .common)
                rightTimer!.fire()
                return
            }
        } else {
            guard let _ = leftTimer else {
                leftTimer = Timer(timeInterval: 0.04, repeats: true) {[weak self] (timer) in
                    self!.drawWave(.left)
                }
                RunLoop.current.add(leftTimer!, forMode: .common)
                leftTimer!.fire()
                return
            }
        }
    }
    
    public func stopTimer() {
        if let lTimer = leftTimer {
            if lTimer.isValid {
                lTimer.invalidate()
                leftTimer = nil
            }
        }
        if let rTimer = rightTimer {
            if rTimer.isValid {
                rTimer.invalidate()
                rightTimer = nil
            }
        }
    }
    
    
    public func drawWave(_ leftOrRight: LeftOrRightBrain) {
        DispatchQueue.main.async {
            switch leftOrRight{
            case .left:
                self.leftLock.lock()
                if self.leftData!.count > 220 {
                    self.leftData!.removeSubrange(219...(self.leftData!.count-1))
                }
                else if self.leftData!.count < 200 {
                    self.leftData?.append(0)
                }
                self.leftBrain.setArray(self.leftData!)
                self.leftData?.remove(at: 0)
                self.leftLock.unlock()
            case .right:
                self.rightLock.lock()
                if self.rightData!.count > 220 {
                    self.rightData!.removeSubrange(219...(self.rightData!.count-1))
                }
                else if self.rightData!.count < 200 {
                    self.rightData?.append(0)
                }
                self.rightBrain.setArray(self.rightData!)
                self.rightData?.remove(at: 0)
                self.rightLock.unlock()
            }
        }
    }
    
}
