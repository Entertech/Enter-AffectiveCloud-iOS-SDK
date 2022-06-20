//
//  AffectiveCharts3CommonMarker.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class AffectiveCharts3CommonMarkerView: MarkerView {

    private let formatter = DateFormatter()
    public let titleLabel: UILabel = UILabel()
    public let numlabel: UILabel = UILabel()
    public let unitLabel: UILabel = UILabel()
    public let timeLabel: UILabel = UILabel()
    public let tagLabel: UILabel = UILabel()
    public let lineView = UIView()
    public let labelBg = UIView()
    private let titleFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    private let numberFont = UIFont.systemFont(ofSize: 28, weight: .semibold)
    private let unitFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    private let tagFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    private let timeFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    private let lableViewHeight: CGFloat = 66
    private var theme: AffectiveChart3Theme!
    private var anotherArray: [Int] = []
    init(theme: AffectiveChart3Theme) {
        super.init(frame: CGRect.zero)
        self.theme = theme
        setUI()
    }
    
    
    
    func addInterval(anotherArray: [Int]) {
        self.anotherArray.append(contentsOf: anotherArray)
    }
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.addSubview(labelBg)
        self.addSubview(lineView)
        labelBg.addSubview(titleLabel)
        labelBg.addSubview(numlabel)
        labelBg.addSubview(unitLabel)
        labelBg.addSubview(timeLabel)
        labelBg.addSubview(tagLabel)
        
        labelBg.layer.cornerRadius = 8
        labelBg.backgroundColor = ColorExtension.bgZ2
        labelBg.frame = CGRect(x: 0, y: 0, width: 0, height: lableViewHeight)
        
        titleLabel.frame = CGRect(x: 8, y: 4, width: 56, height: 14)
        titleLabel.textAlignment = .left
        titleLabel.font = titleFont
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = ColorExtension.textLv2
        
        if theme.style == .month {
            titleLabel.text = "Daily Average".uppercased()
        } else if theme.style == .year {
            titleLabel.text = "Monthly Average".uppercased()
        } else {
            titleLabel.text = theme.chartName.uppercased()
        }
        
        numlabel.frame = CGRect(x: 8, y: 18, width: 0, height: 28)
        numlabel.textAlignment = .left
        numlabel.font = numberFont
        numlabel.textColor = theme.themeColor
        
        unitLabel.frame = CGRect(x: 10, y: 27, width: 0, height: 21)
        unitLabel.font = unitFont
        unitLabel.textColor = ColorExtension.textLv2
        unitLabel.text = theme.unitText
        unitLabel.isHidden = true
        
        tagLabel.frame = CGRect(x: 10, y:28, width: 45, height: 18)
        tagLabel.font = tagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = theme.tagColor
        tagLabel.textColor = theme.tagTextColor
        tagLabel.layer.cornerRadius = 9
        tagLabel.layer.masksToBounds = true
        tagLabel.isHidden = true
        
        timeLabel.frame = CGRect(x: 8, y: 49, width: 0, height: 14)
        timeLabel.font = timeFont
        timeLabel.textColor = ColorExtension.textLv2
        

        lineView.backgroundColor = ColorExtension.lineLight
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
        let entryY = Int(entry.y)
        if theme.tagValue.count > 0 || theme.unitText.count > 0 {
            if let dataSets = chartView?.data?.dataSets, dataSets.count > 1 {
                var index = dataSets[0].entryIndex(entry: entry)
                if index == -1 {
                     index = dataSets[1].entryIndex(entry: entry)
                }
                numlabel.text = "\(Int(round(dataSets[0].entryForIndex(index)?.y ?? 0)))"
            } else {
                numlabel.text = String.init(format: "%d", entryY)
            }
            
        } else {
            if anotherArray.count > 0 {
                var index = 0
                if let dataSets = chartView?.data?.dataSets {
                    index = dataSets.first?.entryIndex(entry: entry) ?? 0
                }
                if anotherArray[index] > 0 {
                    numlabel.text = "Coherent"
                } else {
                    numlabel.text = "Incoherent"
                }
            } else {
                if entryY > 75 {
                    numlabel.text = AffectiveCharts3CohereceState.high.rawValue
                } else if entryY > 50 {
                    numlabel.text = AffectiveCharts3CohereceState.ele.rawValue
                } else if entryY > 25 {
                    numlabel.text = AffectiveCharts3CohereceState.nor.rawValue
                } else {
                    numlabel.text = AffectiveCharts3CohereceState.low.rawValue
                }
            }

        }


        lk_formatter.dateFormat = theme.style.format
        switch theme.style {
        case .session:
            timeLabel.text = lk_formatter.string(from: Date(timeIntervalSince1970: TimeInterval(entry.x)+theme.startTime))
        case .month:
            if let date = theme.startDate.getDayAfter(days: Int(round(entry.x))) {
                timeLabel.text = lk_formatter.string(from: date)
            }
            
        case .year:
            if let date = theme.startDate.getMonthAfter(month: Int(round(entry.x))) {
                timeLabel.text = lk_formatter.string(from: date)
            }
            
        }
        
        let titleWidht = titleLabel.text?.width(withConstrainedHeight: 14, font: titleFont)
        let numWidth = numlabel.text?.width(withConstrainedHeight: 28, font: numberFont)
        let timeWidth = timeLabel.text?.width(withConstrainedHeight: 17, font: timeFont)
        let unitWidth = unitLabel.text?.width(withConstrainedHeight: 20, font: unitFont)
        if let numWidth = numWidth, let unitWidth = unitWidth, let timeWidth = timeWidth, let titleWidht = titleWidht {
            titleLabel.frame.size.width = titleWidht
            timeLabel.frame.size.width = timeWidth
            numlabel.frame.size.width = numWidth
            if theme.tagValue.count > 0 {
                var tag = ""
                if entryY < theme.tagSeparation[1] {
                    tag = PrivateReportState.low.rawValue
                } else if entryY > theme.tagSeparation[2] {
                    tag = PrivateReportState.high.rawValue
                } else {
                    tag = PrivateReportState.nor.rawValue
                }
                tagLabel.text = tag
                tagLabel.frame = CGRect(x: 8+numWidth+4, y: 28, width: 45, height: 18)
                tagLabel.isHidden = false
            }
            
            if theme.unitText.count > 0{
                unitLabel.frame = CGRect(x: 8+numWidth+2, y: 27, width: unitWidth, height: 21)
                unitLabel.isHidden = false

            }
            let maxWidth = timeWidth > titleWidht ? timeWidth : titleWidht
            if numWidth+unitWidth+2 > maxWidth {
                labelBg.frame.size.width = numWidth+unitWidth+18
            } else {
                labelBg.frame.size.width = maxWidth+16
            }
            
            
        }
        layoutIfNeeded()
        
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        guard let chart = chartView else { return self.offset }
        self.bounds = CGRect(x: 0, y: 0, width: labelBg.bounds.size.width, height: point.y-2)
        
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

        self.lineView.frame = CGRect(x: -offset.x, y: lableViewHeight, width: 1.0, height: point.y-4-lableViewHeight)
        offset.y = -point.y + 12
        
        return offset
    }

}
