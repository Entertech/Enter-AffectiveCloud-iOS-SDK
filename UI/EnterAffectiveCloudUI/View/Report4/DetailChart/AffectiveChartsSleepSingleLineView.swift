//
//  AffectiveChartsSleepSingleLineView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/12/14.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts
import SnapKit

public class AffectiveChartsSleepSingleLineView: UIView {

    internal let chartView = AffectiveChartsSleepDetailCommonView()
    internal var interval = 1
    internal var dataSorce: [Double] = []
    internal var separateY: [Int] = []
    /// 设置数据
    /// - Parameter array: 数据
    /// - Returns: self
    public func setData(_ array: [Double], param: AffectiveChartsSleepParameter) -> Self {
        guard array.count > 0 else {return self}
        dataSorce.removeAll()
        dataSorce.append(contentsOf: array.smoothData())
        let list = array.filter({$0 > 0})
        chartView.chartParam = param

        chartView.leftAxis.drawTopYLabelEntryEnabled = true
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        return self
    }
    
    
    
    /// layout
    /// - Returns: self
    public func stepTwoSetLayout() -> Self {
        self.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        return self
    }
    

    
    public func build() {
        guard let colors = chartView.chartParam?.lineColors, colors.count > 0 else {return}

        var yVals: [ChartDataEntry] = []
        
        for i in stride(from: 0, to: dataSorce.count, by: 1) {
            let value = dataSorce[i]
       
            yVals.append(ChartDataEntry(x: Double(i*interval), y: Double(value)))
        }
        let set = LineChartDataSet(entries: yVals, label: "")
        
        set.mode = .horizontalBezier
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.setColor(colors[0])
        set.drawIconsEnabled = false
        set.highlightEnabled = false
        set.drawValuesEnabled = false
        let data = LineChartData(dataSet: set)
        
        let max = dataSorce.max() ?? 0
        let min = dataSorce.min() ?? 0
        if max == min {
            if min == 0 {
                chartView.leftAxis.axisMinimum = min
            } else {
                chartView.leftAxis.axisMinimum = min - 1 < 0 ? 0 :  min - 1
                
            }
            chartView.leftAxis.axisMaximum = max + 3
            chartView.leftAxis.granularity = 1
            chartView.leftAxis.granularityEnabled = true
        } else {
            separateY.removeAll()
            var maxValueFloat: Double = 0
            var minValueFloat: Double = 200
            let noZeroArray = dataSorce.filter({ v in
                v > 0
            })
            
            maxValueFloat = noZeroArray.max() ?? 200
            minValueFloat = noZeroArray.min() ?? 0
            var maxValue = Int(ceil(maxValueFloat))
            var minValue = Int(minValueFloat)
            
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
        if yVals.count < 24 {
            if yVals.count % 5 == 0 {
                chartView.xAxis.setLabelCount(5, force: true)
            } else if yVals.count % 4 == 0 {
                chartView.xAxis.setLabelCount(4, force: true)
            } else if yVals.count % 3 == 0 {
                chartView.xAxis.setLabelCount(3, force: true)
            }
        }
        chartView.data = data
    }

}
