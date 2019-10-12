//
//  RealtimeRelaxationView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/12.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

protocol RelaxationProtocol {
    var rxRelaxationValue: BehaviorSubject<Float> {set get}
}

class UpdateRelaxation: RelaxationProtocol {
    var rxRelaxationValue = BehaviorSubject<Float>(value: 0)
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(affectiveDataSubscript(_:)), name: NSNotification.Name.affectiveDataSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.affectiveDataSubscribeNotify, object: nil)
        rxRelaxationValue.onCompleted()
    }
    
    @objc func affectiveDataSubscript(_ notification: Notification) {
    
        if let data = notification.userInfo!["affectiveDataSubscribe"] as? CSAffectiveSubscribeProcessJsonModel {
            if let relaxation = data.relaxation?.relaxation {
                rxRelaxationValue.onNext(relaxation)
            }
           
            return
        }
            
    }
    
}

class RealtimeRelaxationView: BaseView {

    //MARK:- Public param
    public var mainColor = UIColor.colorWithHexString(hexColor: "23233A")
    public var textFont = "PingFangSC-Semibold"
    public var textColor = UIColor.colorWithHexString(hexColor: "171726")
    public var isShowInfoIcon = true
    public var borderRadius: CGFloat = 8.0
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF")
    public var infoUrlString = "https://www.notion.so/Relaxation-c9e3b39634a14d2fa47eaed1d55d872b"
    
    //MARK:- Private param
    private let titleText = "放松度"
    private let disposeBag = DisposeBag()
    
    //MARK:- Private UI
    private var bgView: UIView =  UIView()
    private var titleLabel: UILabel?
    private var relaxationValueLabel: UILabel?
    private var stateLabel: UILabel?
    private var infoBtn: UIButton?
    private var rodView: SurveyorsRodView?
    
    //MARK:- override function
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let updateRelaxation = UpdateRelaxation()
        updateRelaxation.rxRelaxationValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if value > 0 {
                    self.relaxationValueLabel?.text = "\(value)"
                    self.rodView?.setDotValue(index: Float(value))
                } else {
                    self.relaxationValueLabel?.text = "--"
                    self.rodView?.setDotValue(index: 0)
                }
                
                if value > 80 && value <= 100 {
                    self.stateLabel?.text = "高"
                } else if value > 60 && value <= 80 {
                    self.stateLabel?.text = "中"
                } else {
                    self.stateLabel?.text = "低"
                }
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
        if let rodView = rodView  {
            rodView.updateConstraints()
        }
        
    }
    
    override func setUI() {
        let valueTextColor = textColor.changeAlpha(to: 1.0)
        let grayTextColor = textColor.changeAlpha(to: 0.8)
        let firstTextColor = mainColor.changeAlpha(to: 1.0)
        let secondTextColor = mainColor.changeAlpha(to: 0.6)
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
        
        relaxationValueLabel = UILabel()
        relaxationValueLabel?.text = "--"
        relaxationValueLabel?.textColor = valueTextColor
        relaxationValueLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        relaxationValueLabel?.textAlignment = .left
        bgView.addSubview(relaxationValueLabel!)
        
        stateLabel = UILabel()
        stateLabel?.backgroundColor = thirdTextColor
        stateLabel?.text = "低"
        stateLabel?.font = UIFont.systemFont(ofSize: 11)
        stateLabel?.textAlignment = .center
        stateLabel?.textColor = firstTextColor
        stateLabel?.layer.cornerRadius = 12
        stateLabel?.layer.masksToBounds = true
        bgView.addSubview(stateLabel!)
        
        rodView = SurveyorsRodView()
        rodView?.scaleArray = [0, 60, 80, 100]
        rodView?.setLabelColor(grayTextColor)
        rodView?.setDotColor(firstTextColor)
        let rangeArray: [CGFloat] = [0, 60, 80, 100]
        rodView?.setBarColor([thirdTextColor, secondTextColor, firstTextColor], rangeArray)
        rodView?.setDotValue(index: 0)
        bgView.addSubview(rodView!)
        
        if isShowInfoIcon {
            infoBtn = UIButton(type: .custom)
            infoBtn?.setImage(#imageLiteral(resourceName: "icon_info_black"), for: .normal)
            infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
            bgView.addSubview(infoBtn!)
        }
    }
    
    override func setLayout() {
        bgView.snp.makeConstraints {
            $0.height.equalTo(152)
            $0.width.greaterThanOrEqualTo(168).priority(.high)
            $0.left.right.equalToSuperview().priority(.medium)
        }
        
        titleLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(17)
        }
        
        infoBtn?.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel!.snp.centerXWithinMargins)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        relaxationValueLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(56)
        }
        
        stateLabel?.snp.makeConstraints {
            $0.left.equalTo(relaxationValueLabel!.snp.rightMargin).offset(6)
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.bottom.equalTo(relaxationValueLabel!.snp.bottomMargin).offset(-4)
        }
        
        
        rodView?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(12)
            $0.height.equalTo(22)
            $0.bottom.equalTo(20)
        }
        
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }

}
