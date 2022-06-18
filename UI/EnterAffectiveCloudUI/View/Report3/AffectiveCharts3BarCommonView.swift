//
//  AffectiveCharts3BarCommonView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/17.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SnapKit


public class AffectiveCharts3BarCommonView: UIView {
    internal var theme: AffectiveChart3Theme!
    
    internal let titleView = AffectiveCharts3ExpandHeaderView()
    
    internal var chartView: AffectiveCharts3RoundCornerBar!
    
    internal var isFullScreen = false
    
    private var panValue:CGFloat = 0
    private var bIsCalculatePan = false
    private var startDate: Date!
    public func setTheme(_ theme: AffectiveChart3Theme) -> Self {
        self.theme = theme
        self.startDate = Date.init(timeIntervalSince1970: theme.startTime)
        self.backgroundColor = ColorExtension.bgZ1
        chartView = AffectiveCharts3RoundCornerBar(theme: theme)
        chartView.theme = theme
        titleView.setTheme(theme).build(isAlreadShow: isFullScreen)
        return self
    }
    
    public func setProperty() -> Self {
        chartView.dataSouceChanged = titleView
        chartView.delegate = self
        titleView.delegate = self
        return self
    }
    
    public func setLayout() -> Self {
        self.addSubview(chartView)
        self.addSubview(titleView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        return self
    }
    
    public func build(array: [Double]) {
        chartView.setDataCount(value: array)
    }
}

extension AffectiveCharts3BarCommonView: AffectiveCharts3ExpandDelegate {
    func expand(flag: Bool) {
        if flag {
            
            let vc = self.parentViewController()!
            if let navi = vc.navigationController {
                 if !navi.navigationBar.isHidden {
                     vc.navigationController?.setNavigationBarHidden(true, animated: true)
                 }
             }
            
            let nShowChartView = UIView()
            vc.view.addSubview(nShowChartView)
            nShowChartView.backgroundColor = ColorExtension.bgZ1
            let chart = AffectiveCharts3BarCommonView()
            nShowChartView.addSubview(chart)

            chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
            chart.isFullScreen = true
            chart.setTheme(self.theme)
                .setLayout()
                .setProperty()
                .build(array: chart.chartView.dataList)
            
            nShowChartView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            chart.snp.remakeConstraints {
                $0.width.equalTo(nShowChartView.snp.height).offset(-88)
                $0.height.equalTo(nShowChartView.snp.width).offset(-42)
                $0.center.equalTo(vc.view!.snp.center)
            }
            
        } else {
            let view = self.superview!

            view.parentViewController()?.navigationController?.setNavigationBarHidden(false, animated: true)
            
            for e in view.subviews {
                e.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
    }
}
extension AffectiveCharts3BarCommonView: ChartViewDelegate {
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.bIsCalculatePan = true
            if self.panValue >= 15 {
                let leftValue = self.chartView.lowestVisibleX
                var aim = 0.0
                if self.theme.style == .month {
                    let date = self.startDate.getDayAfter(days: Int(round(leftValue)))
                    if let day = date?.get(.day) {
                        aim = round(leftValue - Double(day) + 1.0)
                        aim -= 0.3
                    }
                } else {
                    let offset = Int(leftValue) % 12
                    aim = round(leftValue - Double(offset))
                    aim -= 0.4
                }
                self.chartView.moveViewToAnimated(xValue: aim, yValue: 0, axis: .left, duration: 0.3, easingOption: .easeInCubic)
                self.chartView.lastXValue = aim
            } else if self.panValue < -15 {
                let rightValue = self.chartView.highestVisibleX
                var aim = 0.0
                if self.theme.style == .month {
                    let date = self.startDate.getDayAfter(days: Int(round(rightValue)))
                    if let day = date?.get(.day) {
                        aim = round(rightValue - Double(day) + 1.0)
                        aim -= 0.3
                    }
                } else {
                    let offset = Int(rightValue) % 12
                    aim = round(rightValue + Double(offset))
                    aim -= 0.4
                }
                self.chartView.moveViewToAnimated(xValue: aim, yValue: 0, axis: .left, duration: 0.3, easingOption: .easeInCubic)
                self.chartView.lastXValue = aim
            } else {
                self.chartView.moveViewToAnimated(xValue: self.chartView.lastXValue, yValue: 0, axis: .left, duration: 0.1, easingOption: .easeInCubic)
            }
            self.panValue = 0
            self.bIsCalculatePan = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.chartView.overloadY()
        }
        
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        if !bIsCalculatePan {
            
            panValue += dX
        } else {
            
        }
    }
}
