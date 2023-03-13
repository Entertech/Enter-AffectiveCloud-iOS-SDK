//
//  AffectiveCharts3Common.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/14.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SnapKit

public class AffectiveCharts3LineCommonView: UIView {
    internal var theme: AffectiveChart3Theme!
    
    internal let titleView = AffectiveCharts3ExpandHeaderView()
    
    internal let chartView = LineChartView()
    
    internal var interval = 0.6
    
    internal var yRender: AffectiveCharts3DynamicYRender!
    
    internal var dataSorce: [Double] = []
    
    internal var maxY: Int = 100
    internal var minY: Int = 0
    internal var separateY: [Int] = []
    internal var sample = 3
    internal var maxDataCount = 2000
    internal var isFullScreen = false
    internal var coherenceValue: [Int] = []
    internal var qualityValue: [Bool] = []
    
    public func stepTwoMultiSetCoherence(value: [Int]) -> Self {
        self.coherenceValue.removeAll()
        self.coherenceValue.append(contentsOf: value)
        return self
    }
    
    public func stepSixSetQuality(value: [Int]) -> Self {
        self.qualityValue.removeAll()
        var qualityTmp = value
        if self.dataSorce.count > 0 { // 比对数组是否一致
            if qualityTmp.count < self.dataSorce.count {
                let len = dataSorce.count - qualityTmp.count
                let appendMore = Array<Int>.init(repeating: 0, count: len)
                qualityTmp.append(contentsOf: appendMore)
            }
        }
        var apartCount = 0
        //分为40, 向上取整
        if qualityTmp.count < 40 {
            apartCount = qualityTmp.count
        } else {
            apartCount = 40
        }
        let devide = Int(ceil(Double(qualityTmp.count) / Double(apartCount)))
        for i in stride(from: 0, to: qualityTmp.count, by: devide) {
            var apart = qualityTmp[i..<devide+i]
            if qualityTmp.count - (i+devide) < devide {
                apart.append(contentsOf: qualityTmp[i+devide..<qualityTmp.count])
            }
            let pass = apart.filter { value in
                value > 1
            }
            let percent = Double(pass.count) / Double(apart.count)
            if percent > 0.7 {
                qualityValue.append(true)
            } else {
                qualityValue.append(false)
            }
            if qualityTmp.count - (i+devide) < devide {
                break
            }
        }
        return self
    }
    
