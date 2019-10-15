//
//  RealtimeStressLevelView.swift
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

protocol PressureProtocol {
    var rxPressureValue: BehaviorSubject<Float> {set get}
}

class UpdatePressure: PressureProtocol {
    var rxPressureValue = BehaviorSubject<Float>(value: 0)
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(affectiveDataSubscript(_:)), name: NSNotification.Name.affectiveDataSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.affectiveDataSubscribeNotify, object: nil)
        rxPressureValue.onCompleted()
    }
    
    @objc func affectiveDataSubscript(_ notification: Notification) {
    
        if let data = notification.userInfo!["affectiveDataSubscribe"] as? CSAffectiveSubscribeProcessJsonModel {
            if let pressure = data.pressure?.pressure {
                rxPressureValue.onNext(pressure/20.0)
            }
           
            return
        }
            
    }
    
}

public class RealtimePressureView: BaseView {

    
    //MARK:- Public param
    public var DemoValue = 0
    public var mainColor = UIColor.colorWithHexString(hexColor: "0064ff")
    public var textFont = "PingFangSC-Semibold"
    public var textColor = UIColor.colorWithHexString(hexColor: "171726")
    public var isShowInfoIcon = true
    public var borderRadius: CGFloat = 8.0
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF")
    public var infoUrlString = "https://www.notion.so/Pressure-ee57f4590373442b9107b7ce665e1253"
    
    //MARK:- Private param
    private let titleText = "压力值"
    private let disposeBag = DisposeBag()
    
    //MARK:- Private UI
    private var bgView: UIView =  UIView()
    private var titleLabel: UILabel?
    private var pressureValueLabel: UILabel?
    private var stateLabel: UILabel?
    private var infoBtn: UIButton?
    private var rodView: SurveyorsRodView?
    
    
    //MARK:- override function
    public init() {
        super.init(frame: CGRect.zero)
        observeRealtimeValue()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        observeRealtimeValue()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        observeRealtimeValue()
    }
    
    private func observeRealtimeValue() {
        let updatePressure = UpdatePressure()
        updatePressure.rxPressureValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if value > 0 {
                    self.pressureValueLabel?.text = "\(value)"
                    self.rodView?.setDotValue(index: Float(value))
                } else {
                    self.pressureValueLabel?.text = "--"
                    self.rodView?.setDotValue(index: 0)
                }
                
                if value > 3.5 && value <= 5 {
                    self.stateLabel?.text = "高"
                } else if value > 1 && value <= 3.5 {
                    self.stateLabel?.text = "中"
                } else {
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
        let secondTextColor = mainColor.changeAlpha(to: 0.5)
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
        
        pressureValueLabel = UILabel()
        pressureValueLabel?.text = "--"
        pressureValueLabel?.textColor = valueTextColor
        pressureValueLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        pressureValueLabel?.textAlignment = .left
        bgView.addSubview(pressureValueLabel!)
        
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
        rodView?.scaleArray = [0, 1, 2, 3, 4, 5]
        rodView?.setLabelColor(grayTextColor)
        rodView?.setDotColor(firstTextColor)
        let rangeArray: [CGFloat] = [0, 1, 3.5, 5]
        rodView?.setBarColor([thirdTextColor, secondTextColor, firstTextColor], rangeArray)
        rodView?.setDotValue(index: 0)
        bgView.addSubview(rodView!)
        
        if isShowInfoIcon {
            infoBtn = UIButton(type: .custom)
            infoBtn?.setImage(UIImage.init(named: "icon_info_black", in: Bundle.init(for: self.classForCoder), with: .none), for: .normal)
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
            $0.centerY.equalTo(titleLabel!.snp.centerYWithinMargins)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        pressureValueLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-56)
        }
        
        stateLabel?.snp.makeConstraints {
            $0.left.equalTo(pressureValueLabel!.snp.rightMargin).offset(12)
            $0.width.equalTo(24)
            $0.height.equalTo(16)
            $0.bottom.equalTo(pressureValueLabel!.snp.bottomMargin).offset(-4)
        }
        
        
        rodView?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.height.equalTo(25)
            $0.bottom.equalTo(-16)
        }
        
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }

}
