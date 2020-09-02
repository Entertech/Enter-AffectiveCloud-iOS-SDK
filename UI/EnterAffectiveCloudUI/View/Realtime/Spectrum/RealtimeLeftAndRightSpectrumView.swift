//
//  RealtimeLeftAndRightSpectrumView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/9/1.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

class RealtimeLeftAndRightSpectrumView: BaseView {

    //MARK:- Public param
    /// 主色
    public var mainColor = UIColor.colorWithHexString(hexColor: "0064ff") {
        didSet {
            let changedMainColor = mainColor.changeAlpha(to: 1.0)
            spectrumView.titleLabel.textColor = changedMainColor
        }
    }
    
    public var leftColor = UIColor.gray {
        willSet {
            let changedColor = newValue.changeAlpha(to: 1.0)
            spectrumView.lalphaBar.backgroundColor = changedColor
            spectrumView.lbetaBar.backgroundColor = changedColor
            spectrumView.lgamaBar.backgroundColor = changedColor
            spectrumView.lthetaBar.backgroundColor = changedColor
            spectrumView.ldeltaBar.backgroundColor = changedColor
        }
    }
    
    public var rightColor = UIColor.lightGray {
        willSet {
            let changedColor = newValue.changeAlpha(to: 1.0)
            spectrumView.ralphaBar.backgroundColor = changedColor
            spectrumView.rbetaBar.backgroundColor = changedColor
            spectrumView.rgamaBar.backgroundColor = changedColor
            spectrumView.rthetaBar.backgroundColor = changedColor
            spectrumView.rdeltaBar.backgroundColor = changedColor
        }
    }
    
    /// 文字颜色
    public var textColor = UIColor.colorWithHexString(hexColor: "171726") {
        didSet {
            let firstTextColor = textColor.changeAlpha(to: 1.0)
            let secondTextColor = textColor.changeAlpha(to: 0.5)
            spectrumView.alphaLabel.textColor = firstTextColor
            spectrumView.betaLabel.textColor = firstTextColor
            spectrumView.gamaLabel.textColor = firstTextColor
            spectrumView.thetaLabel.textColor = firstTextColor
            spectrumView.deltaLabel.textColor = firstTextColor
            
            spectrumView.lalphaValueLabel.textColor = secondTextColor
            spectrumView.lbetaValueLabel.textColor = secondTextColor
            spectrumView.lgamaValueLabel.textColor = secondTextColor
            spectrumView.lthetaValueLabel.textColor = secondTextColor
            spectrumView.ldeltaValueLabel.textColor = secondTextColor
            
            spectrumView.ralphaValueLabel.textColor = secondTextColor
            spectrumView.rbetaValueLabel.textColor = secondTextColor
            spectrumView.rgamaValueLabel.textColor = secondTextColor
            spectrumView.rthetaValueLabel.textColor = secondTextColor
            spectrumView.rdeltaValueLabel.textColor = secondTextColor
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
            self.maskCorner = borderRadius
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
    
    public var title: String = "" {
        willSet {
            spectrumView.titleLabel.text = newValue
        }
    }
    
    //MARK:- Private param
    private let titleText = "脑波频谱"
    private let disposeBag = DisposeBag()
    private var leftSpectrum: UpdateBrainwaveSpectrum?
    private var rightSpectrum: UpdateBrainwaveSpectrum?
    private var isFirstData = true
    
    //MARK:- Private UI
    private let spectrumView = LeftAndRightSpectrumView()
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func observe() {
        observeRealtimeValue()
    }
    
    private func observeRealtimeValue() {
        leftSpectrum = UpdateBrainwaveSpectrum()
        leftSpectrum?.spectrumType = .left
        leftSpectrum?.rxSpectrumValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if self.isFirstData {
                    self.isFirstData = false
                } else  {
                    if value.0 > 0 {
                        if self.bIsNeedUpdateMask {
                            self.dismissMask()
                        }
                    }
                }
                self.spectrumView.setSpectrum(value.0, .γ, .left)
                self.spectrumView.setSpectrum(value.1, .β, .left)
                self.spectrumView.setSpectrum(value.2, .α, .left)
                self.spectrumView.setSpectrum(value.3, .θ, .left)
                self.spectrumView.setSpectrum(value.4, .δ, .left)
            }
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        rightSpectrum = UpdateBrainwaveSpectrum()
        rightSpectrum?.spectrumType = .right
        rightSpectrum?.rxSpectrumValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if self.isFirstData {
                    self.isFirstData = false
                } else  {
                    if value.0 > 0 {
                        if self.bIsNeedUpdateMask {
                            self.dismissMask()
                        }
                    }
                }
                self.spectrumView.setSpectrum(value.0, .γ, .right)
                self.spectrumView.setSpectrum(value.1, .β, .right)
                self.spectrumView.setSpectrum(value.2, .α, .right)
                self.spectrumView.setSpectrum(value.3, .θ, .right)
                self.spectrumView.setSpectrum(value.4, .δ, .right)
            }
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    private var textFont = "PingFangSC-Semibold"
    override func setUI() {
        let changedMainColor = mainColor.changeAlpha(to: 1.0)
        let firstTextColor = textColor.changeAlpha(to: 1.0)
        
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
        spectrumView.deltaLabel.textColor = firstTextColor
        
        if !isShowInfoIcon {
            spectrumView.infoButton.isHidden = true
        } else  {
            spectrumView.infoButton.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        }
        
    }
    
    override func setLayout() {
        spectrumView.snp.makeConstraints {
            //$0.height.equalTo(232)
            $0.edges.equalToSuperview().priority(.medium)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
}
