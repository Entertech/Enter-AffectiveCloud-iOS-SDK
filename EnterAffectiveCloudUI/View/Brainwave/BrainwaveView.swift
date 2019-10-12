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

class BrainwaveView: UIView, NibLoadable {


    @IBOutlet weak var rightBrainLabel: UILabel!
    @IBOutlet weak var leftBrainLabel: UILabel!
    @IBOutlet weak var rightDot: UILabel!
    @IBOutlet weak var leftDot: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var rightBrain: EEGView!
    @IBOutlet weak var leftBrain: EEGView!
    
    private var leftData: [Float]?
    private var rightData: [Float]?
    
    private let leftLock = NSLock()
    private let rightLock = NSLock()
    
    private var leftTimer: Timer?
    private var rightTimer: Timer?
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        let view = BrainwaveView.loadFromNib()
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
        rightData = Array(repeating: 0, count: 200)
        leftData = Array(repeating: 0, count: 200)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        let view = BrainwaveView.loadFromNib()
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
        rightData = Array(repeating: 0, count: 200)
        leftData = Array(repeating: 0, count: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        let view = BrainwaveView.loadFromNib()
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
        rightData = Array(repeating: 0, count: 200)
        leftData = Array(repeating: 0, count: 200)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rightBrain.layoutIfNeeded()
        leftBrain.layoutIfNeeded()
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
    
    
    private func drawWave(_ leftOrRight: LeftOrRightBrain) {
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
