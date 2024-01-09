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
    
    /// 设置数据
    /// - Parameter array: 数据
    /// - Returns: self
    public func setData(_ array: [Double], param: AffectiveChartsSleepParameter) -> Self {
        guard array.count > 0 else {return self}
        dataSorce.removeAll()
        dataSorce.append(contentsOf: array)
        let list = array.filter({$0 > 0})
        chartView.chartParam = param

        chartView.leftAxis.drawTopYLabelEntryEnabled = true
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        chartView.leftYAxisRenderer = AffectiveChartsSleepStageYRender(viewPortHandler: chartView.viewPortHandler, axis: chartView.leftAxis, transformer: chartView.getTransformer(forAxis: .left))
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
        } else if max - min < 5 {
            chartView.leftAxis.axisMinimum = min - 1 < 0 ? 0 :  min - 1
            chartView.leftAxis.axisMaximum = max + 3
        }
        
        chartView.data = data
    }

}
