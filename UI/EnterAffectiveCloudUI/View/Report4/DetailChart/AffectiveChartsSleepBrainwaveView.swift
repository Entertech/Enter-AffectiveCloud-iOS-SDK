//
//  AffectiveChartsSleepBrainwaveView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/12/14.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts
import SnapKit

public class AffectiveChartsSleepBrainwaveView: UIView {

    private let gamaBtn = UIButton()
    private let betaBtn = UIButton()
    private let alphaBtn = UIButton()
    private let thetaBtn = UIButton()
    private let deltaBtn = UIButton()
    private let btnContentView = UIStackView()
    internal let chartView = AffectiveChartsSleepDetailCommonView()
    internal var interval = 1
    internal var gammaSouce: [Double] = []
    internal var betaSouce: [Double] = []
    internal var alphaSouce: [Double] = []
    internal var thetaSouce: [Double] = []
    internal var deltaSouce: [Double] = []
    private var sourceArray: [[Double]] = []
    private var gamaEnable: Bool = true
    private var betaEnable:Bool = true
    private var alphaEnable: Bool = true
    private var thetaEnable: Bool = true
    private var deltaEnable: Bool = true
    internal var separateY: [Int] = []
    private var btnEnableCount: Int {
        get {
            var count = 0
            if gamaEnable {
                count += 1
            }
            if betaEnable {
                count += 1
            }
            if alphaEnable {
                count += 1
            }
            if thetaEnable {
                count += 1
            }
            if deltaEnable {
                count += 1
            }
            return count
        }
    }
    
    /// 设置数据
    /// - Parameter array: 数据
    /// - Returns: self
    public func setData(gamma: [Double], beta:[Double], alpha: [Double], theta: [Double], delta: [Double], param: AffectiveChartsSleepParameter) -> Self {
        guard gamma.count > 0 else {return self}
        gammaSouce.removeAll()
        betaSouce.removeAll()
        alphaSouce.removeAll()
        thetaSouce.removeAll()
        deltaSouce.removeAll()
        gammaSouce.append(contentsOf: gamma)
        betaSouce.append(contentsOf: beta)
        alphaSouce.append(contentsOf: alpha)
        thetaSouce.append(contentsOf: theta)
        deltaSouce.append(contentsOf: delta)
        sourceArray = [gammaSouce, betaSouce, alphaSouce, thetaSouce, deltaSouce]
        gamaBtn.setTitleColor(param.lineColors[0], for: .selected)
        betaBtn.setTitleColor(param.lineColors[1], for: .selected)
        alphaBtn.setTitleColor(param.lineColors[2], for: .selected)
        thetaBtn.setTitleColor(param.lineColors[3], for: .selected)
        deltaBtn.setTitleColor(param.lineColors[4], for: .selected)
        gamaBtn.setTitleColor(param.lineColors[5], for: .normal)
        betaBtn.setTitleColor(param.lineColors[5], for: .normal)
        alphaBtn.setTitleColor(param.lineColors[5], for: .normal)
        deltaBtn.setTitleColor(param.lineColors[5], for: .normal)
        thetaBtn.setTitleColor(param.lineColors[5], for: .normal)
        gamaBtn.backgroundColor = param.lineColors[6]
        betaBtn.backgroundColor = param.lineColors[6]
        alphaBtn.backgroundColor = param.lineColors[6]
        deltaBtn.backgroundColor = param.lineColors[6]
        thetaBtn.backgroundColor = param.lineColors[6]
        chartView.chartParam = param
        chartView.leftAxis.axisMaxLabels = 5
        chartView.leftAxis.valueFormatter = AffectiveCharts3PercentFormatter()
        return self
    }

    /// layout
    /// - Returns: self
    public func stepTwoSetLayout() -> Self {
        self.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        chartView.extraTopOffset = 56

        gamaBtn.isSelected = true
        gamaBtn.setTitle("γ", for: .normal)
        gamaBtn.layer.cornerRadius = 12
        gamaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        gamaBtn.addTarget(self, action: #selector(gamaAction(_:)), for: .touchUpInside)
        
        betaBtn.isSelected = true
        betaBtn.setTitle("β", for: .normal)
        betaBtn.layer.cornerRadius = 12
        betaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        betaBtn.addTarget(self, action: #selector(betaAction(_:)), for: .touchUpInside)
        
        alphaBtn.isSelected = true
        alphaBtn.setTitle("α", for: .normal)
        alphaBtn.layer.cornerRadius = 12
        alphaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        alphaBtn.addTarget(self, action: #selector(alphaAction(_:)), for: .touchUpInside)
        
        thetaBtn.isSelected = true
        thetaBtn.setTitle("θ", for: .normal)
        thetaBtn.layer.cornerRadius = 12
        thetaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        thetaBtn.addTarget(self, action: #selector(thetaAction(_:)), for: .touchUpInside)
        
        deltaBtn.isSelected = true
        deltaBtn.setTitle("δ", for: .normal)
        deltaBtn.layer.cornerRadius = 12
        deltaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        deltaBtn.addTarget(self, action: #selector(deltaAction(_:)), for: .touchUpInside)
        
        
        btnContentView.alignment = .center
        btnContentView.addArrangedSubview(gamaBtn)
        btnContentView.addArrangedSubview(betaBtn)
        btnContentView.addArrangedSubview(alphaBtn)
        btnContentView.addArrangedSubview(thetaBtn)
        btnContentView.addArrangedSubview(deltaBtn)
        btnContentView.axis = .horizontal
        btnContentView.distribution = .equalSpacing
        
        gamaBtn.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(24)
        }
        betaBtn.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(24)
        }
        alphaBtn.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(24)
        }
        thetaBtn.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(24)
        }
        deltaBtn.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(24)
        }
        
        chartView.addSubview(btnContentView)
        btnContentView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        return self
        
    }
    
