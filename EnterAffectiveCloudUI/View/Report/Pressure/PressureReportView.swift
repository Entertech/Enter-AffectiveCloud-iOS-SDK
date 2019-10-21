//
//  PressureReportView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/17.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SafariServices
import SnapKit

public class PressureReportView: BaseView {

    //MARK:- Public param
    /// 标题等主色
    public var mainColor: UIColor = UIColor.colorWithHexString(hexColor: "0064ff") {
        didSet  {
            titleLabel?.textColor = mainColor
        }
    }
    /// 背景颜色
    public var bgColor: UIColor = .white {
        didSet {
            bgView?.backgroundColor = bgColor
        }
    }
    /// 圆角
    public var cornerRadius: CGFloat = 8 {
        didSet {
            bgView?.layer.cornerRadius = cornerRadius
            bgView?.layer.masksToBounds = true
        }
    }
    
    /// 按钮图片
    public var buttonImageName: String = "" {
        didSet {
            infoBtn?.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
    
    public var isShowInfoIcon: Bool = false {
        didSet {
            infoBtn?.isHidden = !self.isShowInfoIcon
        }
    }
    
    /// 按钮点击显示的网页
    public var infoUrlString = "https://www.notion.so/Pressure-Graph-48593014d6e44f7f8366364d70dced05"
    /// 采样
    public var sample: Int = 3
    
    /// 是否将时间坐标轴转化为对应时间
    public var isAbsoluteTimeAxis: Bool = false {
        didSet {
            if self.isAbsoluteTimeAxis {
                xLabel?.isHidden = true
            }
        }
    }
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithInt(r: 23, g: 23, b: 38, alpha: 0.7) {
        didSet  {
            let changedColor = textColor.changeAlpha(to: 0.7)
            chartView?.xAxisLabelColor = changedColor
            xLabel?.textColor = changedColor
            lowLabel?.textColor = changedColor
            highLabel?.textColor = changedColor
        }
    }
    
    /// 线段和填充的颜色
    public var chartColor: UIColor = UIColor.colorWithInt(r: 255, g: 103, b: 131, alpha: 1) {
        didSet {
            chartView?.chartColor = chartColor
        }
    }
    
    //MARK:- Private UI
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.8
    private var timeStamp = 0

    //MARK:- Private UI
    private var bgView: UIView?
    private var titleLabel: UILabel?
    private var infoBtn: UIButton?
    private var chartView: PressureChart?
    private var xLabel: UILabel?
    private var lowLabel: UILabel?
    private var highLabel: UILabel?
    private var barView: UIView?
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setUI() {
        self.backgroundColor = .clear
        let alphaColor = textColor.changeAlpha(to: 0.7)
        
        bgView = UIView()
        bgView?.backgroundColor = bgColor
        bgView?.layer.cornerRadius = cornerRadius
        bgView?.layer.masksToBounds = true
        self.addSubview(bgView!)
        
        titleLabel = UILabel()
        titleLabel?.text = "放松度"
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = mainColor
        bgView?.addSubview(titleLabel!)
        
        infoBtn = UIButton(type: .custom)
        infoBtn?.setImage(UIImage.init(named: "icon_info_black", in: Bundle.init(identifier: "cn.entertech.EnterAffectiveCloudUI"), with: .none), for: .normal)
        infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        bgView?.addSubview(infoBtn!)
        
        xLabel = UILabel()
        xLabel?.text = "时间(分钟)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = alphaColor
        bgView?.addSubview(xLabel!)
        
        chartView = PressureChart()
        chartView?.chartColor = chartColor
        chartView?.backgroundColor = .clear
        bgView?.addSubview(chartView!)
        
        lowLabel = UILabel()
        lowLabel?.text = "低"
        lowLabel?.textColor = alphaColor
        lowLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView?.addSubview(lowLabel!)
        
        highLabel = UILabel()
        highLabel?.text = "高"
        highLabel?.textColor = alphaColor
        highLabel?.font = UIFont.systemFont(ofSize: 12)
        bgView?.addSubview(highLabel!)
        
        barView = UIView()
        bgView?.addSubview(barView!)
    }
    
    override func setLayout() {
        bgView?.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        titleLabel?.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(16)
        }
        
        infoBtn?.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel!.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        barView?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(220)
            $0.height.equalTo(14)
            $0.top.equalToSuperview().offset(70)
        }
        
        lowLabel?.snp.makeConstraints {
            $0.right.equalTo(barView!.snp.left).offset(-5)
            $0.top.equalToSuperview().offset(69)
        }
        
        highLabel?.snp.makeConstraints {
            $0.left.equalTo(barView!.snp.right).offset(5)
            $0.top.equalToSuperview().offset(69)
        }
        
        chartView?.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(300)
            $0.top.equalTo(barView!.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    
    func setDataFromModel(timestamp: Int?, pressure: [Float]?, count: Int?) {
        
        if let timestamp = timestamp {
            timeStamp = timestamp
            if isAbsoluteTimeAxis {
                chartView?.timeStamp = timestamp
            }
        }
        
        if let value = pressure, let count = count {
            setChartValue(value, count)
        }
        
        let layer = CAGradientLayer()
        if barView!.bounds.width == 0 {
            layer.frame = CGRect(x: 0, y: 0, width: 220, height: 14)
        } else {
            layer.frame = barView!.bounds
        }
        
        layer.colors = [chartColor.changeAlpha(to: 0).cgColor, chartColor.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 0.0)
        barView!.layer.addSublayer(layer)
        
    }
    
    public func setChartValue(_ value: [Float], _ originCount: Int) {
        chartView?.pressureArray = value
        chartView?.valueCount = originCount
    }
}
