//
//  AffectiveChartsSleepPositionView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/12/15.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts
import SnapKit

public class AffectiveChartsSleepPositionView: UIView {

    internal let chartView = AffectiveChartsSleepDetailCommonView()
    internal var interval:Double = 30
    internal var dataSorce: [Double] = []
    private let limitSize:Double = 301
    /// 设置数据
    /// - Parameter array: 数据
    /// - Returns: self
    public func setData(_ array: [Int], param: AffectiveChartsSleepParameter) -> Self {
        guard array.count > 0 else {return self}
        
        let needCount = Int(limitSize) - 1
        var tmpArray = [Int]()
        if array.count < needCount {
            tmpArray.append(contentsOf: array.extendProportionally(to: needCount))
        } else {
            let remainder = array.count % needCount
            var paddedArray: [Int]
            if remainder > 0 {
                paddedArray = array.extendProportionally(to: (array.count / needCount + 1) * needCount)
            } else {
                paddedArray = array
            }
            let strideNum = paddedArray.count / needCount
            for i in stride(from: 0, to: paddedArray.count, by: strideNum) {
                let pickArray = Array(paddedArray[i..<min(i+strideNum, paddedArray.count)])
                tmpArray.append(pickArray.getMostFrequentValue() ?? 0)
            }
        }
        
        dataSorce.removeAll()
        
        tmpArray.forEach { value in
            switch value {
            case 1: //仰卧
                dataSorce.append(1)
            case 2: //俯卧
                dataSorce.append(3)
            case 3: //左侧
                dataSorce.append(7)
            case 4: //右侧
                dataSorce.append(5)
            case 5: //站立
                dataSorce.append(9)
            default:
                break
            }
            
        }
        
        let totalTime = Double(30 * array.count)
        interval = totalTime / Double(needCount)
        

        chartView.xAxis.spaceMax = 0.01
        chartView.chartParam = param
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = 10
        chartView.leftAxis.drawTopYLabelEntryEnabled = true
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        chartView.leftAxis.labelCount = 5
        chartView.leftAxis.valueFormatter = AffectiveChartsSleepPositionYFormatter(lan: param.text)
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
        guard let colors = chartView.chartParam?.lineColors, colors.count > 4 else {return}

        var yVals: [ChartDataEntry] = []
        
        for i in stride(from: 0, to: dataSorce.count, by: 1) {
            let value = dataSorce[i]
            let xValue = Double(i)*interval+(chartView.chartParam?.start ?? 0)+interval
            yVals.append(ChartDataEntry(x: xValue, y: Double(value)))
        }
        let set = LineChartDataSet(entries: yVals, label: "")
        
        set.mode = .stepped
        set.lineCapType = .round
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.lineWidth = 2
        set.setColor(colors[0])
        set.drawIconsEnabled = false
        set.highlightEnabled = false
        set.drawValuesEnabled = false
        set.setColors([colors[4],colors[3],colors[2],colors[1],colors[0]], alpha: 0.5)
        set.isDrawLineWithGradientEnabled = true
        set.gradientPositions = [1, 3, 5, 7, 9]
        let data = LineChartData(dataSet: set)
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


public class AffectiveChartsSleepPositionYFormatter: NSObject, AxisValueFormatter {
    var language = [String]()
    init(lan: [String]) {
        super.init()
        self.language = lan
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        var retValue = ""
        if value == 10 {
            retValue = language[0]
        } else if value == 8 {
            retValue = language[1]
        } else if value == 6 {
            retValue = language[2]
        } else if value == 4 {
            retValue = language[3]
        } else if value == 2 {
            retValue = language[4]
        }
        return retValue
    }
}
