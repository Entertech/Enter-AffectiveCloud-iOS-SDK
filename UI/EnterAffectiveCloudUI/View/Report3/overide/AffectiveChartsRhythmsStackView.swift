//
//  AffectiveChartsRhythmsStackView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/16.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts

class AffectiveCharts3RhythmsStackView: AffectiveCharts3RhythmsChart {
    var markerTitle = "Average Rhythms Percentage".uppercased()
    var style = AffectiveCharts3FormatOptional.session
    private var limit = 0
    private var startDate: Date = Date()
    var lastXValue: Double = 0
    weak var dateSouce: AffectiveCharts3ChartChanged?
    
    public func setProperty(type: AffectiveCharts3FormatOptional, startDate: Date, color: [UIColor]) {
        self.style = type
        switch type {
        case .session:
            limit = 0
            interval = 0.6
        case .month:
            limit = 31
            interval = 1
        case .year:
            limit = 12
            interval = 1
        }
        self.startDate = startDate
        guard color.count > 4 else {return}
        self.gamaColor = color[0]
        self.betaColor = color[1]
        self.alphaColor = color[2]
        self.thetaColor = color[3]
        self.deltaColor = color[4]
        initChart()
    }
    override func initChart() {
        self.backgroundColor = .clear
        self.gridBackgroundColor = .clear
        self.drawBordersEnabled = false
        self.chartDescription.enabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.legend.enabled = false
        self.dragDecelerationEnabled = false
        self.extraTopOffset = 129
        self.highlightPerTapEnabled = false
        self.highlightPerDragEnabled = false
        
        let leftAxis = self.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = true
        leftAxis.gridColor = ColorExtension.lineLight
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridLineDashPhase = 1
        leftAxis.drawGridLinesBehindDataEnabled = false
        leftAxis.gridLineDashLengths = [3, 2]
        leftAxis.axisMaximum = 100
        leftAxis.axisMinimum = 0
        leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        leftAxis.labelTextColor = ColorExtension.textLv2
        leftAxis.setLabelCount(5, force: true)
        leftAxis.valueFormatter = AffectiveCharts3PercentFormatter()
        self.rightAxis.enabled = false
        
        let xAxis = self.xAxis
        xAxis.gridLineWidth = 0.5
        xAxis.labelPosition = .bottom
        xAxis.gridColor = ColorExtension.lineLight
        xAxis.labelTextColor = ColorExtension.textLv2
        xAxis.axisLineColor = ColorExtension.lineLight
        xAxis.axisLineWidth = 0.5
        xAxis.axisMaxLabels = 8
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.drawGridLinesBehindDataEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.drawAxisLineEnabled = true
        xAxis.gridLineWidth = 0.5
        xAxis.gridLineDashPhase = 1
        xAxis.gridLineDashLengths = [3, 2]
        
        switch style {
        case .session:
            self.dragEnabled = false
            xAxis.valueFormatter = AffectiveCharts3HourValueFormatter()
        case .month:
            self.dragEnabled = true
            xAxis.valueFormatter = AffectiveCharts3DayValueFormatter(originDate: startDate)
        case .year:
            self.dragEnabled = true
            xAxis.valueFormatter = AffectiveCharts3MonthValueFormatter(originDate: startDate)
        }
        
    }
    
