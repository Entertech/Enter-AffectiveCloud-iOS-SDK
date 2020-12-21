//
//  AffectiveChartHRVView2.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/12/2.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class AffectiveChartCoherenceView2: UIView, ChartViewDelegate{
    
    public var uploadCycle = 0 {
        willSet {
            chartView.uploadCycle = UInt(newValue)
        }
    }

    public var currentTime: Int = 0 {
        willSet {
            let left = newValue/60
            let remainder = newValue%60
            coherenceTimeLabel.text = "\(left)min \(remainder)s"
                
            
        }
    }
    
    /// 主要线条颜色
    public var lineColor: UIColor = UIColor.colorWithHexString(hexColor: "#FF6682") {
        willSet {
            chartView.lineColor = newValue
        }
    }
    /// 子线条颜色
    public var paddingLineColor: UIColor = ColorExtension.greenPrimary {
        willSet {
            chartView.paddingLineColor = newValue
        }
    }
    
    /// 标题
    public var title: String = "Heart Rate Variability(HRV)" {
        willSet {
            chartHead.titleText = newValue
        }
    }
    
    public var minText: String = "Time(min)" {
        willSet {
            minLabel.text = newValue
        }
    }
    
    public var coherenceText: String = "Coherence Time:" {
        willSet {
            coherenceLabel.text = newValue
        }
    }
    
    public var breathText: String = "Breath Coherence" {
        willSet {
            breathLabel.text = newValue
        }
    }
    
    public var coherenceList: [Int]? {
        willSet {
            if let list = newValue {
                chartView.setPadding(list: list)
            }
        }
    }
    
    public var hrvList: [Int]? {
        willSet {
            if let list = newValue {
                chartView.setData(list: list)
            }
        }
    }
    
    public var hrvAvg: Int = 0 {
        willSet {
            chartView.hrvAvg = Float(newValue)
        }
    }
    
    public var zoomText = "Zoom in on the curve and slide to view it."
    
    
    //MARK:- Private UI
    private var isChartScale = false {
        willSet {
            chartView.scaleXEnabled = newValue
            chartHead.expandBtn.isHidden = !newValue
        }
    }
    private var textColor = ColorExtension.textLv1
    private var axisLabelColor = ColorExtension.textLv2
    private var xAxisLineColor = ColorExtension.textLv1
    private var gridLineColor = ColorExtension.lineLight
    
    private let coherenceLabel = UILabel()
    private let coherenceTimeLabel = UILabel()
    private let chartView = HRChart()
    private let minLabel = UILabel()
    private let dotView = UIView()
    private let breathLabel = UILabel()
    private let chartHead = PrivateChartViewHead()
    private lazy var dotIcon = UIImage.highlightIcon(centerColor: self.lineColor)
    
    public init() {
        super.init(frame: CGRect.zero)
        setUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.addSubview(chartHead)
        self.addSubview(chartView)
        self.addSubview(coherenceLabel)
        self.addSubview(coherenceTimeLabel)
        self.addSubview(minLabel)
        self.addSubview(dotView)
        self.addSubview(breathLabel)
        
        coherenceLabel.textColor = textColor
        coherenceLabel.text = coherenceText
        coherenceLabel.font = UIFont.systemFont(ofSize: 14)
        
        coherenceTimeLabel.textColor = paddingLineColor
        coherenceTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        coherenceTimeLabel.text = "0min 0s"
        minLabel.textColor = textColor
        minLabel.font = UIFont.systemFont(ofSize: 12)
        minLabel.textAlignment = .center
        minLabel.text = minText
        
        dotView.backgroundColor = paddingLineColor
        dotView.layer.cornerRadius = 4
        
        breathLabel.text = breathText
        breathLabel.font = UIFont.systemFont(ofSize: 12)
        
        chartView.delegate = self
        chartView.maxScreenCount = 200
        chartView.maxDataCount = 500
        chartView.isUserInteractionEnabled = true
        
        chartHead.titleText = title
        chartHead.expandBtn.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        chartView.addGestureRecognizer(pressGesture)//添加长按事件
        
        setLayout()
    }
    
    private func setLayout() {
        coherenceLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(chartHead.snp.bottom).offset(8)
        }
        
        coherenceTimeLabel.snp.makeConstraints {
            $0.left.equalTo(coherenceLabel.snp.right).offset(6)
            $0.centerY.equalTo(coherenceLabel.snp.centerY).offset(-2)
        }
        
        chartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(coherenceLabel.snp.bottom)
            $0.bottom.equalTo(minLabel.snp.top).offset(-12)
        }
        
        minLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        dotView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(8)
            $0.top.equalTo(coherenceLabel.snp.bottom).offset(20)
        }
        
        breathLabel.snp.makeConstraints {
            $0.left.equalTo(dotView.snp.right).offset(4)
            $0.centerY.equalTo(dotView.snp.centerY)
        }
        
    }
    

    
    fileprivate var isZoomed = false
    fileprivate var isHiddenNavigationBar = false
    @objc
    private func zoomBtnTouchUpInside(sender: UIButton) {

        if !isZoomed {
            let vc = self.parentViewController()!
            if let navi = vc.navigationController {
                 if !navi.navigationBar.isHidden {
                     isHiddenNavigationBar = true
                     vc.navigationController?.setNavigationBarHidden(true, animated: true)
                 }
             }
            let view = vc.view
            let nShowChartView = UIView()
            nShowChartView.backgroundColor = ColorExtension.bgZ1
            view?.addSubview(nShowChartView)
            if #available(iOS 13.0, *) {
                nShowChartView.backgroundColor = UIColor.systemBackground
            } else {
                // Fallback on earlier versions
                
            }
            let chart = AffectiveChartCoherenceView2()
            nShowChartView.addSubview(chart)
            chart.chartHead.expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
            //chart.interval = self.interval
            //chart.bgColor = self.bgColor
            //chart.lineColor = self.lineColor
            //chart.cornerRadius = self.cornerRadius
            chart.currentTime = self.currentTime
            chart.chartView.uploadCycle = UInt(self.uploadCycle)
            chart.chartView.maxDataCount = 1000
            chart.chartView.maxScreenCount = 0
            chart.textColor = self.textColor
            chart.isChartScale = true
            chart.coherenceList = self.coherenceList
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.isZoomed = true
            chart.isHiddenNavigationBar = isHiddenNavigationBar
            chart.chartView.highlightPerTapEnabled = false
            chart.chartView.highlightPerDragEnabled = false
            //chart.chartView.highlightLineColor = self.highlightLineColor
            //chart.chartView.markerBackgroundColor = self.markerBackgroundColor
            chart.hrvAvg = self.hrvAvg
            chart.title = self.title
            
            chart.chartView.setPadding(list: coherenceList ?? [])
            chart.chartView.setData(list: hrvList)
            let label = UILabel()
            label.text = zoomText
            label.font = UIFont.systemFont(ofSize: 12)
            chart.chartHead.addSubview(label)
            label.snp.makeConstraints {
                $0.right.equalTo(chart.chartHead.expandBtn.snp.left).offset(-12)
                $0.centerY.equalTo(chart.chartHead.expandBtn.snp.centerY)
            }
            nShowChartView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            chart.snp.remakeConstraints {
                $0.width.equalTo(nShowChartView.snp.height).offset(-88)
                $0.height.equalTo(nShowChartView.snp.width).offset(-42)
                $0.center.equalTo(view!.snp.center)
            }
            
        } else {
            let view = self.superview!
            if isHiddenNavigationBar {
                view.parentViewController()?.navigationController?.setNavigationBarHidden(false, animated: true)
            }
            for e in view.subviews {
                e.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
        
    }
    
    @objc
    private func tapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let h = chartView.getHighlightByTouchPoint(sender.location(in: self))
            if h === nil || h == chartView.lastHighlighted {
                chartView.lastHighlighted = nil
                chartView.highlightValue(nil)
                //chartHead.isHidden = true
                setItemHidden(true)
                chartView.delegate?.chartViewDidEndPanning?(chartView)
            } else {
                chartView.lastHighlighted = h
                chartView.highlightValue(h)
                //chartHead.isHidden = true
                setItemHidden(true)
                chartView.delegate?.chartValueSelected?(chartView, entry: chartView.data!.entryForHighlight(h!)!, highlight: h!)
            }
        } else if sender.state == .changed {
            let h = chartView.getHighlightByTouchPoint(sender.location(in: self))
            if let h = h {
                chartView.lastHighlighted = h
                chartView.highlightValue(h)
                //chartHead.isHidden = true
                setItemHidden(true)
                chartView.delegate?.chartValueSelected?(chartView, entry: chartView.data!.entryForHighlight(h)!, highlight: h)
            }
        } else if sender.state == .ended {
            chartView.lastHighlighted = nil
            chartView.highlightValue(nil)
            //chartHead.isHidden = false
            setItemHidden(false)
            chartView.delegate?.chartViewDidEndPanning?(chartView)
        }
    }
    
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        chartView.lastHighlighted = nil
        chartView.highlightValue(nil)
        //chartHead.isHidden = false
        setItemHidden(false)
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if !chartHead.isHidden {
            //chartHead.isHidden = true
            setItemHidden(true)
        }
        for i in 0..<chartView.data!.dataSets[0].entryCount {
            chartView.data?.dataSets[0].entryForIndex(i)?.icon = nil
        }
        entry.icon = dotIcon
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //chartHead.isHidden = false
        setItemHidden(true)
    }
    
    private func setItemHidden(_ bIsHidden: Bool) {
        breathLabel.isHidden = bIsHidden
        dotView.isHidden = bIsHidden
        coherenceLabel.isHidden = bIsHidden
        coherenceTimeLabel.isHidden = bIsHidden
        
    }
 
}


