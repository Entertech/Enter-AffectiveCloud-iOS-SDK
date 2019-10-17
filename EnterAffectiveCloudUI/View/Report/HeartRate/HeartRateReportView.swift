//
//  HeartRateReportView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/17.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SafariServices
import SnapKit

public class HeartRateReportView: BaseView, ChartViewDelegate {
    
    /// MARK:- Public param
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
    
    /// 按钮点击显示的网页
    public var infoUrlString = "https://www.notion.so/Brainwave-Power-4cdadda14a69424790c2d7913ad775ff"
    /// 采样
    public var sample: Int = 3
    
    /// 是否将时间坐标轴转化为对应时间
    public var isAbsoluteTimeAxis: Bool = false
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithInt(r: 23, g: 23, b: 38, alpha: 0.7) {
        didSet  {

            
        }
    }
    
    /// 3层心率的颜色
    public var heartRateLineColors: [UIColor] = [UIColor.colorWithInt(r: 9, g: 33, b: 221, alpha: 1),
                                            UIColor.colorWithInt(r: 81, g: 103, b: 248, alpha: 1),
                                            UIColor.colorWithInt(r: 133, g: 138, b: 255, alpha: 1),] {
        didSet {
            guard heartRateLineColors.count == 3 else {
                print("WARNING: The array 'heartRateLineColors' needs 3 params")
                return
            }
//            gamaDot?.backgroundColor = spectrumColors[0]
//            betaDot?.backgroundColor = spectrumColors[1]
//            alphaDot?.backgroundColor = spectrumColors[2]
//            thetaDot?.backgroundColor = spectrumColors[3]
//            deltaDot?.backgroundColor = spectrumColors[4]
//
//            chartView?.gridBackgroundColor = spectrumColors[4]
        }
    }
    
    //MARK:- Private UI
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.4
    
    //MARK:- Private UI
    private var bgView: UIView?
    private var titleLabel: UILabel?
    private var infoBtn: UIButton?
    private var chartView: LineChartView?
    private var yLabel: UILabel?
    private var xLabel: UILabel?
    
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
        bgView = UIView()
        bgView?.backgroundColor = bgColor
        self.addSubview(bgView!)
        
        titleLabel = UILabel()
        titleLabel?.text = "心率"
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = mainColor
        bgView?.addSubview(titleLabel!)
        
        infoBtn = UIButton(type: .custom)
        infoBtn?.setImage(UIImage.init(named: "icon_info_black", in: Bundle.init(identifier: "cn.entertech.EnterAffectiveCloudUI"), with: .none), for: .normal)
        infoBtn?.addTarget(self, action: #selector(infoBtnTouchUpInside), for: .touchUpInside)
        bgView?.addSubview(infoBtn!)
        
        yLabel = UILabel.init()
        yLabel?.text = "各个频段脑电波占比 (%)"
        yLabel?.font = UIFont.systemFont(ofSize: 12)
        yLabel?.textColor = textColor
        yLabel?.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        yLabel?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*3/2))
        bgView?.addSubview(yLabel!)
        
        xLabel = UILabel()
        xLabel?.text = "时间(分钟)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = textColor
        bgView?.addSubview(xLabel!)
        
        chartView = LineChartView()
        chartView?.backgroundColor = .clear
        chartView?.gridBackgroundColor = .clear
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription?.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.isUserInteractionEnabled = false
        chartView?.setScaleEnabled(false)
        chartView?.legend.enabled = false
        
        let leftAxis = chartView!.leftAxis
        leftAxis.axisMaximum = 120
        leftAxis.axisMinimum = 30
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisLineWidth = 2.0
        leftAxis.drawLabelsEnabled = false
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.labelTextColor = .clear
        xAxis.labelPosition = .bottom
    }
    
    @objc private func infoBtnTouchUpInside() {
        let url = URL(string: infoUrlString)!
        let sf = SFSafariViewController(url: url)
        self.parentViewController()?.present(sf, animated: true, completion: nil)
    }
    

}