    public func build() {
        var minValue:Int = 100
        var maxValue:Int = 0
        var sets: [LineChartDataSet] = []
        for j in 0..<sourceArray.count {
            
            var initValue = 0
            var initIndex = 0
            for i in stride(from: 0, to: sourceArray[j].count, by: 1) {
                if sourceArray[j][i] > 0 {
                    initValue = Int(sourceArray[j][i])
                    initIndex = i
                    break
                }
            }

            var yVals: [ChartDataEntry] = []
            var notZero: Int = 0
            for i in stride(from: 0, to: sourceArray[j].count, by: 1) {
                let source = sourceArray[j][i]
                minValue = min(minValue, Int(source))
                maxValue = max(maxValue, Int(source))
                if i < initIndex{  //为0的为无效数据
                    yVals.append(ChartDataEntry(x: Double(i*interval), y: Double(initValue)))
                } else {
                    if source == 0 {//为0的为无效数据
                        yVals.append(ChartDataEntry(x: Double(i*interval), y: Double(notZero)))
                    } else {
                        notZero = Int(source)
                      
                        yVals.append(ChartDataEntry(x: Double(i*interval), y: Double(source)))
                    }
                    
                }
                
            }
            chartView.leftAxis.drawTopYLabelEntryEnabled = true
            chartView.leftAxis.drawBottomYLabelEntryEnabled = false

            // 设置chart set
            let set = LineChartDataSet(entries: yVals, label: "")
            set.mode = .linear
            set.drawCirclesEnabled = false
            set.drawCircleHoleEnabled = false
            set.drawFilledEnabled = false
            set.lineWidth = 1.5
            switch j {
            case 0:
                if gamaEnable {
                    set.setColor(chartView.chartParam?.lineColors[0] ?? .black)
                } else {
                    continue
                    set.setColor(.clear)
                }
                
            case 1:
                if betaEnable {
                    
                    set.setColor(chartView.chartParam?.lineColors[1] ?? .black)
                } else {
                    continue
                    set.setColor(.clear)
                }
            case 2:
                if alphaEnable {
                    set.setColor(chartView.chartParam?.lineColors[2] ?? .black)
                } else {
                    continue
                    set.setColor(.clear)
                }
            case 3:
                if thetaEnable {
                    
                    set.setColor(chartView.chartParam?.lineColors[3] ?? .black)
                } else {
                    continue
                    set.setColor(.clear)
                }
            case 4:
                if deltaEnable {
                    
                    set.setColor(chartView.chartParam?.lineColors[4] ?? .black)
                } else {
                    continue
                    set.setColor(.clear)
                }
            default:
                set.setColor(chartView.chartParam?.lineColors[5] ?? .black)
            }
            set.drawIconsEnabled = false
            set.highlightEnabled = false
            set.drawHorizontalHighlightIndicatorEnabled = false
            set.drawValuesEnabled = false
            sets.append(set)
        }
        
        if maxValue == minValue {
            return
        } else {
            separateY.removeAll()
            let tempMax5 = (maxValue / 5 + 1) * 5 > 200 ? 200 : (maxValue / 5 + 1) * 5
            let tempMin5 = (minValue / 5 ) * 5 < 0 ? 0 : (minValue / 5) * 5
            var scaled = 5
            if (maxValue - minValue) / 4 > 2 { // 有时候间距会非常小,这时候需要扩展最大最小值
                maxValue = tempMax5
                minValue = tempMin5
            } else {
                scaled = 1
            }
            // 开始计算Y分割

            
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
            chartView.yRender?.entries = separateY.filter({ v in
                v >= 0
            })
        }
        if sourceArray.count >= 5 && sourceArray[0].count < 24 {
            if sourceArray[0].count % 5 == 0 {
                chartView.xAxis.setLabelCount(5, force: true)
            } else if sourceArray[0].count % 4 == 0 {
                chartView.xAxis.setLabelCount(4, force: true)
            } else if sourceArray[0].count % 3 == 0 {
                chartView.xAxis.setLabelCount(3, force: true)
            }
        }
        let data = LineChartData(dataSets: sets)
        chartView.data = data
    }
    
    @objc
    private func gamaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && gamaEnable {
            return
        }
        gamaEnable = !gamaEnable
        sender.isSelected = !sender.isSelected
        build()
    }
    
    @objc
    private func betaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && betaEnable {
            return
        }
        betaEnable = !betaEnable
        sender.isSelected = !sender.isSelected
        build()
    }
    @objc
    private func alphaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && alphaEnable {
            return
        }
        alphaEnable = !alphaEnable
        sender.isSelected = !sender.isSelected
        build()
    }
    @objc
    private func thetaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && thetaEnable {
            return
        }
        thetaEnable = !thetaEnable
        sender.isSelected = !sender.isSelected
        build()
    }
    @objc
    private func deltaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && deltaEnable {
            return
        }
        deltaEnable = !deltaEnable
        sender.isSelected = !sender.isSelected
        build()
    }
}
