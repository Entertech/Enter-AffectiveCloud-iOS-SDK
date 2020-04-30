//
//  ValueMarkerView.swift
//  Flowtime
//
//  Created by Enter on 2020/4/27.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import Charts

class ValueMarkerView: MarkerView {
    
    public var titleLabel: UILabel?
    public var label: UILabel?
    public var dot: UIView?
    
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
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: 4, width: 56, height: 15))
        label = UILabel(frame: CGRect(x: 10, y: 23, width: frame.width-20, height: 21))
        dot = UILabel(frame: CGRect(x: 8, y: 8, width: 8, height: 8))
        
        dot?.layer.cornerRadius = 4
        dot?.layer.masksToBounds = true
        dot?.backgroundColor = .red
        
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        label?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label?.textAlignment = .center
        
        self.addSubview(titleLabel!)
        self.addSubview(label!)
        self.addSubview(dot!)
        
        self.layer.cornerRadius = 4
        
        self.offset.x = -frame.size.width / 2.0
        self.offset.y = 0
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label?.text = String.init(format: "%d", Int(entry.y))
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        guard let chart = chartView else { return self.offset }
        
        var offset = self.offset
        
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
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