    override func mapDataList(array2D: Array2D<Double>?) {
        guard let waveArray = array2D else {
            return
        }
        if style == .month || style == .year {
            sample = 1
        }
        let lineEnables = (enableGama ? 1 : 0) + (enableBeta ? 2 : 0) + (enableAlpha ? 4 : 0) + (enableTheta ? 8 : 0) + (enableDelta ? 16 : 0)
        
        var waveNum = [Double].init(repeating: 0, count: waveArray.columns)
        var sets: [LineChartDataSet] = []
        for j in (0..<waveArray.rows).reversed() {
            switch j {
            case 0:
                if !enableGama {
                    continue
                } else {
                    
                }
            case 1:
                if !enableBeta {
                    continue
                } else {
                    
                }
            case 2:
                if !enableAlpha {
                    continue
                } else {
                    
                }
            case 3:
                if !enableTheta {
                    continue
                } else {
                    
                }
            case 4:
                if !enableDelta {
                    continue
                } else {
                    
                }
            default:
                break
            }
            
            var initValue = 0
            var initIndex = 0
            for i in stride(from: 0, to: waveArray.columns, by: sample) {
                if waveArray[i, j] > 0 {
                    initValue = Int(waveArray[i, j] + waveNum[i])
                    initIndex = i
                    break
                }
            }
            var minValue = 120
            var maxValue = 0
            var yVals: [ChartDataEntry] = []
            var notZero: Int = 0
            for i in stride(from: 0, to: waveArray.columns, by: sample) {
                switch j {
                case 0:
                    gamaArray?.append(waveArray[i, j])
                case 1:
                    betaArray?.append(waveArray[i, j])
                case 2:
                    alphaArray?.append(waveArray[i, j])
                case 3:
                    thetaArray?.append(waveArray[i, j])
                case 4:
                    deltaArray?.append(waveArray[i, j])
                default:
                    break
                }
                if i < initIndex{  //为0的为无效数据
                    yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(initValue)))
                } else {
                    if waveArray[i, j] == 0 {//为0的为无效数据
                        yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(notZero)))
                    } else {
                        if minValue > Int(waveArray[i, j]) {
                            minValue = Int(waveArray[i, j])
                        }
                        if maxValue < Int(waveArray[i, j]) {
                            maxValue = Int(waveArray[i, j])
                        }
                        notZero = Int(waveArray[i, j]+waveNum[i])
                      
                        yVals.append(ChartDataEntry(x: Double(i)*interval, y: Double(waveArray[i, j]+waveNum[i])))
                    }
                    
                }
                waveNum[i] += waveArray[i, j]
                
            }
            // 设置chart set
            let set = LineChartDataSet(entries: yVals, label: "")
            set.mode = .linear
            set.drawFilledEnabled = true
            set.fillAlpha = 1
            set.drawCirclesEnabled = false
            set.drawCircleHoleEnabled = false
            set.lineWidth = 1.5
            switch j {
            case 0:
                if enableGama {
                    set.setColor(gamaColor)
                    set.fillColor = gamaColor
                } else {
                    set.setColor(.clear)
                }
                
            case 1:
                if enableBeta {
                    
                    set.setColor(betaColor)
                    set.fillColor = betaColor
                } else {
                    set.setColor(.clear)
                }
            case 2:
                if enableAlpha {
                    set.setColor(alphaColor)
                    set.fillColor = alphaColor
                } else {
                    set.setColor(.clear)
                }
            case 3:
                if enableTheta {
                    
                    set.setColor(thetaColor)
                    set.fillColor = thetaColor
                } else {
                    set.setColor(.clear)
                }
            case 4:
                if enableDelta {
                    
                    set.setColor(deltaColor)
                    set.fillColor = deltaColor
                } else {
                    set.setColor(.clear)
                }
            default:
                set.setColor(gamaColor)
            }
            set.drawIconsEnabled = true
            set.highlightEnabled = true
            set.highlightLineWidth = 2
            set.highlightColor = ColorExtension.lineLight
            set.drawHorizontalHighlightIndicatorEnabled = false
            set.drawValuesEnabled = false
            sets.append(set)
        }
        let data = LineChartData(dataSets: sets.reversed())
        self.data = data
        var ref: [Double] = []
        if let value = betaArray {
            ref.append(contentsOf: value)
        } else if let value = thetaArray {
            ref.append(contentsOf: value)
        } else if let value = alphaArray {
            ref.append(contentsOf: value)
        } else if let value = gamaArray {
            ref.append(contentsOf: value)
        } else if let value = deltaArray {
            ref.append(contentsOf: value)
        }
        let lineColor = [gamaColor, betaColor, alphaColor, thetaColor, deltaColor]
        switch style {
        case .session:
            let markerView = AffectiveCharts3RhythmsMarker(title: markerTitle, enableLines: lineEnables, with: lineColor)
                .setTime(start: startDate.timeIntervalSince1970, format: style.format)
                .setRef(value: ref)
                .setProperty(sample: sample, interval: interval, usePercent: true)
            
            self.marker = markerView
            markerView.chartView = self
        case .month:
            let markerView = AffectiveCharts3RhythmsMarker(title: markerTitle, enableLines: lineEnables, with: lineColor)
                .setMonth(month: startDate, format: style.format)
                .setRef(value: ref)
                .setProperty(sample: sample, interval: interval, usePercent: true)
            
            self.marker = markerView
            markerView.chartView = self
            self.setVisibleXRangeMaximum(31)
        case .year:
            let markerView = AffectiveCharts3RhythmsMarker(title: markerTitle, enableLines: lineEnables, with: lineColor)
                .setYear(year: startDate, format: style.format)
                .setRef(value: ref)
                .setProperty(sample: sample, interval: interval, usePercent: true)
            
            self.marker = markerView
            markerView.chartView = self
            self.setVisibleXRangeMaximum(12)
        }
        if data.dataSetCount > 0 {
            let entryCount = data.dataSets[0].entryCount
            if entryCount > 0 {
                if let lastData = data.dataSets[0].entryForIndex(entryCount-1)?.x {
                    self.moveViewToX(lastData)
                    self.lastXValue = lastData
                }
            }
        }
        
        

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            let time = self.calculatAverageTime()
            let ave = self.calculatAverage()
            self.dateSouce?.update(single: nil, mult: ave, from: time.0, to: time.1)
        }

    }
    
    internal func calculatAverageTime() -> (Double, Double) {
        let left = round(self.lowestVisibleX)
        let right = round(self.highestVisibleX)
        switch style {
        case .session:
            let fromTime = self.startDate.timeIntervalSince1970 + left
            let toTime = self.startDate.timeIntervalSince1970 + right
            return (fromTime, toTime)
        case .month:
            guard let fromTime = self.startDate.getDayAfter(days: Int(left))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            guard let toTime = self.startDate.getDayAfter(days: Int(right))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            return (fromTime, toTime)
        case .year:
            guard let fromTime = self.startDate.getMonthAfter(month: Int(left))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            guard let toTime = self.startDate.getMonthAfter(month: Int(right))?.timeIntervalSince1970 else {
                return (0.0, 0.0)}
            return (fromTime, toTime)
        }

    }
    
    internal func calculatAverage() -> (Int, Int, Int, Int, Int) {
        guard let gamma = gamaArray ,
                let beta = betaArray,
              let alpha = alphaArray,
              let theta = thetaArray,
              let delta = deltaArray
        else {
            return (0, 0, 0, 0, 0)
        }
        let left = self.lowestVisibleX < 0 ? 0 : round(self.lowestVisibleX)
        let right = round(self.highestVisibleX) + 1
        
        let leftIndex = Int(round(left / interval)) < 0 ? 0 : Int(round(left / interval))
        var count = Int(round((right-left) / interval) / Double(sample))
        
        var listCount = leftIndex+count
        
        if listCount > gamma.count {
            count = gamma.count - leftIndex
            listCount = gamma.count
        }
        if listCount <= gamma.count {
            var gammaSum = 0.0
            var betaSum = 0.0
            var alphaSum = 0.0
            var thetaSum = 0.0
            var deltaSum = 0.0
            var validCount = 0
            for i in leftIndex..<listCount {
                if alpha[i] > 0 {
                    validCount += 1
                }
                gammaSum += gamma[i]
                betaSum += beta[i]
                alphaSum += alpha[i]
                thetaSum += theta[i]
                deltaSum += delta[i]
            }
            if validCount == 0 {
                return(0, 0, 0, 0, 0)
            } else {
                let gammaEve = Int(round(gammaSum / Double(validCount)))
                let betaEve = Int(round(betaSum / Double(validCount)))
                let alphaEve = Int(round(alphaSum / Double(validCount)))
                let thetaEve = Int(round(thetaSum / Double(validCount)))
                let deltaEve = 100 - gammaEve - betaEve - alphaEve - thetaEve
                return (gammaEve, betaEve, alphaEve, thetaEve, deltaEve)
            }

        } else {
            return (0, 0, 0, 0, 0)
        }
    }
}
