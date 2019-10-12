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
    var rxSpectrumValue = BehaviorSubject<(Float, Float, Float, Float, Float)>(value:(0,0,0,0,0))
    
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(biodataSubscript(_:)), name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
        rxSpectrumValue.onCompleted()
    }
    
    @objc func biodataSubscript(_ notification: Notification) {
    
        if let data = notification.userInfo!["biodataServicesSubscribe"] as? CSBiodataProcessJSONModel {
            if let eeg = data.eeg {
                if let _ = eeg.alpha {
                    rxSpectrumValue.onNext((eeg.alpha!, eeg.belta!, eeg.gamma!, eeg.delta!, eeg.theta!))
                }
            }
            
        }
            
    }
    
}

class RealtimeBrainwaveSpectrumView: BaseView {
    //MARK:- Public param
    public var mainColor = UIColor.colorWithHexString(hexColor: "23233A")
    public var textFont = "PingFangSC-Semibold"
    public var textColor = UIColor.colorWithHexString(hexColor: "171726")
    public var isShowInfoIcon = true
    public var borderRadius: CGFloat = 8.0
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF")
    public var infoUrlString = "https://www.notion.so/Brainwave-Power-4cdadda14a69424790c2d7913ad775ff"
    
    //MARK:- Private param
    private let titleText = "脑波频谱"
    private let disposeBag = DisposeBag()
    
    //MARK:- Private UI
    private let spectrumView = BrainwaveSpectrumView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let updateSpectrum = UpdateBrainwaveSpectrum()
        updateSpectrum.rxSpectrumValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.spectrumView.setSpectrum(value.0, .α)
                self.spectrumView.setSpectrum(value.1, .β)
                self.spectrumView.setSpectrum(value.2, .γ)
                self.spectrumView.setSpectrum(value.3, .δ)
                self.spectrumView.setSpectrum(value.4, .θ)
            }
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spectrumView.updateConstraints()
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
