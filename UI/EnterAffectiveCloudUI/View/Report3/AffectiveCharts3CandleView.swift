//
//  AffectiveCharts3CandleView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/18.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SnapKit

public class AffectiveCharts3CandleView: UIView {
    internal var theme: AffectiveChart3Theme!
    internal let titleView = AffectiveCharts3ExpandHeaderView()
    internal var chartView: AffectiveCharts3CandleCommonView!
    internal var isFullScreen = false
    
    private var panValue:CGFloat = 0
    private var bIsCalculatePan = false
    private var startDate: Date!
    public func setTheme(_ theme: AffectiveChart3Theme) -> Self {
        self.theme = theme
        self.startDate = Date.init(timeIntervalSince1970: theme.startTime)
        self.backgroundColor = ColorExtension.bgZ1
        chartView = AffectiveCharts3CandleCommonView(theme: theme)
        chartView.theme = theme
        titleView.setTheme(theme).build(isAlreadShow: isFullScreen)
        return self
    }
    
    public func setProperty() -> Self {
        chartView.dataSouceChanged = titleView
        chartView.delegate = self
        titleView.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0.3
        self.addGestureRecognizer(longPressGesture)
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
    
    public func build(candle: Array2D<Double>, average: [Double]) {
        guard candle.rows > 2 else {return}
        var low: [Double] = []
        var high: [Double] = []

            for j in 0..<candle.columns {
                
                low.append(candle[j, 0])
                high.append(candle[j, 1])
                
            }
        
        chartView.setDataCount(low: low, high: high, average: average)
    }
}

extension AffectiveCharts3CandleView: AffectiveCharts3ExpandDelegate {
    func expand(flag: Bool) {
        if let vc = self.parentViewController(), let view = vc.view {
            var sv: UIScrollView?
            for e in view.subviews {
                if e.isKind(of: UIScrollView.self) {
                    sv = e as? UIScrollView
                    break
                }
            }
            
            let orginFrame = view.frame
            let orginSelfFrame = view.convert(self.chartView.frame, from: self)
            let bHeight = UIScreen.main.bounds.height
            let bWidth = UIScreen.main.bounds.width
            if flag {
                sv?.isScrollEnabled = false
                self.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(64)
                    $0.trailing.equalToSuperview().offset(-44)
                }
                vc.navigationController?.setNavigationBarHidden(true, animated: true)
                vc.tabBarController?.tabBar.isHidden = true
                view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*1/2))
                view.frame.size.height = bHeight
                
                let scale = bWidth/orginSelfFrame.height
                view.frame.size.width = view.frame.size.width*scale
                view.frame.origin.y = 0
                view.frame.origin.x =  -(orginFrame.height-orginSelfFrame.height)*scale+orginSelfFrame.origin.y
                
            } else {
                sv?.isScrollEnabled = true
                view.transform = CGAffineTransform(rotationAngle: CGFloat(0))

                view.frame.origin.y = 0
                view.frame.origin.x = 0
                view.frame.size.width = bWidth
                view.frame.size.height = bHeight
                
                view.parentViewController()?.navigationController?.setNavigationBarHidden(false, animated: true)

                self.snp.updateConstraints {
                    $0.leading.equalToSuperview().offset(16)
                    $0.trailing.equalToSuperview().offset(-16)
                }
                
            }
            
        }
    }
}
extension AffectiveCharts3CandleView: ChartViewDelegate {
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


extension AffectiveCharts3CandleView {
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
