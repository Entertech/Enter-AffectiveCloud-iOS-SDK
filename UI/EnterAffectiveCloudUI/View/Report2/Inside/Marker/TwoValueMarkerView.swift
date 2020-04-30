//
//  TwoValueMarkerView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2020/4/29.
//  Copyright © 2020 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

class TwoValueMarkerView: MarkerView {

    public var titleLabel: UILabel?
    public var label: UILabel?
    public var dot: UIView?
    public var title2Label: UILabel?
    public var label2: UILabel?
    public var dot2: UIView?
    public var lineColor: UIColor?{
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
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: 4, width: 56, height: 15))
        label = UILabel(frame: CGRect(x: 10, y: 23, width: frame.width/2-20, height: 21))
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
        
        title2Label = UILabel(frame: CGRect(x: 100, y: 4, width: 54, height: 15))
        label2 = UILabel(frame: CGRect(x: 90, y: 23, width: frame.width/2-20, height: 21))
        dot2 = UILabel(frame: CGRect(x: 88, y: 8, width: 8, height: 8))
        
        dot2?.layer.cornerRadius = 4
        dot2?.layer.masksToBounds = true
        dot2?.backgroundColor = .red
        
        title2Label?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        label2?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label2?.textAlignment = .center
        
        let lineView = UIView(frame: CGRect(x: frame.width/2-0.5, y: 8, width: 1, height: frame.height-16))
        if #available(iOS 13.0, *) {
            lineView.backgroundColor = .systemGray3
        } else {
            lineView.backgroundColor = .gray
        }
        lineView.layer.cornerRadius = 0.5
        lineView.layer.masksToBounds = true
        self.addSubview(lineView)
            
        self.addSubview(title2Label!)
        self.addSubview(label2!)
        self.addSubview(dot2!)
        
        self.layer.cornerRadius = 4
        let path = UIBezierPath(roundedRect: CGRect(x: frame.width/2-1, y: frame.height, width: 2, height: 4), cornerRadius: 1)
        
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.gray.cgColor
        lineLayer.fillColor = UIColor.gray.cgColor
        self.layer.addSublayer(lineLayer)
        
        self.offset.x = -frame.size.width / 2.0
        self.offset.y = 0
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        var index = chartView?.data?.dataSets[0].entryIndex(entry: entry)
        if index == -1 || index == nil {
             index = chartView?.data?.dataSets[1].entryIndex(entry: entry)
        }
        if let index = index {
            let entry1 = chartView?.data?.dataSets[0].entryForIndex(index)
            let entry2 = chartView?.data?.dataSets[1].entryForIndex(index)

            label?.text = String.init(format: "%d", Int(entry1!.y) > 100 ? Int(entry1!.y)-130 : Int(entry1!.y)) //因为一条线高度被加高了,减130
            label2?.text = String.init(format: "%d", Int(entry2!.y) > 100 ? Int(entry2!.y)-130 : Int(entry2!.y))
            


        }
    }
    
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
        
        offset.y = -point.y + 25
        
        return offset
    }

}
