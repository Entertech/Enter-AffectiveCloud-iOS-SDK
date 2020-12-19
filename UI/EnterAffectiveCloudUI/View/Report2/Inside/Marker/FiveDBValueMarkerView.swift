//
//  FileValueMarkerView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/4/29.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

class FiveDBValueMarkerView: MarkerView {

    public var titleLabelArray: [UILabel] = []
    public var labelArray: [UILabel] = []
    public var dotArray: [UIView] = []
    public var lineColor: UIColor? {
        willSet {
            lineLayer.strokeColor = newValue!.cgColor
            lineLayer.fillColor = newValue!.cgColor
        }
    }
    private let lineLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI(frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //setUI()
    }
    
    private func setUI(_ frame: CGRect) {
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemGray5
        } else {
            // Fallback on earlier versions
            self.backgroundColor = .systemGray
        }
        for i in 0..<5 {
            
            let titleLabel = UILabel(frame: CGRect(x: 28+48*i, y: 4, width: 22, height: 15))
            let label = UILabel(frame: CGRect(x: 8+48*i, y: 23, width: 40, height: 21))
            let dot = UILabel(frame: CGRect(x: 16+48*i, y: 8, width: 8, height: 8))
            
            dot.layer.cornerRadius = 4
            dot.layer.masksToBounds = true
            dot.backgroundColor = .red
            
            titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textAlignment = .center
            
            self.addSubview(titleLabel)
            self.addSubview(label)
            self.addSubview(dot)
            titleLabelArray.append(titleLabel)
            labelArray.append(label)
            dotArray.append(dot)
            
            if i < 4 { // 中间线段
                let lineView = UIView(frame: CGRect(x: 48+48*i, y: 8, width: 1, height: Int(frame.height-16.0)))
                if #available(iOS 13.0, *) {
                    lineView.backgroundColor = .systemGray3
                } else {
                    lineView.backgroundColor = .gray
                }
                lineView.layer.cornerRadius = 0.5
                lineView.layer.masksToBounds = true
                self.addSubview(lineView)
            }

        }
        self.layer.cornerRadius = 4
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
            for i in 0..<5 {
                let entry1 = chartView?.data?.dataSets[0].entryForIndex(index)
                labelArray[i].text = String.init(format: "%d", entry1!.y)
                
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

