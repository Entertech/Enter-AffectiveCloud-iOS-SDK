//
//  AffectiveCharts3StackView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/16.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit
import Charts

public protocol AffectiveCharts3RhythmsLineDelegate: AnyObject {
    func setLines(value: Int)
}

/// 脑波报表sessions 部分
public class AffectiveCharts3StackView: UIView {

    private let infoView = AffectiveCharts3ExpandRhythmView()
    private let chartView = AffectiveCharts3RhythmsStackView()
    private var startDate: Date!
    internal var theme: AffectiveChart3Theme!
    public weak var delegate: AffectiveCharts3RhythmsLineDelegate?
    
    private var panValue:CGFloat = 0
    private var bIsCalculatePan = false
    var isFullScreen = false
    var rhythmsLinesStore = 0
    

    public func build(value: Array2D<Double>) {

        chartView.setData(value: value)
    }

    
    public func setRhythmLineEnable(value: Int) -> Self {
        infoView.setLineEnable(value: value)
        rhythmsLinesStore = value
        return self
    }
    
    public func setParam(theme: AffectiveChart3Theme!) -> Self {
        self.theme = theme
        infoView.style = theme.style
        self.startDate = theme.startDate

        self.addSubview(chartView)
        self.addSubview(infoView)
        
        infoView.delegate = self
        infoView.expandDelegate = self
        infoView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.leading.trailing.top.equalToSuperview()
        }
        infoView.setUI(isAlreadShow: isFullScreen)
            .setLayout()
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        chartView.setProperty(type: theme.style, startDate: startDate)
        chartView.addGestureRecognizer(pressGesture)//添加长按事件
        chartView.delegate = self
        chartView.dateSouce = infoView
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return self
    }
    
    @objc
    private func tapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let h = chartView.getHighlightByTouchPoint(sender.location(in: self))
            if h === nil || h == chartView.lastHighlighted {
                chartView.lastHighlighted = nil
                chartView.highlightValue(nil)
                infoView.isHidden = true
            } else {
                chartView.lastHighlighted = h
                chartView.highlightValue(h)
                infoView.isHidden = true
            }
        } else if sender.state == .changed {
            let h = chartView.getHighlightByTouchPoint(sender.location(in: self))
            if let h = h {
                chartView.lastHighlighted = h
                chartView.highlightValue(h)
                infoView.isHidden = true
            }
        } else if sender.state == .ended {
            chartView.lastHighlighted = nil
            chartView.highlightValue(nil)
            infoView.isHidden = false
        }
    }
    
}

extension AffectiveCharts3StackView: RhythmsViewDelegate {
    public func setRhythmsEnable(value: Int) {
        delegate?.setLines(value: value)
        switch value {
        case 1:
            chartView.enableGama = false
        case 2:
            chartView.enableGama = true
        case 4:
            chartView.enableBeta = false
        case 8:
            chartView.enableBeta = true
        case 16:
            chartView.enableAlpha = false
        case 32:
            chartView.enableAlpha = true
        case 64:
            chartView.enableTheta = false
        case 128:
            chartView.enableTheta = true
        case 256:
            chartView.enableDelta = false
        case 512:
            chartView.enableDelta = true
        default:
            break
            
        }
    }
    
    
}

extension AffectiveCharts3StackView: AffectiveCharts3ExpandDelegate {
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
                if theme.style == .session {
                    self.chartView.dragEnabled = true
                    chartView.scaleXEnabled = true
                }
                
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
                if theme.style == .session {
                    self.chartView.dragEnabled = false
                    chartView.scaleXEnabled = false
                }
                
            }
        }
    }
    
    
}

extension AffectiveCharts3StackView: ChartViewDelegate {
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
                        aim -= 0.1
                    }
                } else {
                    let date = self.startDate.getMonthAfter(month: Int(round(leftValue)))
                    if let day = date?.get(.month) {
                        aim = round(leftValue - Double(day) + 1.0)
                        aim -= 0.2
                    }
                }
                
                self.chartView.moveViewToAnimated(xValue: aim, yValue: 0, axis: .left, duration: 0.2, easingOption: .easeInCubic)
                self.chartView.lastXValue = aim

            } else if self.panValue < -15 {
                let rightValue = self.chartView.highestVisibleX
                var aim = 0.0
                if self.theme.style == .month {
                    let date = self.startDate.getDayAfter(days: Int(round(rightValue)))
                    if let day = date?.get(.day) {
                        aim = round(rightValue - Double(day) + 1.0)
                        aim -= 0.1
                    }
                } else {
                    let date = self.startDate.getMonthAfter(month: Int(round(rightValue)))
                    if let day = date?.get(.month) {
                        aim = round(rightValue - Double(day) + 1.0)
                        aim -= 0.2
                    }
                }

                self.chartView.moveViewToAnimated(xValue: aim, yValue: 0, axis: .left, duration: 0.2, easingOption: .easeInCubic)
                self.chartView.lastXValue = aim

            } else {
                self.chartView.moveViewToAnimated(xValue: self.chartView.lastXValue, yValue: 0, axis: .left, duration: 0.1, easingOption: .easeInCubic)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                let time = self.chartView.calculatAverageTime()
                let ave = self.chartView.calculatAverage()
                self.chartView.dateSouce?.update(single: nil, mult: ave, from: time.0, to: time.1)
            }
            self.panValue = 0
            self.bIsCalculatePan = false
        }
        
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        if !bIsCalculatePan {
            
            panValue += dX
        } else {
            
        }
    }
    
    

}
