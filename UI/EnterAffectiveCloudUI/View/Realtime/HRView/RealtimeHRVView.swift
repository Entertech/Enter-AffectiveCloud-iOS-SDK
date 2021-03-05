//
//  RealtimeHRVView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/1/14.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import SafariServices
import EnterAffectiveCloud

protocol HRVValueProtocol {
    var rxHRVValue: BehaviorSubject<Int> {set get}
}

class UpdateHRV: HRVValueProtocol {
    var rxHRVValue: BehaviorSubject<Int>
    
    init(_ initValue: Int = 0) {
        rxHRVValue = BehaviorSubject<Int>(value: initValue)
        NotificationCenter.default.addObserver(self, selector: #selector(biodataSubscript(_:)), name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.biodataServicesSubscribeNotify, object: nil)
        rxHRVValue.onCompleted()
    }
    
    @objc func biodataSubscript(_ notification: Notification) {
    
        let value = notification.userInfo!["biodataServicesSubscribe"] as! AffectiveCloudResponseJSONModel
        if let data = value.dataModel as? CSBiodataProcessJSONModel {
            if let eeg = data.hr {
                if let hrv = eeg.hrv {
                    for e in hrv {
                        self.rxHRVValue.onNext(Int(e))
                    }
                }
            }
        }
    }
    
}

public class RealtimeHRVView: BaseView {
    /// 数据上传周期，用于计算图表x轴间隔
    public var uploadCycle: UInt = 3 {
        willSet {
            if newValue == 0 {
                interval = 0.2
            } else {
                interval = 0.2
            }
        }
    }
    
    //MARK:- Public param
    /// 主色调显示
    public var mainColor = UIColor.colorWithHexString(hexColor: "232323")  {
        didSet {
            self.titleLabel.textColor = mainColor.changeAlpha(to: 1.0)
        }
    }
    private var textFont = "PingFangSC-Semibold"
    /// 字体颜色
    public var textColor = UIColor.colorWithHexString(hexColor: "232323")
    
