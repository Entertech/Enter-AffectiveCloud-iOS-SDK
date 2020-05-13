//
//  RealtimeArousalView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/1/16.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

protocol ArousalProtocol {
    var rxArousalValue: BehaviorSubject<Float> {set get}
}

class UpdateArousal: ArousalProtocol {
    var rxArousalValue: BehaviorSubject<Float>
    
    init(_ initValue: Float = 0) {
        rxArousalValue = BehaviorSubject<Float>(value: initValue)
        NotificationCenter.default.addObserver(self, selector: #selector(affectiveDataSubscript(_:)), name: NSNotification.Name.affectiveDataSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.affectiveDataSubscribeNotify, object: nil)
        rxArousalValue.onCompleted()
    }
    
    @objc func affectiveDataSubscript(_ notification: Notification) {
    
        let value = notification.userInfo!["affectiveDataSubscribe"] as! AffectiveCloudResponseJSONModel
            if let data = value.dataModel as? CSAffectiveSubscribeProcessJsonModel {
                
                if let attention = data.arousal?.arousal {
                    rxArousalValue.onNext(attention)
                }
            }
        
            
    }
    
}

public class RealtimeArousalView: BaseView {
    //MARK:- Public param
    /// 主色
    public var mainColor = UIColor.colorWithHexString(hexColor: "0064ff")  {
        didSet {
            let firstTextColor = mainColor.changeAlpha(to: 1.0)
            let thirdTextColor = mainColor.changeAlpha(to: 0.2)
            titleLabel?.textColor = firstTextColor
            stateLabel?.textColor = firstTextColor
            stateLabel?.backgroundColor = thirdTextColor
            rodView?.setDotColor(firstTextColor)
            let rangeArray: [CGFloat] = [-2, 0, 2]
            rodView?.setBarColor([thirdTextColor, firstTextColor], rangeArray)
        }
    }
    private var textFont = "PingFangSC-Semibold"
    
    /// 文字颜色
    public var textColor = UIColor.colorWithHexString(hexColor: "171726") {
        didSet {
            let valueTextColor = textColor.changeAlpha(to: 1.0)
            let grayTextColor = textColor.changeAlpha(to: 0.8)
            arousalValueLabel?.textColor = valueTextColor
            rodView?.setLabelColor(grayTextColor)
        }
    }
    
