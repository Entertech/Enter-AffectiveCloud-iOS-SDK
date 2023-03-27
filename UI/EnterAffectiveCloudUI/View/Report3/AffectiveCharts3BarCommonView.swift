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
    public func stepOneSetTheme(_ theme: AffectiveChart3Theme) -> Self {
        self.theme = theme
        self.startDate = Date.init(timeIntervalSince1970: theme.startTime)
        self.backgroundColor = .clear
        titleView.setTheme(theme).build(isAlreadShow: isFullScreen)
        chartView = AffectiveCharts3RoundCornerBar(theme: theme)
        chartView.theme = theme
        
        return self
    }
    
    public func stepTwoSetProperty() -> Self {
        chartView.dataSouceChanged = titleView
        chartView.delegate = self
        titleView.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0.3
        chartView.addGestureRecognizer(longPressGesture)
        return self
    }
    
    public func stepThreeSetLayout() -> Self {
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
        
        return self
    }
    
    public func build(array: [Double]) {
        guard array.count > 0 else {return}
        chartView.setDataCount(value: array)
    }
}

extension AffectiveCharts3BarCommonView: AffectiveCharts3ExpandDelegate {
    func expand(flag: Bool) {
       
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
                    let date = self.startDate.getMonthAfter(month: Int(round(leftValue)))
                    if let day = date?.get(.month) {
                        aim = round(leftValue - Double(day) + 1.0)
                        aim -= 0.4
                    }
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
                    let date = self.startDate.getMonthAfter(month: Int(round(rightValue)))
                    if let day = date?.get(.month) {
                        aim = round(rightValue - Double(day) + 1.0)
                        aim -= 0.4
                    }
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

extension AffectiveCharts3BarCommonView {
    @objc
    private func longPressGesture(_ sender: UILongPressGestureRecognizer) {
        guard let h = chartView.getHighlightByTouchPoint(sender.location(in: self)) else {return}
        if sender.state == .began {
            if h == chartView.lastHighlighted {
                chartView.lastHighlighted = nil
                chartView.highlightValue(nil)
                self.titleView.isHidden = true
            } else {
                chartView.lastHighlighted = h
                chartView.highlightValue(h, callDelegate: true)
                self.titleView.isHidden = true
            }
        } else if sender.state == .changed {
            chartView.lastHighlighted = h
            chartView.highlightValue(h, callDelegate: true)
            self.titleView.isHidden = true
        } else if sender.state == .ended {
            chartView.lastHighlighted = nil
            chartView.highlightValue(nil)
            self.titleView.isHidden = false
        }
    }
    
}
