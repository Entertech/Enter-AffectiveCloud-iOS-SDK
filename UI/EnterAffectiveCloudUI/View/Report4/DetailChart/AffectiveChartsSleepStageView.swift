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
    internal var interval: Double = 6
    internal var dataSorce: [Double] = []
    internal var qualityList: [Int] = []
    private var originSource: [Int] = []
    private let limitSize:Double = 301
    private var awakeImage: UIImage?
    private var remImage: UIImage?
    private var lightImage: UIImage?
    private var deepImage: UIImage?
    private var n1Image: UIImage?
    private var arrayMapper: ArrayMapper!
    /// 设置数据
    /// - Parameter array: 数据
    /// - Returns: self
    public func setData(_ array: [Int], _ quality: [Int], param: AffectiveChartsSleepParameter) -> Self {
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
        

        
        self.qualityList.removeAll()
        self.qualityList.append(contentsOf: quality)
        originSource.append(contentsOf: tmpArray)
        dataSorce.removeAll()
        
        let stride: Int = 1
        let totalTime = Double(6 * array.count)
        interval = totalTime / Double(needCount)
        tmpArray.forEach { value in
            if value == 0 {
                dataSorce.append(contentsOf:Array(repeating: 9, count: stride))
                //                    dataSorce.append(7) //清醒
            } else if value == 4 {
                dataSorce.append(contentsOf:Array(repeating: 7, count: stride))
                //                    dataSorce.append(5) //rem
            } else if value == 2 {
                dataSorce.append(contentsOf:Array(repeating: 3, count: stride))
                //                    dataSorce.append(3) //浅睡
            } else if value == 3 {
                dataSorce.append(contentsOf:Array(repeating: 1, count: stride))
                //                    dataSorce.append(1) //深睡
            } else if value == 1 {
                dataSorce.append(contentsOf:Array(repeating: 5, count: stride))
            }
            
        }
        chartView.chartParam = param
        if dataSorce.count > 0 {
            chartView.maxVisibleCount = Int(limitSize+1)
            chartView.leftAxis.axisMinimum = 0
            chartView.leftAxis.axisMaximum = 10
            
            chartView.leftAxis.drawTopYLabelEntryEnabled = true
            chartView.leftAxis.drawBottomYLabelEntryEnabled = false
            chartView.leftAxis.valueFormatter = AffectiveChartsSleepStageYFormatter(lan: param.text)
        }
        arrayMapper = ArrayMapper(aLength: dataSorce.count, bLength: quality.count)
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
        guard let colors = chartView.chartParam?.lineColors else {return}
        guard dataSorce.count > 0 else {return}
        let screenWidth = UIScreen.main.bounds.width > 500 ? 500 : UIScreen.main.bounds.width
        let iconWidth = screenWidth / CGFloat(limitSize-64)
        chartView.yRender.entries = [0, 2, 4, 6, 8, 10]
        awakeImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[0])
        remImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[1])
        lightImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[3])
        deepImage = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[4])
        n1Image = createRoundRectangleImage(size: CGSize(width: iconWidth, height: 16), cornerRadius: 1, backgroundColor: colors[2])
        
        
        var yVals: [ChartDataEntry] = []
        
        for i in stride(from: 0, to: dataSorce.count, by: 1) {
            
            let value = dataSorce[i]
            let index = Double(i)*interval+(chartView.chartParam?.start ?? 0)+interval
            if qualityList[arrayMapper.mapIndex(i)] == 1 {
                
                if value == 9 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: awakeImage))
                } else if value == 7 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: remImage))
                } else if value == 5 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: n1Image))
                } else if value == 3 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: lightImage))
                } else if value == 1 {
                    yVals.append(ChartDataEntry(x: index, y: Double(dataSorce[i]), icon: deepImage))
                }
                
            } else {
                yVals.append(ChartDataEntry(x: index, y: 9, icon: nil))
            }
                
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
          
            set.setColors([colors[3], colors[2], colors[1], colors[0]], alpha: 0.5)
            set.isDrawLineWithGradientEnabled = true
            set.gradientPositions = [1, 3, 6, 9]
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
    struct ArrayMapper {
        let aLength: Int
        let bLength: Int
        let ratio: Double

        init(aLength: Int, bLength: Int) {
            self.aLength = aLength
            self.bLength = bLength
            self.ratio = Double(bLength) / Double(aLength)
        }

        func mapIndex(_ index: Int) -> Int {
            let mappedIndex = Int(Double(index) * ratio)
            return min(mappedIndex, bLength - 1)
        }
    }
}


public class AffectiveChartsSleepStageYFormatter: NSObject, AxisValueFormatter {
    var language = ["Awake", "REM", "N1", "N2", "N3"]
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




public class AffectiveChartsSleepStageHourValueFormatter: NSObject, AxisValueFormatter {
    private var startInterval: Double!
    private var endInterval: Double!
    private var values: [Double] = []
    private let minStride: Int = 300
    private var stdValue: Double = 0
    init(start: Double, end: Double) {
        self.startInterval = start
        self.endInterval = end
        let fromToValue = end - start
        var strideValue: Int = minStride
        if fromToValue < 1800  {
            strideValue = minStride
            lk_formatter.dateFormat = "HH:mm"
        } else if fromToValue < 7200  {
            strideValue = minStride * 6
            lk_formatter.dateFormat = "HH:mm"
        } else if fromToValue < 18000 {
            strideValue = minStride * 12
            lk_formatter.dateFormat = "HH:mm"
        } else if fromToValue < 36000{
            strideValue = minStride * 24
            lk_formatter.dateFormat = "HH"
        } else {
            strideValue = minStride * 48
            lk_formatter.dateFormat = "HH"
        }
    
        if strideValue <= minStride {
            
        } else {
            let startRemain = Int(start) % strideValue
            let endRemain = Int(end) % strideValue
            let from = Int(start) + strideValue - startRemain
            let to = Int(end) - endRemain
            for t in stride(from: from, through: to, by: strideValue) {
                values.append(Double(t))
            }

            stdValue = Double(Int(start) % minStride > 150 ? Int(start) + (minStride - Int(start) % minStride) : Int(start) - Int(start) % minStride)
            values = values.map({
                round(($0-start))
            })
        }
        print(stdValue)
        print(values)
        
        
        
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if values.count > 0 {
            axis?.entries = values
        
            var time = 0
            time = Int(value+stdValue)
            let date = lk_formatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
            return date
        } else {
            var time = 0
            time = Int(value+startInterval)
            let date = lk_formatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
            return date
        }

    }
}
