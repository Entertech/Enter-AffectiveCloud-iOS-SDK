//
//  RealtimeBrainwaveView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/12.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

protocol BrainwaveValueProtocol {
    var rxLeftBrainwaveValue: BehaviorSubject<[Float]> {set get}
    var rxRightBrainwaveValue: BehaviorSubject<[Float]> {set get}
}

class UpdateBrainwaveValue: BrainwaveValueProtocol {
    var rxLeftBrainwaveValue: BehaviorSubject<[Float]>
    
    var rxRightBrainwaveValue: BehaviorSubject<[Float]>
    
    
    init() {
        
        rxLeftBrainwaveValue = BehaviorSubject<[Float]>(value: [])
        
        rxRightBrainwaveValue = BehaviorSubject<[Float]>(value: [])
        
        NotificationCenter.default.addObserver(self, selector: #selector(biodataSubscript(_:)), name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
        rxLeftBrainwaveValue.onCompleted()
        rxRightBrainwaveValue.onCompleted()
    }
    
    @objc func biodataSubscript(_ notification: Notification) {
    
        if let data = notification.userInfo!["biodataServicesSubscribe"] as? CSBiodataProcessJSONModel {
            if let eeg = data.eeg {
                if let left = eeg.waveLeft {
                    rxLeftBrainwaveValue.onNext(left)
                }
                if let right = eeg.waveRight {
                    rxRightBrainwaveValue.onNext(right)
                }
            }
        
        }
            
    }
}

public class RealtimeBrainwaveView: BaseView {
    //MARK:- Public param
    /// 主色
    public var mainColor = UIColor.colorWithHexString(hexColor: "23233A") {
        didSet {
            let changedMainColor = mainColor.changeAlpha(to: 1.0)
            brainwaveView.titleLabel.textColor = changedMainColor
        }
    }
    private var textFont = "PingFangSC-Semibold"
    /// 文字颜色
    public var textColor:UIColor = UIColor.colorWithHexString(hexColor: "171726") {
        didSet {
            let changedTextColor = textColor.changeAlpha(to: 0.5)
            let secondColor = textColor.changeAlpha(to: 0.2)
            brainwaveView.leftBrainLabel.textColor = changedTextColor
            brainwaveView.rightBrainLabel.textColor = changedTextColor
            brainwaveView.setDashLineColor(secondColor)
        }
    }
    /// 是否 显示按钮
    public var isShowInfoIcon: Bool = true {
        didSet {
            brainwaveView.infoButton.isHidden = !isShowInfoIcon
        }
        
    }
    /// 圆角
    public var borderRadius: CGFloat = 8.0 {
        didSet {
            brainwaveView.layer.cornerRadius = borderRadius
            brainwaveView.layer.masksToBounds = true
        }
    }
    /// 背景色
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF") {
        didSet {
            brainwaveView.backgroundColor = bgColor
        }
    }
    /// 左脑颜色
    public var leftBrainwaveLineColor = UIColor.colorWithHexString(hexColor: "FF4852") {
        didSet  {
            brainwaveView.leftDot.backgroundColor = leftBrainwaveLineColor
           
        }
    }
    /// 右脑颜色
    public var rightBrainwaveLineColor = UIColor.colorWithHexString(hexColor: "0064FF") {
        didSet {
            brainwaveView.rightDot.backgroundColor = rightBrainwaveLineColor
        }
    }
    /// 按钮点击显示的图片
    public var infoUrlString = "https://www.notion.so/EEG-b3a44e9eb01549c29da1d8b2cc7bc08d"
    /// 按钮图片
    public var buttonImageName: String = ""  {
        didSet {
            brainwaveView.infoButton.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    
    //MARK:- Private param
    private let titleText = "实时脑波"
    private let disposeBag = DisposeBag()
    
    //MARK:- Private UI
    private let brainwaveView = BrainwaveView()
    
    public init() {
        super.init(frame: CGRect.zero)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    ///  demo observe
    public func observe(with left: [Float], right: [Float]) {
        observeRealtimeValue()
        setDemo(left: left, right: right)
    }
    
    /// observe eeg data
    public func observe() {
        observeRealtimeValue()
    }
    
    private func observeRealtimeValue() {
        let updateBrainwave = UpdateBrainwaveValue()
        updateBrainwave.rxLeftBrainwaveValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            if value.count > 10 {
                self.brainwaveView.setEEGArray(value, .left)
            }
            
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        updateBrainwave.rxRightBrainwaveValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            if value.count > 10 {
                self.brainwaveView.setEEGArray(value, .right)
            }
            
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    
    override func setUI() {
        let changedMainColor = mainColor.changeAlpha(to: 1.0)
        let changedTextColor = textColor.changeAlpha(to: 0.5)
        
        brainwaveView.layer.cornerRadius = borderRadius
        brainwaveView.layer.masksToBounds = true
        self.addSubview(brainwaveView)
        self.backgroundColor = .clear
        
        brainwaveView.titleLabel.font = UIFont(name: textFont, size: 14)
        brainwaveView.titleLabel.text = titleText
        brainwaveView.titleLabel.textColor = changedMainColor
        
        brainwaveView.leftDot.backgroundColor = leftBrainwaveLineColor
        brainwaveView.rightDot.backgroundColor = rightBrainwaveLineColor
        
        brainwaveView.leftBrainLabel.text = "左脑"
        brainwaveView.leftBrainLabel.textColor = changedTextColor
        
        brainwaveView.rightBrainLabel.text = "右脑"
        brainwaveView.rightBrainLabel.textColor = changedTextColor
        
        brainwaveView.setLineColor(left: leftBrainwaveLineColor, right: rightBrainwaveLineColor)
        
        if !isShowInfoIcon  {
            brainwaveView.infoButton.isHidden = true
        } else {
            brainwaveView.infoButton.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        }
        
        
    }
    
    override func setLayout() {
        brainwaveView.snp.makeConstraints {
            $0.height.equalTo(321)
            $0.width.greaterThanOrEqualTo(268).priority(.high)
            $0.left.right.equalToSuperview().priority(.medium)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
    private func setDemo(left:[Float], right:[Float]) {
        brainwaveView.leftBrain.setArray(left)
        brainwaveView.leftData = left
        brainwaveView.rightBrain.setArray(right)
        brainwaveView.rightData = right
    }
    
}
