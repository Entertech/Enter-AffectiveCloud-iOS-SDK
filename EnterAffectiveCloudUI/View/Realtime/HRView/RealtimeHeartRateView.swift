//
//  HeartRateView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

protocol HeartRateValueProtocol {
    var rxHeartRateValue: BehaviorSubject<Int> {set get}
}

class UpdateHeartRate: HeartRateValueProtocol {
    var rxHeartRateValue: BehaviorSubject<Int>
    
    init(_ initValue: Int = 0) {
        rxHeartRateValue = BehaviorSubject<Int>(value: initValue)
        NotificationCenter.default.addObserver(self, selector: #selector(biodataSubscript(_:)), name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
        rxHeartRateValue.onCompleted()
    }
    
    @objc func biodataSubscript(_ notification: Notification) {
    
        if let data = notification.userInfo!["biodataServicesSubscribe"] as? CSBiodataProcessJSONModel {

            if let eeg = data.hr {
                if let hr = eeg.hr {
                    
                    self.rxHeartRateValue.onNext(Int(hr))
                    
                }
            }
            return
        }
            
    }
    
}

public class RealtimeHeartRateView: BaseView {
    
    //MARK:- Public param
    /// 主色调显示
    public var mainColor = UIColor.colorWithHexString(hexColor: "0064ff")  {
        didSet {
            self.titleLabel?.textColor = mainColor.changeAlpha(to: 1.0)
        }
    }
    private var textFont = "PingFangSC-Semibold"
    /// 字体颜色
    public var textColor = UIColor.colorWithHexString(hexColor: "171726")  {
        didSet {
            let firstTextColor = textColor.changeAlpha(to: 1.0)
            let secondTextColor = textColor.changeAlpha(to: 0.7)
            let thirdTextColor = textColor.changeAlpha(to: 0.5)
            heartRateLabel?.textColor = firstTextColor
            bpmLabel?.textColor = firstTextColor
            maxLabel?.textColor = secondTextColor
            maxValueLabel?.textColor = secondTextColor
            maxBpmLabel?.textColor = thirdTextColor
            minLabel?.textColor = secondTextColor
            minLabel?.textColor = secondTextColor
            minBpmLabel?.textColor = thirdTextColor
        }
    }
    /// 是否显示最大最小值
    public var isShowExtremeValue: Bool = true{
        didSet {
            maxLabel?.isHidden = !isShowExtremeValue
            maxBpmLabel?.isHidden = !isShowExtremeValue
            maxValueLabel?.isHidden = !isShowExtremeValue
            minLabel?.isHidden = !isShowExtremeValue
            minBpmLabel?.isHidden = !isShowExtremeValue
            minValueLabel?.isHidden = !isShowExtremeValue
            
        }

    }
    
    /// 是否显示信息按钮
    public var isShowInfoIcon: Bool = true{
        didSet {
            infoBtn?.isHidden = !isShowInfoIcon
        }
        
    }
    /// 圆角
    public var borderRadius: CGFloat = 8.0  {
        didSet {
            bgView.layer.cornerRadius = borderRadius
            bgView.layer.masksToBounds = true
        }
    }
    /// 背景色
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF") {
        didSet {
            bgView.backgroundColor = bgColor
        }
    }
    
