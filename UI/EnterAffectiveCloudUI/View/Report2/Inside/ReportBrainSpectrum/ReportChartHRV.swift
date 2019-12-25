//
//  ReportChartHRV.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/25.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class PrivateReportChartHRV: UIView, ChartViewDelegate {
    
    public var lineColor: UIColor = UIColor.colorWithHexString(hexColor: "#FFC56F")

    /// 背景颜色
    public var bgColor: UIColor = .white {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    /// 圆角
    public var cornerRadius: CGFloat = 8 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    /// 文字颜色
    public var textColor: UIColor = UIColor.colorWithHexString(hexColor: "333333") {
        didSet  {
            let changedColor = textColor.changeAlpha(to: 0.7)
            let secondColor = textColor.changeAlpha(to: 0.5)
            xLabel?.textColor = changedColor
            
            chartView?.leftAxis.labelTextColor = changedColor
            chartView?.xAxis.labelTextColor = changedColor
            chartView?.xAxis.gridColor = secondColor
        }
    }

    public var isChartScale = false {
        willSet {
            chartView?.scaleXEnabled = newValue
            chartHead?.expandBtn.isHidden = !newValue
        }
    }
    
    public var sample = 3
    
    public var hrvAvg: Int = 0 {
        willSet  {
            let avgLine = ChartLimitLine(limit: Double(newValue), label: "AVG: \(newValue)")
            avgLine.lineDashPhase = 0
            avgLine.lineDashLengths = [8, 4]
            avgLine.lineColor = textColor.changeAlpha(to: 0.5)
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            chartView?.leftAxis.addLimitLine(avgLine)
        }
    }
    
    //MARK:- Private UI
    private var maxDataCount = 100
    private let mainFont = "PingFangSC-Semibold"
    private let interval = 0.4
    private var timeStamp = 0
    private var hrvArray: [Int]?
    //MARK:- Private UI
    private var chartHead: PrivateChartViewHead?
    private var titleLabel: UILabel?
    private var chartView: LineChartView?
    public var xLabel: UILabel?
    private var msLabel: UILabel?
    private var nShowChartView: UIView?
    public init() {
        super.init(frame: CGRect.zero)
        initFunction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFunction()
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunction()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let _ = self.superview else {
            return
        }
        
        xLabel?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        chartView?.snp.makeConstraints {
            $0.top.equalTo(chartHead!.snp.bottom).offset(0)
            $0.right.equalToSuperview().offset(-8)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-45)
        }
        
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    func initFunction() {
        let alphaColor = textColor.changeAlpha(to: 0.7)
        let secondColor = textColor.changeAlpha(to: 0.3)
        
        self.layer.cornerRadius = cornerRadius
        
        chartHead = PrivateChartViewHead()
        chartHead?.titleText = "Changes During Meditation"
        chartHead?.expandBtn.addTarget(self, action: #selector(zoomBtnTouchUpInside(sender:)), for: .touchUpInside)
        self.addSubview(chartHead!)
        
        xLabel = UILabel()
        xLabel?.text = "Time(min)"
        xLabel?.textAlignment = .center
        xLabel?.font = UIFont.systemFont(ofSize: 12)
        xLabel?.textColor = alphaColor
        self.addSubview(xLabel!)
        
        chartView = LineChartView()
        chartView?.leftYAxisRenderer = LimitYAxisRenderer(viewPortHandler: chartView!.viewPortHandler, yAxis: chartView?.leftAxis, transformer: chartView?.getTransformer(forAxis: .left))
        chartView?.delegate = self
        chartView?.backgroundColor = .clear
        chartView?.gridBackgroundColor = .clear
        chartView?.drawBordersEnabled = false
        chartView?.chartDescription?.enabled = false
        chartView?.pinchZoomEnabled = false
        chartView?.scaleXEnabled = false
        chartView?.scaleYEnabled = false
        chartView?.legend.enabled = false
        chartView?.highlightPerTapEnabled = false
        
        let leftAxis = chartView!.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = alphaColor
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMaxLabels = 3
        leftAxis.axisLineColor = secondColor
        chartView?.rightAxis.enabled = false
        
        let xAxis = chartView!.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.gridLineWidth = 1
        xAxis.labelPosition = .bottom
        xAxis.gridColor = secondColor
        xAxis.labelTextColor = alphaColor
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)

        self.addSubview(chartView!)
    }
    
    public func setDataFromModel(hrv: [Int]?, timestamp: Int? = nil) {
        
        if let timestamp = timestamp, timestamp != 0 {
            timeStamp = timestamp
            
            xLabel?.isHidden = true
        }
        
        if let hrv = hrv {
            sample = hrv.count / maxDataCount
            hrvArray = hrv
            setDataCount(hrv)
        }
        
    }
   //MARK:- Chart delegate
   private func setDataCount(_ waveArray: [Int]) {
       var colors: [UIColor] = []
       var initValue = 0
       var initIndex = 0
       for i in stride(from: 0, to: waveArray.count, by: sample) {
           if waveArray[i] > 0 {
               initValue = waveArray[i]
               initIndex = i
               break
           }
       }

       var yVals: [ChartDataEntry] = []
       var notZero: Int = 0
       for i in stride(from: 0, to: waveArray.count, by: sample) {
           if i < initIndex{
               colors.append(#colorLiteral(red: 0.9, green: 0.90, blue: 0.90, alpha: 0.7))
               yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
           } else {
               if waveArray[i] == 0 {
                   colors.append(#colorLiteral(red: 0.9, green: 0.90, blue: 0.90, alpha: 0.7))
                   yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
               } else {
                   notZero = waveArray[i]
                   colors.append(lineColor)
                   yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i])))
               }
               
           }
           
       }
       let set = LineChartDataSet(entries: yVals, label: "")
       set.mode = .linear
       set.drawCirclesEnabled = false
       set.drawCircleHoleEnabled = false
       set.drawFilledEnabled = false
       set.lineWidth = 3
       set.colors = colors
       set.drawValuesEnabled = false
       let data = LineChartData(dataSet: set)
       chartView?.data = data
       setLimitLine(yVals.count)
       
   }
   
    private var timeApart: [Int] = []
    private func setLimitLine(_ valueCount: Int) {
        let timeCount = Double(valueCount * sample) * interval
        let minTime = (Int(timeCount) / 60 / 8 + 1) * 60

        for i in stride(from: 0, to: Int(timeCount), by: minTime) {
           timeApart.append(i)
        }
        
        chartView?.xAxis.axisMinimum = 0
        chartView?.xAxis.axisMaximum = Double(timeCount) //设置表格的所有点数
        chartView?.setVisibleXRangeMinimum(100) //限制屏幕最少显示100个点

        self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(timeApart, timeStamp)

       //self.chartView?.leftAxis.valueFormatter = HRVValueFormatter()

    }
    
    private var isScaled = false
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        let lineChart = chartView as! LineChartView
        if lineChart.scaleX > 1.1{
            if !isScaled {
                self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(timeStamp, true)
                isScaled = true
                
            }
        } else {
            if isScaled {
                self.chartView?.xAxis.valueFormatter = HRVXValueFormatter(timeApart, timeStamp)
                isScaled = false
            }
        }
    }
    
    fileprivate var isZoomed = false
    @objc
    private func zoomBtnTouchUpInside(sender: UIButton) {
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            sender.isEnabled = true
        }
        if !isZoomed {
            let vc = self.parentViewController()!
            vc.navigationController?.setNavigationBarHidden(true, animated: true)
            let view = vc.view
            let nShowChartView = UIView()
            nShowChartView.backgroundColor = UIColor.colorWithHexString(hexColor: "#E5E5E5")
            view?.addSubview(nShowChartView)
            
            let chart = PrivateReportChartHRV()
            nShowChartView.addSubview(chart)
            chart.bgColor = self.bgColor
            chart.cornerRadius = self.cornerRadius
            chart.maxDataCount = 300
            chart.textColor = self.textColor
            chart.isChartScale = true
            chart.setDataFromModel(hrv: hrvArray)
            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*3/2))
            chart.isZoomed = true
            chart.hrvAvg = self.hrvAvg
            nShowChartView.snp.makeConstraints {
               $0.left.right.top.equalToSuperview()
               $0.bottom.equalTo(view!.safeAreaLayoutGuide)
            }

            chart.snp.remakeConstraints {
                $0.width.equalTo(nShowChartView.snp.height).offset(-88)
                $0.height.equalTo(nShowChartView.snp.width).offset(-42)
               $0.center.equalToSuperview()
            }

        } else {
            let view = self.superview!
            for e in view.subviews {
                e.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
       
    }
}
