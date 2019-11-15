//
//  RealtimeBrainwaveSpectrumView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/12.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

protocol BrainwaveSpectrumValueProtocol {
    var rxSpectrumValue: BehaviorSubject<(Float, Float, Float, Float, Float)> {set get}
}

class UpdateBrainwaveSpectrum: BrainwaveSpectrumValueProtocol {
    var rxSpectrumValue: BehaviorSubject<(Float, Float, Float, Float, Float)>
    
    
    init(_ value: (Float, Float, Float, Float, Float) = (0,0,0,0,0)) {
        rxSpectrumValue = BehaviorSubject<(Float, Float, Float, Float, Float)>(value:value)
        NotificationCenter.default.addObserver(self, selector: #selector(biodataSubscript(_:)), name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
        rxSpectrumValue.onCompleted()
    }
    
    @objc func biodataSubscript(_ notification: Notification) {
    
        if let value = notification.userInfo!["biodataServicesSubscribe"] as? AffectiveCloudResponseJSONModel {
            if let data = value.dataModel as? CSBiodataProcessJSONModel {
                if let eeg = data.eeg {
                    if let _ = eeg.alpha {
                        rxSpectrumValue.onNext((eeg.gamma!, eeg.belta!, eeg.alpha!, eeg.theta!, eeg.delta!))
                    }
                }
            }
        }
    }
    
}

public class RealtimeBrainwaveSpectrumView: BaseView {
    //MARK:- Public param
    /// 主色
    public var mainColor = UIColor.colorWithHexString(hexColor: "0064ff") {
        didSet {
            let changedMainColor = mainColor.changeAlpha(to: 1.0)
            spectrumView.alphaBar.backgroundColor = changedMainColor
            spectrumView.betaBar.backgroundColor = changedMainColor
            spectrumView.gamaBar.backgroundColor = changedMainColor
            spectrumView.thetaBar.backgroundColor = changedMainColor
            spectrumView.deltaBar.backgroundColor = changedMainColor
            spectrumView.titleLabel.textColor = changedMainColor
        }
    }
    private var textFont = "PingFangSC-Semibold"
    /// 文字颜色
    public var textColor = UIColor.colorWithHexString(hexColor: "171726") {
        didSet {
            let firstTextColor = textColor.changeAlpha(to: 1.0)
            let secondTextColor = textColor.changeAlpha(to: 0.5)
            spectrumView.alphaLabel.textColor = firstTextColor
            spectrumView.betaLabel.textColor = firstTextColor
            spectrumView.gamaLabel.textColor = firstTextColor
            spectrumView.thetaLabel.textColor = firstTextColor
            spectrumView.deltaBar.textColor = firstTextColor
            
            spectrumView.alphaValueLabel.textColor = secondTextColor
            spectrumView.betaValueLabel.textColor = secondTextColor
            spectrumView.gamaValueLabel.textColor = secondTextColor
            spectrumView.thetaValueLabel.textColor = secondTextColor
            spectrumView.deltaValueLabel.textColor = secondTextColor
        }
    }
    /// 是否显示按钮
    public var isShowInfoIcon: Bool = true {
        didSet {
            spectrumView.infoButton.isHidden = !isShowInfoIcon
        }
        
    }
    /// 圆角
    public var borderRadius: CGFloat = 8.0 {
        didSet {
            spectrumView.layer.cornerRadius = borderRadius
            spectrumView.layer.masksToBounds = true
        }
    }
    /// 背景色
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF") {
        didSet {
            spectrumView.backgroundColor = bgColor
        }
    }
    /// 按钮点击显示的网页
    public var infoUrlString = "https://www.notion.so/Brainwave-Power-4cdadda14a69424790c2d7913ad775ff"
    /// 按钮图片
    public var buttonImageName: String = "" {
        didSet {
            spectrumView.infoButton.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    
    //MARK:- Private param
    private let titleText = "脑波频谱"
    private let disposeBag = DisposeBag()
    private var updateSpectrum: UpdateBrainwaveSpectrum?
    
    //MARK:- Private UI
    private let spectrumView = BrainwaveSpectrumView()
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func observe(with demo:(Float, Float, Float, Float, Float)) {
        spectrumView.isSample = true
        observeRealtimeValue(demo)
    }
    
    public func observe() {
        observeRealtimeValue()
    }
    
    private func observeRealtimeValue(_ demo: (Float, Float, Float, Float, Float) = (0,0,0,0,0)) {
        updateSpectrum = UpdateBrainwaveSpectrum(demo)
        updateSpectrum?.rxSpectrumValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.spectrumView.setSpectrum(value.0, .γ)
                self.spectrumView.setSpectrum(value.1, .β)
                self.spectrumView.setSpectrum(value.2, .α)
                self.spectrumView.setSpectrum(value.3, .θ)
                self.spectrumView.setSpectrum(value.4, .δ)
            }
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
  
    
    override func setUI() {
        let changedMainColor = mainColor.changeAlpha(to: 1.0)
        let firstTextColor = textColor.changeAlpha(to: 1.0)
        let secondTextColor = textColor.changeAlpha(to: 0.5)
        
        spectrumView.layer.cornerRadius = borderRadius
        spectrumView.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
        self.addSubview(spectrumView)
        
        spectrumView.titleLabel.text = titleText
        spectrumView.titleLabel.font = UIFont(name: textFont, size: 14)
        spectrumView.titleLabel.textColor = changedMainColor
        
        spectrumView.alphaLabel.textColor = firstTextColor
        spectrumView.betaLabel.textColor = firstTextColor
        spectrumView.gamaLabel.textColor = firstTextColor
        spectrumView.thetaLabel.textColor = firstTextColor
        spectrumView.deltaBar.textColor = firstTextColor
        
        spectrumView.alphaBar.backgroundColor = changedMainColor
        spectrumView.betaBar.backgroundColor = changedMainColor
        spectrumView.gamaBar.backgroundColor = changedMainColor
        spectrumView.thetaBar.backgroundColor = changedMainColor
        spectrumView.deltaBar.backgroundColor = changedMainColor
        
        spectrumView.alphaValueLabel.textColor = secondTextColor
        spectrumView.betaValueLabel.textColor = secondTextColor
        spectrumView.gamaValueLabel.textColor = secondTextColor
        spectrumView.thetaValueLabel.textColor = secondTextColor
        spectrumView.deltaValueLabel.textColor = secondTextColor
        
        if !isShowInfoIcon {
            spectrumView.infoButton.isHidden = true
        } else  {
            spectrumView.infoButton.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        }
    }
    
    override func setLayout() {
        spectrumView.snp.makeConstraints {
            $0.height.equalTo(232)
            $0.left.right.equalToSuperview().priority(.medium)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
   
}
