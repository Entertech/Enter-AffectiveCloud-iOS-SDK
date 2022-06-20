//
//  AffectiveChartsHeaderView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/14.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit

protocol AffectiveCharts3ExpandDelegate: AnyObject {
    func expand(flag: Bool)
}

class AffectiveCharts3ExpandHeaderView: UIView {
    private let infoView = AffectiveCharts3HeaderInfoView()
    private let expandBtn = UIButton()
    private var isNotShowExpand = true
    private var theme: AffectiveChart3Theme!
    weak var delegate: AffectiveCharts3ExpandDelegate?
    func setTheme(_ theme: AffectiveChart3Theme) -> Self {
        self.theme = theme
        var title = ""
        switch self.theme.style {
        case .session:
            title = theme.chartType.session
        case .month:
            title = theme.chartType.month
        case .year:
            title = theme.chartType.year
            
        }
        infoView.setLabelColor(color: ColorExtension.textLv2)
            .setAverageLabel(value: title)
            .setAverageNumLabel(value: theme.averageValue, color: theme.themeColor)
            .setUnit(theme.unitText)
            .setTime(from: theme.startTime, to: theme.endTime, startFormatter: theme.style.fromFormat, endFormatter: theme.style.toFormat)
            .setTag(theme.tagValue, fontColor: theme.tagTextColor, bgColor: theme.tagColor)
            .build()
        return self
    }
    
    func build(isAlreadShow: Bool) {
        isNotShowExpand = !isAlreadShow
        self.backgroundColor = .clear
        self.addSubview(infoView)
        self.addSubview(expandBtn)
        infoView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(58)
        }
        expandBtn.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalToSuperview().offset(16)
        }
        if isNotShowExpand {
            expandBtn.setImage(UIImage.loadImage(name: "expand", any: classForCoder), for: .normal)
        } else {
            
            expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
        }
        expandBtn.addTarget(self, action: #selector(expandAction(_:)), for: .touchUpInside)
    }
    
    @objc func expandAction(_ sender: UIButton) {
        delegate?.expand(flag: isNotShowExpand)
        isNotShowExpand = !isNotShowExpand
        if isNotShowExpand {
            expandBtn.setImage(UIImage.loadImage(name: "expand", any: classForCoder), for: .normal)
        } else {
            
            expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
        }
    }
    
}

extension AffectiveCharts3ExpandHeaderView: AffectiveCharts3ChartChanged {
    func update(single: Int?, mult: (Int, Int, Int, Int, Int)?, from: Double, to: Double) {
        guard let single = single else {return}
        _ = self.infoView.setAverageNumLabel(value: "\(single)", color: theme.themeColor)
            .setTime(from: from, to: to, startFormatter: theme.style.fromFormat, endFormatter: theme.style.toFormat)
    }
    
    
}


class AffectiveCharts3HeaderInfoView: UIView {
    private let averageLabel = UILabel()
    public let averageNumLabel = UILabel()
    private let unitLabel = UILabel()
    private let timeLabel = UILabel()
    private let tagLabel = UILabel()
    private var labelColor: UIColor = .label
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelColor(color: UIColor) -> Self {
        labelColor = color
        return self
    }
    
    func setAverageLabel(value: String) -> Self {
        averageLabel.text = value
        averageLabel.textColor = labelColor
        averageLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return self
    }
    
    func setAverageNumLabel(value: String, color: UIColor) -> Self {
        averageNumLabel.text = value
        averageNumLabel.textColor = color
        averageNumLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        return self
    }
    
    
    func setTime(from: TimeInterval, to: TimeInterval, startFormatter: String, endFormatter: String) -> Self {
        let dateFrom = Date.init(timeIntervalSince1970: round(from))
        let dateTo = Date.init(timeIntervalSince1970: round(to))
        
        if Calendar.current.component(.day, from: dateFrom) == 1 {
            lk_formatter.dateFormat = "MMM yyyy"
            let time = lk_formatter.string(from: dateFrom)
            timeLabel.text = time
            timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            timeLabel.textColor = labelColor

        } else {
            lk_formatter.dateFormat = startFormatter
            timeLabel.text = lk_formatter.string(from: dateFrom)
            lk_formatter.dateFormat = endFormatter
            timeLabel.text = "\(timeLabel.text ?? "")\(lk_formatter.string(from: dateTo))"
            timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            timeLabel.textColor = labelColor
        }
        return self
    }
    
    func setTime(value: TimeInterval, formatter: String) -> Self {
        let dateFrom = Date.init(timeIntervalSince1970: round(value))
        lk_formatter.dateFormat = formatter
        timeLabel.text = lk_formatter.string(from: dateFrom)
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = labelColor
        return self
    }
    
    func setUnit(_ unit: String?) -> Self{
        unitLabel.text = unit
        unitLabel.textColor = labelColor
        unitLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        return self
    }
    
    func setTag(_ tag: String?, fontColor: UIColor, bgColor: UIColor) -> Self{
        tagLabel.text = tag
        tagLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        tagLabel.textColor = fontColor
        tagLabel.backgroundColor = bgColor
        tagLabel.textAlignment = .center
        
    
        return self
    }
    
    func build() {
        self.backgroundColor = .clear
        self.addSubview(averageLabel)
        self.addSubview(averageNumLabel)
        self.addSubview(unitLabel)
        self.addSubview(timeLabel)
        self.addSubview(tagLabel)
        
        averageLabel.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.leading.top.equalToSuperview()
        }
        averageNumLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.leading.equalToSuperview()
            $0.top.equalTo(averageLabel.snp.bottom)
        }
        unitLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.bottom.equalTo(averageNumLabel.snp.bottom)
            $0.leading.equalTo(averageNumLabel.snp.trailing).offset(2)

        }
        if let text = unitLabel.text, text.count > 0 {
            
        } else {
            unitLabel.isHidden = true
        }
        tagLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.width.equalTo(48)
            $0.bottom.equalTo(averageNumLabel.snp.bottom)
            $0.leading.equalTo(averageNumLabel.snp.trailing).offset(4)
        }
        tagLabel.layer.cornerRadius = 9
        tagLabel.layer.masksToBounds = true
        if let text = tagLabel.text, text.count > 0 {
            
        } else {
            tagLabel.isHidden = true
        }
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.equalTo(14)
            $0.top.equalTo(averageNumLabel.snp.bottom).offset(2)
        }
    }
    
    func update(value: Int) {
        averageNumLabel.text = "\(value)"
    }
    
    func update(tag: String) {
        tagLabel.text = tag
    }
    
    func update(date: String?) {
        timeLabel.text = date
    }
}