    /// 数据上传周期，用于计算图表x轴间隔
    public var uploadCycle: UInt = 1 {
        willSet {
            if newValue == 0 {
                interval = 0.8
            } else {
                interval = 0.6 * Double(newValue)
            }
        }
    }
    
    
    /// 设置主题, 包括颜色, 时间等
    /// - Parameter theme: AffectiveChart3Theme 主题
    /// - Returns: self
    public func stepOneSetTheme(_ theme: AffectiveChart3Theme) -> Self {
        self.theme = theme
        titleView.setTheme(theme)
            .build(isAlreadShow: isFullScreen)
        titleView.delegate = self
        self.backgroundColor = .clear
        chartView.leftAxis.labelTextColor = ColorExtension.textLv2
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        chartView.leftAxis.gridColor = ColorExtension.lineLight
        chartView.leftAxis.gridLineWidth = 0.5
        chartView.leftAxis.gridLineCap = .round
        chartView.leftAxis.gridLineDashPhase = 2.0
        chartView.leftAxis.gridLineDashLengths = [2.0, 4.0]
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesBehindDataEnabled = true
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelTextColor = ColorExtension.textLv2
        chartView.xAxis.gridColor = ColorExtension.lineLight
        chartView.xAxis.gridLineWidth = 0.5
        chartView.xAxis.gridLineCap = .round
        chartView.xAxis.gridLineDashLengths = [2.0, 4.0]
        chartView.xAxis.axisLineColor = ColorExtension.lineLight
        chartView.xAxis.axisLineWidth = 0.5
        
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisMaxLabels = 8
       
        switch theme.style {
        case .session:
            chartView.dragEnabled = true
            chartView.scaleXEnabled = true
            chartView.pinchZoomEnabled = true
            chartView.xAxis.valueFormatter = AffectiveCharts3HourValueFormatter()
        case .month:
            chartView.dragEnabled = true
            chartView.xAxis.valueFormatter = AffectiveCharts3DayValueFormatter(originDate: Date.init(timeIntervalSince1970: theme.startTime))
        case .year:
            chartView.dragEnabled = true
            chartView.xAxis.valueFormatter = AffectiveCharts3MonthValueFormatter(originDate: Date.init(timeIntervalSince1970: theme.startTime))

        }
        
        return self
    }
    
    
    /// 设置气泡
    /// - Returns: self
    public func stepFiveSetMarker() -> Self {
        let marker = AffectiveCharts3CommonMarkerView(theme: theme)
        marker.chartView = chartView
        chartView.marker = marker
        
        return self
    }

    
    /// 设置数据
    /// - Parameter array: 数据
    /// - Returns: self
    public func stepThreeSetData(_ array: [Double]) -> Self {
        guard array.count > 0 else {return self}
        dataSorce.removeAll()   
        separateY.removeAll()
        dataSorce.append(contentsOf: array)
        
        //计算抽样
        sample = array.count / maxDataCount == 0 ? 1 : Int(ceilf(Float(array.count) / Float(maxDataCount)))
        
        // 检索基准为5的倍数的最大最小值
        var maxValueFloat: Double = 0
        var minValueFloat: Double = 150
        let noZeroArray = array.filter({ v in
            v > 0
        })
        
        maxValueFloat = noZeroArray.max() ?? 150
        minValueFloat = noZeroArray.min() ?? 0
        var maxValue = Int(maxValueFloat)
        var minValue = Int(minValueFloat)
        
        let tempMax5 = (maxValue / 5 + 1) * 5 > 150 ? 150 : (maxValue / 5 + 1) * 5
        let tempMin5 = (minValue / 5 ) * 5 < 0 ? 0 : (minValue / 5) * 5

        var bSeparateIsSmall = false
        if (maxValue - minValue) / 4 >= 2 { // 有时候间距会非常小,这时候需要扩展最大最小值
            maxValue = tempMax5
            minValue = tempMin5
        } else {
            // 修改基准为2的倍数
            let tempMax2 = (maxValue / 2 + 1) * 2 > 150 ? 150 : (maxValue / 2 + 1) * 2
            let tempMin2 = (minValue / 2 ) * 2 < 0 ? 0 : (minValue / 2) * 2
            maxValue = tempMax2
            minValue = tempMin2
            bSeparateIsSmall = true
        }
        // 开始计算Y分割
        if !bSeparateIsSmall {
            let scaled = 5
            for i in (0...5) {
                let scale = scaled * i
                if (minValue-scale) < 0 {
                    if ((maxValue+scale) - minValue) % 4 == 0 {
                        chartView.leftAxis.axisMaximum = Double(maxValue+scale)
                        chartView.leftAxis.axisMinimum = Double(minValue)
                        separateY.append(minValue)
                        separateY.append((maxValue+scale)-(maxValue-minValue+scale)*3/4)
                        separateY.append((maxValue+scale)-(maxValue-minValue+scale)*2/4)
                        separateY.append((maxValue+scale)-(maxValue-minValue+scale)*1/4)
                        separateY.append(maxValue+scale)
                        break
                    }
                } else {
                    if (maxValue - (minValue-scale)) % 4 == 0 {
                        chartView.leftAxis.axisMaximum = Double(maxValue)
                        chartView.leftAxis.axisMinimum = Double(minValue-scale)
                        separateY.append(minValue-scale)
                        separateY.append(maxValue-(maxValue-minValue+scale)*3/4)
                        separateY.append(maxValue-(maxValue-minValue+scale)*2/4)
                        separateY.append(maxValue-(maxValue-minValue+scale)*1/4)
                        separateY.append(maxValue)
                        break
                    }
                }
            }
        } else {
            chartView.leftAxis.axisMaximum = Double(minValue+8)
            chartView.leftAxis.axisMinimum = Double(minValue)
            separateY.append(minValue)
            separateY.append(minValue+2)
            separateY.append(minValue+4)
            separateY.append(minValue+6)
            separateY.append(minValue+8)
        }
        return self
    }
    
    
    /// layout
    /// - Returns: self
    public func stepTwoSetLayout() -> Self {
        self.addSubview(chartView)
        self.addSubview(titleView)
        chartView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
        titleView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(90)
        }
        chartView.extraTopOffset = 92
        
