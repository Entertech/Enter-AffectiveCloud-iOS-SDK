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
    var rxLeftBrainwaveValue = BehaviorSubject<[Float]>(value: [])
    
    var rxRightBrainwaveValue = BehaviorSubject<[Float]>(value: [])
    
    
    init() {
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

class RealtimeBrainwaveView: BaseView {
    //MARK:- Public param
    public var mainColor = UIColor.colorWithHexString(hexColor: "23233A")
    public var textFont = "PingFangSC-Semibold"
    public var textColor = UIColor.colorWithHexString(hexColor: "171726")
    public var isShowInfoIcon = true
    public var borderRadius: CGFloat = 8.0
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF")
    public var leftBrainwaveLineColor = UIColor.colorWithHexString(hexColor: "FF4852")
    public var rightBrainwaveLineColor = UIColor.colorWithHexString(hexColor: "0064FF")
    public var infoUrlString = "https://www.notion.so/EEG-b3a44e9eb01549c29da1d8b2cc7bc08d"
    
    //MARK:- Private param
    private let titleText = "实时脑波"
    private let disposeBag = DisposeBag()
    
    //MARK:- Private UI
    private let brainwaveView = BrainwaveView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let updateBrainwave = UpdateBrainwaveValue()
        updateBrainwave.rxLeftBrainwaveValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            self.brainwaveView.setEEGArray(value, .left)
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        updateBrainwave.rxRightBrainwaveValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            self.brainwaveView.setEEGArray(value, .right)
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        brainwaveView.updateConstraints()
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
        
        brainwaveView.leftBrain.setLineColor(leftBrainwaveLineColor)
        brainwaveView.rightBrain.setLineColor(rightBrainwaveLineColor)
        
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
}
