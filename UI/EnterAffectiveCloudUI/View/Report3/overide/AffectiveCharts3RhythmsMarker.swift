//
//  AffectiveCharts3RhythmsMarker.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/16.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import Charts
import CoreGraphics

class AffectiveCharts3RhythmsMarker: MarkerView {
    private let contentView = UIView()
    private let infoView = AffectiveCharts3RhythmsInfoView()
    private let lineView = UIView()
    private var sample: Int = 1
    private var interval: Double = 0.6
    private var usePercent: Bool = false
    private let lableViewHeight: CGFloat = 57
    private var startTimeStamp: Double = 0
    private var timeFormat: String = ""
    private var currentWidht:CGFloat = 0 //动态宽
    private var enableLines = 0
    private var isMonth = false
    private var monthStart: Date!
    private var isYear = false
    private var yearStart: Date!
    private var title: String = ""
    private var ref: [Double] = []
    
    init(title: String, enableLines: Int, with: [UIColor]) {
        super.init(frame: CGRect.zero)
        self.enableLines = enableLines
        self.title = title
        guard with.count > 4 else {return}
        infoView.gammaColor = with[0]
        infoView.betaColor = with[1]
        infoView.alphaColor = with[2]
        infoView.thetaColor = with[3]
        infoView.deltaColor = with[4]
        setUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    func setMonth(month: Date,format: String) -> Self {
        isMonth = true
        monthStart = month
        timeFormat = format
        return self
    }
    
    func setYear(year: Date,format: String) -> Self {
        isYear = true
        yearStart = year
        timeFormat = format
        return self
    }
    
    func setRef(value: [Double]) -> Self{
        ref.append(contentsOf: value)
        return self
    }
    
    /// 设置参数
    /// - Parameters:
    ///   - sample: 采样率
    ///   - interval: 间隔时间
    ///   - usePercent: 是否用百分号表示
    func setProperty(sample: Int, interval: Double, usePercent: Bool ) -> Self {
        self.sample = sample
        self.interval = interval
        self.usePercent = usePercent
        
        return self
    }
    
    func setTime(start: Double, format: String) -> Self {
        self.startTimeStamp = start
        self.timeFormat = format
        return self
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.addSubview(contentView)
        contentView.addSubview(infoView)
        self.addSubview(lineView)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = ColorExtension.bgZ2
        contentView.frame = CGRect(x: 0, y: 0, width: 0, height: lableViewHeight)
        
        _ = infoView.setUI(title: self.title).setLayout()
        infoView.frame = CGRect(x: 0, y: 0, width: 0, height: lableViewHeight)
        
        lineView.backgroundColor = ColorExtension.lineLight
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        guard let chartData = chartView?.data else {return}
        var index = chartView?.data?.dataSets[0].entryIndex(entry: entry)
        if index == -1 || index == nil {
             index = chartView?.data?.dataSets[1].entryIndex(entry: entry)
        }
        if index == -1 || index == nil {
             index = chartView?.data?.dataSets[2].entryIndex(entry: entry)
        }
        if index == -1 || index == nil {
             index = chartView?.data?.dataSets[3].entryIndex(entry: entry)
        }
        if index == -1 || index == nil {
             index = chartView?.data?.dataSets[4].entryIndex(entry: entry)
        }
        if let index = index, index != -1 {
            var percentArray: [Int] = [-1, -1, -1, -1, -1]
            for i in 0..<5 {
                if self.enableLines >> i & 1 == 1 {
                    percentArray[i] = 0
                }
            }
            if ref[index] < 1.0 {
                
            } else {
                var current = 0
                for i in (0..<chartData.dataSets.count).reversed() {
                    let value = Int(lround(chartView!.data!.dataSets[i].entryForIndex(index)!.y)) - current
                    for j in (0..<5).reversed() {
                        if percentArray[j] == 0 {
                            percentArray[j] = value
                            break
                        }
                    }
                    current += value
                    
                }
            }


            var time = ""
            if isMonth {
                let current = monthStart.getDayAfter(days: Int(entry.x)) ?? Date()
                lk_formatter.dateFormat = self.timeFormat
                time = lk_formatter.string(from: current)
            } else if isYear {
                let current = yearStart.getMonthAfter(month: Int(entry.x)) ?? Date()
                lk_formatter.dateFormat = self.timeFormat
                time = lk_formatter.string(from: current)
            } else {
                let timeStamp = entry.x + startTimeStamp
                let date = Date.init(timeIntervalSince1970: timeStamp)
                lk_formatter.dateFormat = self.timeFormat
                time = lk_formatter.string(from: date)
            }

            currentWidht = infoView.setRhythms(gamma: percentArray[0], beta: percentArray[1], alpha: percentArray[2], theta: percentArray[3], delta: percentArray[4], time: time)
        }
        
        
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        guard let chart = chartView else { return self.offset }
        self.bounds = CGRect(x: 0, y: 0, width: currentWidht, height: point.y-2)
        self.contentView.frame.size.width = currentWidht
        var offset = self.offset
        
        let width = self.bounds.size.width
        
        offset.x = offset.x - width/2
        
        if point.x + offset.x < 0.0
        {
            offset.x = -point.x
        }
        else if point.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - point.x - width
        }

        self.lineView.frame = CGRect(x: -offset.x-0.5, y: lableViewHeight, width: 2.0, height: point.y-4-lableViewHeight)
        offset.y = -point.y + 52
        
        return offset
    }
}
