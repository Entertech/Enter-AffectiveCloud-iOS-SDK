//
//  AffectiveCharts3FLow.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/2/21.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts

public class AffectiveCharts3FLowView: AffectiveCharts3LineCommonView {
    public override func stepThreeSetData(_ array: [Double]) -> Self {
        guard array.count > 0 else {return self}
        var bIsAddYAxis = false
        for e in chartView.subviews {
            if e.isKind(of: UIImageView.classForCoder()) {
                bIsAddYAxis = true
                break
            }
        }
        if !bIsAddYAxis {
//            let yAxisLine = UIImageView()
//            yAxisLine.contentMode = .scaleToFill
//            yAxisLine.image = UIImage.loadImage(name: "flow_y", any: classForCoder)
//            chartView.addSubview(yAxisLine)
//            yAxisLine.snp.makeConstraints {
//                $0.leading.equalToSuperview().offset(8)
//                $0.width.equalTo(4)
//                $0.top.equalToSuperview().offset(90)
//                $0.bottom.equalToSuperview().offset(-16)
//            }
        }
        dataSorce.removeAll()
        separateY.removeAll()
        dataSorce.append(contentsOf: array)
        
        //计算抽样
        sample = array.count / maxDataCount == 0 ? 1 : Int(ceilf(Float(array.count) / Float(maxDataCount)))
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.axisMaximum = Double(100)
        chartView.leftAxis.axisMinimum = Double(0)
        for e in 1..<4 {
            var labelName = ""
            if e == 1 {
                labelName = theme.compareName[1]
            } else if e == 3 {
                labelName = theme.compareName[0]
            }
            
            let avgLine = ChartLimitLine(limit: Double(e)*33.3, label: labelName)
            avgLine.lineDashPhase = 2.0
            avgLine.lineDashLengths = [2.0, 4.0]
            avgLine.lineColor = ColorExtension.lineLight
            avgLine.lineWidth = 1
            avgLine.valueTextColor = ColorExtension.textLv2
            avgLine.valueFont = UIFont.systemFont(ofSize: 12)
            avgLine.labelPosition = .leftBottom
            chartView.leftAxis.addLimitLine(avgLine)
        }
        
        return self
    }
    
    public override func build(isShowQuality: Bool = false) {
        let invalidData = 100.0
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
        set.colors = [UIColor.colorWithHexString(hexColor: "8b7af3"), UIColor.colorWithHexString(hexColor: "ffc56f")]
        set.isDrawLineWithGradientEnabled = true
        set.gradientPositions = [33, 34]
        let data = LineChartData(dataSet: set)
        chartView.data = data

    }
}