        return self
    }
    
    
    /// 图表属性
    /// - Returns: self
    public func stepFourSetChartProperty() -> Self {
        yRender = AffectiveCharts3DynamicYRender(viewPortHandler: chartView.viewPortHandler, axis: chartView.leftAxis, transformer: chartView.getTransformer(forAxis: .left))
        
        chartView.leftYAxisRenderer = yRender
        chartView.backgroundColor = .clear
        chartView.animate(xAxisDuration: 0.5)
        chartView.gridBackgroundColor = .clear
        chartView.drawBordersEnabled = false
        chartView.chartDescription.enabled = false
        chartView.scaleYEnabled = false
        chartView.legend.enabled = false
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false
        let press = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        press.minimumPressDuration = 0.3
        chartView.addGestureRecognizer(press)
        
        return self
    }
    
    public func build(isShowQuality: Bool = false) {
        let invalidData = 1.0
        var sampleArray = [Double]()
        for i in stride(from: 0, to: dataSorce.count, by: sample) {
            sampleArray.append(Double(dataSorce[i]))
        }
        
        let smoothArray = sampleArray.smoothData()
        
        var yVals: [ChartDataEntry] = []
        var lineColor: [UIColor] = []
        var parts = 0.0
        let devide = qualityValue.count
        if devide > 0 {
            parts = Double(smoothArray.count) / Double(devide)
        }
        var index = 1
        for i in stride(from: 0, to: smoothArray.count, by: 1) {
            if isShowQuality {
                if sampleArray[i] < invalidData { //如果为无效数据
                    lineColor.append(theme.invalidColor)
                } else { //有效数据判断数据质量
                    if parts > 0 {
                        if Double(index) * parts < Double(i) {
                            index += 1
                        }
                        if index - 1 >= devide {
                            index = devide
                        }
                        if qualityValue[index-1] { //数据质量判断
                            lineColor.append(theme.themeColor)
                        } else {
                            lineColor.append(theme.invalidColor)
                        }
                    } else {
                        lineColor.append(theme.themeColor)
                    }
                }
            } else {
                lineColor.append(theme.themeColor)
            }

            yVals.append(ChartDataEntry(x: Double(i*sample)*interval, y: Double(smoothArray[i])))
        }
        let set = LineChartDataSet(entries: yVals, label: "")

        set.mode = .horizontalBezier
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        if isShowQuality {
            set.colors = lineColor
        } else {
            set.setColor(theme.themeColor)
        }
        
        set.drawIconsEnabled = false
        set.highlightEnabled = true
        set.highlightLineWidth = 2
        set.highlightColor = ColorExtension.lineLight
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        chartView.data = data
        yRender?.entries = separateY.filter({ v in
            v > 0
        })
    }
}


extension AffectiveCharts3LineCommonView {
    @objc
    internal func longPressGesture(_ sender: UILongPressGestureRecognizer) {
        guard let h = chartView.getHighlightByTouchPoint(sender.location(in: self.chartView)) else {return}
        if sender.state == .began {
            if h == chartView.lastHighlighted {
                chartView.lastHighlighted = nil
                chartView.highlightValue(nil)
                titleView.isHidden = true
            } else {
                chartView.lastHighlighted = h
                chartView.highlightValue(h, callDelegate: true)
                titleView.isHidden = true
            }
        } else if sender.state == .changed {
            chartView.lastHighlighted = h
            chartView.highlightValue(h, callDelegate: true)
            titleView.isHidden = true
        } else if sender.state == .ended {
            chartView.lastHighlighted = nil
            chartView.highlightValue(nil)
            titleView.isHidden = false
        }
    }
}


extension AffectiveCharts3LineCommonView: AffectiveCharts3ExpandDelegate {
    func expand(flag: Bool) {
        
        if let vc = self.parentViewController(), let view = vc.view, let parent = self.superview?.superview{
            var sv: UIScrollView?
            for e in view.subviews {
                if e.isKind(of: UIScrollView.self) {
                    sv = e as? UIScrollView
                    break
                }
            }
            
            let orginFrame = view.frame
            let bHeight = UIScreen.main.bounds.height
            let bWidth = UIScreen.main.bounds.width
            if flag {
                sv?.setContentOffset(CGPoint(x: 0, y: 36), animated: true)
                sv?.isScrollEnabled = false
                chartView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(80)
                    $0.trailing.equalToSuperview().offset(-80)
                    $0.bottom.equalToSuperview().offset(-32)
                }
                titleView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(80)
                    $0.trailing.equalToSuperview().offset(-80)
                }
                parent.snp.updateConstraints {
                    $0.height.equalTo(bWidth)
                }
                vc.navigationController?.setNavigationBarHidden(true, animated: true)
                vc.tabBarController?.tabBar.isHidden = true
                view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
                view.frame.size.height = bHeight
                view.frame.origin.y = 0
                view.frame.origin.x = -orginFrame.height+bWidth
            } else {
                sv?.isScrollEnabled = true
                sv?.setContentOffset(.zero, animated: true)
                view.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                chartView.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(0)
                    $0.trailing.equalToSuperview().offset(0)
                    $0.bottom.equalToSuperview().offset(-8)
                }
                titleView.snp.updateConstraints { make in
                    make.leading.equalToSuperview().offset(0)
                    make.trailing.equalToSuperview().offset(0)
                }

                view.frame.origin.y = 0
                view.frame.origin.x = 0
                view.frame.size.width = bWidth
                view.frame.size.height = bHeight
                view.parentViewController()?.navigationController?.setNavigationBarHidden(false, animated: true)
                parent.snp.updateConstraints {
                    $0.height.equalTo(311)
                }
                
            }
        }
        
    }
    
    
}