    public var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    /// 是否显示信息按钮
    public var isShowInfoIcon: Bool = true{
        didSet {
            infoBtn.isHidden = !isShowInfoIcon
        }
        
    }
    /// 圆角
    public var borderRadius: CGFloat = 8.0  {
        didSet {
            self.layer.cornerRadius = borderRadius
            self.layer.masksToBounds = true
        }
    }
    /// 背景色
    public var bgColor = UIColor.colorWithHexString(hexColor: "FFFFFF") {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    
    /// 信息按钮打开的网页
    public var infoUrlString = "https://www.notion.so/Heart-Rate-4d64215ac50f4520af7ff516c0f0e00b"
    /// 按钮图片
    public var buttonImageName: String = "" {
        didSet {
            self.infoBtn.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    //线条颜色
    public var lineColor = UIColor.systemRed
    
    private var interval = 1.8
    private let titleLabel = UILabel()
    private let infoBtn = UIButton()
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private var minWidth: CGFloat = 0
    private var minHeight: CGFloat = 0
    private let topMargin: CGFloat = 58
    private let bottomMargin: CGFloat = 22
    private let leftMargin: CGFloat = 16
    private let rightMargin: CGFloat = 0
    private let pointCount = 150
    private var yAxis:CGFloat = 30 // Y轴的动态坐标
    private var waveArray: [Float]?
    private var updateHRV: UpdateHRV?
    private let disposeBag = DisposeBag()
    private var isFirstData = true
    private var drawLineTimer: Timer?
    public init() {
        super.init(frame: CGRect.zero)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    /// 开启监听
    public func observe() {
        observeRealtimeValue()
    }
    
    public func observe(array: [Float]) {
        waveArray = array
        observeRealtimeValue()
    }
    
    private func observeRealtimeValue(_ demo: Int = 0) {
        updateHRV = UpdateHRV(demo)
        updateHRV?.rxHRVValue.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if self.isFirstData {
                    self.isFirstData = false
                } else  {
                    if value > 0 {
                        self.appendArray(value)
                        if self.bIsNeedUpdateMask {
                            self.dismissMask()
                        }
                    }
                }
            }
            }, onError: { (error) in
                print(error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func setUI() {
        self.layer.cornerRadius = 8
        self.addSubview(titleLabel)
        self.addSubview(infoBtn)
        
        titleLabel.font = UIFont(name: textFont, size: 14)
        titleLabel.textColor = mainColor
        titleLabel.text = "HRV"
        
        infoBtn.setImage(UIImage.loadImage(name: "icon_info_black", any: classForCoder), for: .normal)
        infoBtn.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(17)
        }
        
        infoBtn.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        height = self.bounds.height - topMargin - bottomMargin
        width = self.bounds.width - leftMargin - rightMargin
        minWidth = width / CGFloat(pointCount)
        minHeight = height / yAxis
        setLine()
    }
    
    private func setLine() {
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: leftMargin, y: topMargin))
        linePath.addLine(to: CGPoint(x: leftMargin, y: topMargin+height))
        linePath.addLine(to: CGPoint(x: leftMargin+width, y:topMargin+height))
        let shaperLayer = CAShapeLayer()
        shaperLayer.lineWidth = 1
        shaperLayer.backgroundColor = UIColor.clear.cgColor
        shaperLayer.strokeColor = textColor.cgColor
        shaperLayer.fillColor = UIColor.clear.cgColor
        shaperLayer.path = linePath.cgPath
        
        self.layer.addSublayer(shaperLayer)
        
        for i in stride(from: 80, to: width, by: 90) {
            let dashPath = UIBezierPath()
            dashPath.move(to: CGPoint(x: i, y: topMargin))
            dashPath.addLine(to: CGPoint(x: i, y: topMargin+height))
            let dashLayer = CAShapeLayer()
            dashLayer.lineWidth = 0.6
            dashLayer.backgroundColor = UIColor.clear.cgColor
            dashLayer.strokeColor = textColor.changeAlpha(to: 0.3).cgColor
            dashLayer.path = dashPath.cgPath
            dashLayer.lineJoin = .round
            dashLayer.lineDashPhase = 0
            dashLayer.lineDashPattern = [NSNumber(value: 4), NSNumber(value: 2)]
            self.layer.addSublayer(dashLayer)
        }
    }
    
    public func appendArray(_ value: Int) {

        if waveArray == nil {
            waveArray = Array(repeating: 0.0, count: 120)
        }
        if drawLineTimer == nil {
            drawLineTimer = Timer.init(timeInterval: 0.2, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(drawLineTimer!, forMode: .common)
            drawLineTimer?.fire()
        }
        // 动态Y
        waveArray?.append(Float(value))
        if yAxis == 30.0 {
            if value > 30 {
                yAxis = CGFloat(value)
            }
        } else {
            if waveArray!.max()! <= 30.0 {
                yAxis = 30.0
            } else {
                yAxis = CGFloat(waveArray!.max()!)
            }
        }
        minHeight = height / yAxis
    }
    
    public func stopTimer() {
        if let timer = drawLineTimer {
            if timer.isValid {
                timer.invalidate()
            }
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if let array = waveArray {
            let originY = height + topMargin
            var eegNode1: [CGPoint] = Array.init()
            for (index,e) in array.enumerated() {
                if index > pointCount {
                    break
                }
                let pointX = leftMargin + 1 + CGFloat(index) * minWidth
                let pointY1 = originY - CGFloat(e) * minHeight
                let node1 = CGPoint(x: pointX, y: pointY1)
                eegNode1.append(node1)
            }
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.setStrokeColor(self.lineColor.cgColor)
            context.setLineWidth(2)
            context.setLineJoin(.round)
            context.move(to: CGPoint(x: leftMargin, y: originY))
            context.addLines(between: eegNode1)
            context.strokePath()
        }
        
        
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
    @objc
    private func timerAction(_ timer: Timer) {
        guard let _ = waveArray else {return}
        waveArray?.remove(at: 0)
        if waveArray!.count < pointCount {
            waveArray!.append(waveArray!.last!)
        }
        
        setNeedsDisplay()
    }
}
