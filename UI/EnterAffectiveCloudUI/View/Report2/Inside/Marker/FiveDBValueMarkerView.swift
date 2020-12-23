//
//  FileValueMarkerView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/4/29.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts
/// 分贝数据
class FiveDBValueMarkerView: MarkerView {

    public var titleLabelArray: [UILabel] = []
    public var labelArray: [UILabel] = []
    public var dotArray: [UIView] = []
    public var lineArray: [UIView] = []
    public var valueCount = 0
    public var lineColor: UIColor? {
        willSet {
            lineLayer.strokeColor = newValue!.cgColor
            lineLayer.fillColor = newValue!.cgColor
        }
    }
    private let lineLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //setUI()
    }
    
    public func setUI() {
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemGray5
        } else {
            // Fallback on earlier versions
            self.backgroundColor = .systemGray
        }
        let stackView = UIStackView(frame: self.bounds)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        for _ in 0..<valueCount {
            let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 48, height: 47))
            let titleLabel = UILabel(frame: CGRect.init(x: 26, y: 4, width: 10, height: 14))
            let label = UILabel(frame: CGRect.init(x: 2, y: 23, width: 45, height: 16))
            let dot = UILabel(frame: CGRect.init(x: 12, y: 8, width: 8, height: 8))
            
            dot.layer.cornerRadius = 4
            dot.layer.masksToBounds = true
            dot.backgroundColor = .red
            
            titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            titleLabel.textAlignment = .center
            
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textAlignment = .center
            
            bgView.addSubview(titleLabel)
            bgView.addSubview(label)
            bgView.addSubview(dot)
            stackView.addArrangedSubview(bgView)
            titleLabelArray.append(titleLabel)
            labelArray.append(label)
            dotArray.append(dot)
            
            
//            let lineView = UIView(frame: CGRect.init(x: 0, y: 0, width: 2, height: 32))
//            if #available(iOS 13.0, *) {
//                lineView.backgroundColor = .systemGray3
//            } else {
//                lineView.backgroundColor = .gray
//            }
//            lineView.layer.cornerRadius = 0.5
//            lineView.layer.masksToBounds = true
//            stackView.addSubview(lineView)
        }
        self.addSubview(stackView)

        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        let path = UIBezierPath(roundedRect: CGRect(x: frame.width/2-1, y: frame.height, width: 2, height: 4), cornerRadius: 1)
        
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.gray.cgColor
        lineLayer.fillColor = UIColor.gray.cgColor
        self.offset.x = -frame.size.width / 2.0
        self.offset.y = 0
    }

    // 重写方法
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        var index = chartView?.data?.dataSets[0].entryIndex(entry: entry)
        if index == -1 || index == nil {
            if let dataSets = chartView?.data?.dataSets, dataSets.count > 1 {
                index = chartView?.data?.dataSets[1].entryIndex(entry: entry)
            }
             
        }
        if index == -1 || index == nil {
            if let dataSets = chartView?.data?.dataSets, dataSets.count > 2 {
                index = chartView?.data?.dataSets[2].entryIndex(entry: entry)
            }
        }
        if index == -1 || index == nil {
            if let dataSets = chartView?.data?.dataSets, dataSets.count > 3 {
                index = chartView?.data?.dataSets[3].entryIndex(entry: entry)
            }
        }
        if index == -1 || index == nil {
            if let dataSets = chartView?.data?.dataSets, dataSets.count > 4 {
                index = chartView?.data?.dataSets[4].entryIndex(entry: entry)
            }
        }
        if let index = index, index != -1 {
            for i in 0..<valueCount {
                let entry1 = chartView?.data?.dataSets[i].entryForIndex(index)
                labelArray[i].text = String.init(format: "%d", Int(entry1!.y))
                
            }
        }

    }
    //重写方法
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        guard let chart = chartView else { return self.offset }
        
        var offset = self.offset
        
        let width = self.bounds.size.width
        
        if point.x + offset.x < 0.0
        {
            offset.x = -point.x
        }
        else if point.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - point.x - width
        }
        
        offset.y = -point.y + 8
        
        return offset
    }
}

