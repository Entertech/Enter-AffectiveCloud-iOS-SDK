//
//  AffectiveChartsSleepStageView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/12/13.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import DGCharts
import SnapKit

public class AffectiveChartsSleepStageView: UIView {
    
    internal let chartView = AffectiveChartsSleepDetailCommonView()
    internal var interval: Double = 1
    internal var dataSorce: [Double] = []
    private var originSource: [Int] = []
    private let limitSize:Double = 301
    private var awakeImage: UIImage?
    private var remImage: UIImage?
    private var lightImage: UIImage?
    private var deepImage: UIImage?

    /// 设置数据
    /// - Parameter array: 数据
    /// - Returns: self
    public func setData(_ array: [Int], param: AffectiveChartsSleepParameter) -> Self {
        guard array.count > 0 else {return self}
        originSource.append(contentsOf: array)
        dataSorce.removeAll()
        // array如果数量小于500, 将array以array.count:500映射到dataSorce
        let percent = Double(array.count) / limitSize
        var stride: Int = 1
        if percent < 1 {
            stride = Int(ceil((limitSize-1) / Double(array.count-1)))
            interval = (param.end-param.start-300)/300/(limitSize-1)
        }
        array.forEach { value in
            

            if value == 0 || value == 1 {
                dataSorce.append(contentsOf:Array(repeating: 7, count: stride))
                //                    dataSorce.append(7) //清醒
            } else if value == 4 {
                dataSorce.append(contentsOf:Array(repeating: 5, count: stride))
                //                    dataSorce.append(5) //rem
            } else if value == 2 {
                dataSorce.append(contentsOf:Array(repeating: 3, count: stride))
                //                    dataSorce.append(3) //浅睡
            } else if value == 3 {
                dataSorce.append(contentsOf:Array(repeating: 1, count: stride))
                //                    dataSorce.append(1) //深睡
            }
            
        }
        chartView.resizeArray(array: &dataSorce, toSize: Int(limitSize))
        chartView.maxVisibleCount = 302
        chartView.chartParam = param
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = 8
        
        chartView.leftAxis.drawTopYLabelEntryEnabled = true
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        chartView.leftAxis.valueFormatter = AffectiveChartsSleepStageYFormatter(lan: param.text)

        return self
    }
    
    
    
    /// layout
    /// - Returns: self
    public func stepTwoSetLayout() -> Self {
        self.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        chartView.yRender.entries = [0, 2, 4, 6, 8]
        return self
    }
    

    
    public func build() {
        guard let colors = chartView.chartParam?.lineColors else {return}
        let screenWidth = UIScreen.main.bounds.width > 500 ? 500 : UIScreen.main.bounds.width
        let iconWidth = screenWidth / CGFloat(limitSize-64)

        awakeImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[0])
        remImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[1])
        lightImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[2])
        deepImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[3])
        
        
        var yVals: [ChartDataEntry] = []
        var lastValue: Double = 0
        for i in stride(from: 0, to: dataSorce.count, by: 1) {
            let value = dataSorce[i]
            let index = Double(i)*interval
            if lastValue != value {

                yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: nil))
                
            } else {
                if value == 7 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: awakeImage))
                } else if value == 5 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: remImage))
                } else if value == 3 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: lightImage))
                } else if value == 1 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: deepImage))
                }
            }

            lastValue = value
        }
        let set = LineChartDataSet(entries: yVals, label: "")
//        let strongSet = LineChartDataSet(entries: yVals, label: "")
        if colors.count >= 4 {
            set.mode = .stepped
            set.drawCirclesEnabled = false
            set.drawCircleHoleEnabled = false
            set.drawFilledEnabled = false
            set.lineCapType = .round
            set.lineWidth = 1
          
            set.setColors([colors[0], colors[0], colors[1], colors[2], colors[3]], alpha: 0.5)
            set.isDrawLineWithGradientEnabled = true
            set.gradientPositions = [6, 5, 2, 1]
            set.drawIconsEnabled = true
            set.highlightEnabled = false
            set.drawValuesEnabled = false
        }
        if originSource.count < 24 {
            if originSource.count % 5 == 0 {
                chartView.xAxis.setLabelCount(5, force: true)
            } else if originSource.count % 4 == 0 {
                chartView.xAxis.setLabelCount(4, force: true)
            } else if originSource.count % 3 == 0 {
                chartView.xAxis.setLabelCount(3, force: true)
            }
        }
        let data = LineChartData(dataSets: [set])
        
        chartView.data = data
    }
    
    func createRoundRectangleImage(size: CGSize, cornerRadius: CGFloat, backgroundColor: UIColor = .white) -> UIImage? {
        // Begin a new image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        // Set the fill color
        backgroundColor.setFill()
        // Create a path with rounded corners
        let rect = CGRect(origin: .zero, size: size)
        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        // Fill the path with the color
        context.addPath(bezierPath.cgPath)
        context.fillPath()
        // Get the image from the current context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // End the image context
        UIGraphicsEndImageContext()
        return image
    }
    
}


public class AffectiveChartsSleepStageYFormatter: NSObject, AxisValueFormatter {
    var language = ["Awake", "REM", "Light", "Deep"]
    init(lan: [String]) {
        super.init()
        self.language = lan
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        var retValue = ""
        if value == 8 {
            retValue = language[0]
        } else if value == 6 {
            retValue = language[1]
        } else if value == 4 {
            retValue = language[2]
        } else if value == 2 {
            retValue = language[3]
        }
        return retValue
    }
}