    /// 是否显示按钮
    public var isShowInfoIcon: Bool = true {
        didSet {
            infoBtn?.isHidden = !isShowInfoIcon
        }
        
    }
    /// 圆角
    public var borderRadius: CGFloat = 8.0 {
        didSet {
            bgView.layer.cornerRadius = borderRadius
            bgView.layer.masksToBounds = true
            self.maskCorner = borderRadius
        }
    }
    /// 背景色
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF") {
        didSet {
            bgView.backgroundColor = bgColor
        }
    }
    /// 按钮点击后显示的网页地址
    public var infoUrlString = "https://www.notion.so/Attention-84fef81572a848efbf87075ab67f4cfe"
    /// 按钮图片
    public var buttonImageName: String = "" {
        didSet {
            self.infoBtn?.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    
    public var title: String = "" {
        willSet {
            titleLabel?.text = newValue
        }
    }
    
    //MARK:- Private param
    private let titleText = "激活度"
    private let disposeBag = DisposeBag()
    
    //MARK:- Private UI
    private var bgView: UIView =  UIView()
    private var titleLabel: UILabel?
    private var arousalValueLabel: UILabel?
    private var stateLabel: UILabel?
    private var infoBtn: UIButton?
    private var rodView: SurveyorsRodView?
    private var updateArousal: UpdateArousal?
    private var isFirstData = true
    //MARK:- override function
    public init() {
        super.init(frame: CGRect.zero)
        //observeRealtimeValue()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    public func observe(with demo: Float) {
        observeRealtimeValue(demo)
    }
    
    public func observe() {
        observeRealtimeValue()
    }
        
      
    private func observeRealtimeValue(_ demo: Float = 0) {
        updateArousal = UpdateArousal(demo)
        updateArousal?.rxArousalValue.subscribe(onNext: {[weak self] (valueOrigin) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if self.isFirstData {
                    self.isFirstData = false
                    
                } else {
                    if valueOrigin > 0 {
                        if self.bIsNeedUpdateMask {
                            self.dismissMask()
                        }
                    }
                }
                if valueOrigin != 0 {
                    let value = valueOrigin / 25.0 - 2.0
                    
                    self.arousalValueLabel?.text = String(format: "%0.1f", value)
                    self.rodView?.setDotValue(index: Float(value))
                    
                    if value > 0 {
                        self.stateLabel?.text = "高"
                    } else {
                        self.stateLabel?.text = "低"
                    }
                } else {
                    self.arousalValueLabel?.text = "--"
                    self.stateLabel?.text = "低"
                }

            }
            
            }, onError: { (error) in
                print(error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func setUI() {
        let valueTextColor = textColor.changeAlpha(to: 1.0)
        let grayTextColor = textColor.changeAlpha(to: 0.8)
        let firstTextColor = mainColor.changeAlpha(to: 1.0)
        let thirdTextColor = mainColor.changeAlpha(to: 0.2)
        
        bgView.backgroundColor = bgColor
        bgView.layer.cornerRadius = borderRadius
        bgView.layer.masksToBounds = true
        self.backgroundColor = .clear
        self.addSubview(bgView)
        
        titleLabel = UILabel()
        titleLabel?.text = titleText
        titleLabel?.textColor = firstTextColor
        titleLabel?.font = UIFont(name: textFont, size: 14)
        bgView.addSubview(titleLabel!)
        
        arousalValueLabel = UILabel()
        arousalValueLabel?.text = "--"
        arousalValueLabel?.textColor = valueTextColor
        arousalValueLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        arousalValueLabel?.textAlignment = .left
        bgView.addSubview(arousalValueLabel!)
        
        stateLabel = UILabel()
        stateLabel?.backgroundColor = thirdTextColor
        stateLabel?.text = "低"
        stateLabel?.font = UIFont.systemFont(ofSize: 11)
        stateLabel?.textAlignment = .center
        stateLabel?.textColor = firstTextColor
        stateLabel?.layer.cornerRadius = 8
        stateLabel?.layer.masksToBounds = true
        bgView.addSubview(stateLabel!)
        
        rodView = SurveyorsRodView()
        rodView?.scaleArray = [-2, -1, 0, 1, 2]
        rodView?.setLabelColor(grayTextColor)
        rodView?.setDotColor(firstTextColor)
        let rangeArray: [CGFloat] = [-2, 0, 2]
        rodView?.setBarColor([thirdTextColor, firstTextColor], rangeArray)
        rodView?.setDotValue(index: 0)
        bgView.addSubview(rodView!)
        
        if isShowInfoIcon {
            infoBtn = UIButton(type: .custom)
            infoBtn?.setImage(UIImage.loadImage(name: "icon_info_black", any: classForCoder), for: .normal)
            infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
            bgView.addSubview(infoBtn!)
        }
    }
    
    override func setLayout() {
        bgView.snp.makeConstraints {
//            $0.height.equalTo(152)
//            $0.width.greaterThanOrEqualTo(168).priority(.high)
            $0.edges.equalToSuperview().priority(.medium)
        }
        
        titleLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(17)
        }
        
        infoBtn?.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel!.snp.centerYWithinMargins)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        arousalValueLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-56)
        }
        
        stateLabel?.snp.makeConstraints {
            $0.left.equalTo(arousalValueLabel!.snp.right).offset(12)
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.bottom.equalTo(arousalValueLabel!.snp.bottomMargin).offset(-4)
        }
        
        
        rodView?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.height.equalTo(29)
            $0.bottom.equalTo(-16)
        }
        
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
      
}