    /// 信息按钮打开的网页
    public var infoUrlString = "https://www.notion.so/Heart-Rate-4d64215ac50f4520af7ff516c0f0e00b"
    /// 按钮图片
    public var buttonImageName: String = "" {
        didSet {
            self.infoBtn?.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    
    //MARK:- Private param
    private let titleText = "心率"
    private var maxValue: Int = 0
    private var minValue: Int = 0
    private let disposeBag = DisposeBag()
    
    //MARK:- Private UI
    private var bgView: UIView =  UIView()
    private var titleLabel: UILabel?
    private var heartRateLabel: UILabel?
    private var bpmLabel: UILabel?
    private var maxLabel: UILabel?
    private var minLabel: UILabel?
    private var maxValueLabel: UILabel?
    private var minValueLabel: UILabel?
    private var maxBpmLabel: UILabel?
    private var minBpmLabel: UILabel?
    private var infoBtn: UIButton?
    private var heartImageView: UIImageView?
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    //MARK:- override function
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 开启监听
    /// - Parameter demo: demo数据
    public func observe(with demo: Int) {
        observeRealtimeValue(demo)
    }
    /// 开启监听
    public func observe() {
        observeRealtimeValue()
    }
    
    private func observeRealtimeValue(_ demo: Int = 0) {
        let updateHeartRate = UpdateHeartRate(demo)
        updateHeartRate.rxHeartRateValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if value > 0 {
                    self.heartRateLabel?.text = "\(value)"
                } else {
                    self.heartRateLabel?.text = "--"
                }
                
                if value > 0, self.minValue > value {
                    self.minValue = value
                    self.minValueLabel?.text = String(value)
                }
                if self.maxValue == 0 {
                    self.maxValue = value
                    self.maxValueLabel?.text = String(self.maxValue)
                } else if self.maxValue < value {
                    self.maxValue = value
                    self.maxValueLabel?.text = String(self.maxValue)
                }
            }
            
        }, onError: { (error) in
            print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func setUI() {
        
        let changedMainColor = mainColor.changeAlpha(to: 1.0)
        let firstTextColor = textColor.changeAlpha(to: 1.0)
        let secondTextColor = textColor.changeAlpha(to: 0.7)
        let thirdTextColor = textColor.changeAlpha(to: 0.5)
        
        bgView.backgroundColor = bgColor
        bgView.layer.cornerRadius = borderRadius
        bgView.layer.masksToBounds = true
        self.backgroundColor = .clear
        self.addSubview(bgView)
            
        titleLabel = UILabel()
        titleLabel?.text = titleText
        titleLabel?.textColor = changedMainColor
        titleLabel?.font = UIFont(name: textFont, size: 14)
        bgView.addSubview(titleLabel!)
        
        heartRateLabel = UILabel()
        heartRateLabel?.text = "--"
        heartRateLabel?.textColor = firstTextColor
        heartRateLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 48)
        heartRateLabel?.textAlignment = .left
        bgView.addSubview(heartRateLabel!)
        
        bpmLabel = UILabel()
        bpmLabel?.text = "bpm"
        bpmLabel?.textColor = firstTextColor
        bpmLabel?.font = UIFont.systemFont(ofSize: 16)
        bgView.addSubview(bpmLabel!)
        
        heartImageView = UIImageView()
        heartImageView?.animationImages = UIImage.resolveGifImage(gif: "heart")
        heartImageView?.animationDuration = 2
        heartImageView?.animationRepeatCount = Int.max
        heartImageView?.startAnimating()
        bgView.addSubview(heartImageView!)
        
        maxLabel = UILabel()
        maxLabel?.text = "最大值："
        maxLabel?.textAlignment = .right
        maxLabel?.font = UIFont(name: textFont, size: 14)
        maxLabel?.textColor = secondTextColor
        bgView.addSubview(maxLabel!)
        
        maxValueLabel = UILabel()
        maxValueLabel?.text = "\(maxValue)"
        maxValueLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        maxValueLabel?.textAlignment = .right
        maxValueLabel?.textColor = secondTextColor
        bgView.addSubview(maxValueLabel!)
        
        maxBpmLabel = UILabel()
        maxBpmLabel?.text = "bpm"
        maxBpmLabel?.textColor = thirdTextColor
        maxBpmLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(maxBpmLabel!)
        
        minLabel = UILabel()
        minLabel?.text = "最小值："
        minLabel?.textAlignment = .right
        minLabel?.font = UIFont(name: textFont, size: 14)
        minLabel?.textColor = secondTextColor
        bgView.addSubview(minLabel!)
        
        minValueLabel = UILabel()
        minValueLabel?.text = "\(minValue)"
        minValueLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        minValueLabel?.textAlignment = .right
        minValueLabel?.textColor = secondTextColor
        bgView.addSubview(minValueLabel!)
        
        minBpmLabel = UILabel()
        minBpmLabel?.text = "bpm"
        minBpmLabel?.textColor = thirdTextColor
        minBpmLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(minBpmLabel!)
        
    
    
    
        infoBtn = UIButton(type: .custom)
        infoBtn?.setImage(UIImage.loadImage(name: "icon_info_black"), for: .normal)
        infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        bgView.addSubview(infoBtn!)

    }
    
    override func setLayout() {
        bgView.snp.makeConstraints {
            $0.height.equalTo(123)
            $0.width.greaterThanOrEqualTo(168).priority(.high)
            $0.left.right.equalToSuperview().priority(.medium)
        }
        
        titleLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(17)
        }
        
        bpmLabel?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-18)
        }
        
        heartImageView?.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(33)
            $0.bottom.equalTo(bpmLabel!.snp_topMargin).offset(-8)
            $0.centerX.equalTo(bpmLabel!.snp_centerXWithinMargins)
        }
        
        heartRateLabel?.snp.makeConstraints {
            $0.left.equalTo(bpmLabel!.snp.rightMargin).offset(24)
            $0.bottom.equalToSuperview().offset(-16)
        }
            
        infoBtn?.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel!.snp_centerYWithinMargins)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        minBpmLabel?.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        minValueLabel?.snp.makeConstraints {
            $0.centerY.equalTo(minBpmLabel!.snp_centerYWithinMargins)
            $0.right.equalTo(minBpmLabel!.snp.leftMargin).offset(-16)
        }
        
        minLabel?.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-68)
            $0.centerY.equalTo(minBpmLabel!.snp_centerYWithinMargins)
        }
        
        maxBpmLabel?.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-44)
            $0.right.equalToSuperview().offset(-16)
        }
        
        
        maxValueLabel?.snp.makeConstraints {
            $0.centerY.equalTo(maxBpmLabel!.snp_centerYWithinMargins)
            $0.right.equalTo(maxBpmLabel!.snp.leftMargin).offset(-16)
        }
        
        maxLabel?.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-68)
            $0.centerY.equalTo(maxBpmLabel!.snp_centerYWithinMargins)
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
}
