//
//  AffectiveCharts3FLow.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/2/21.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

public class AffectiveCharts3FLowView: AffectiveCharts3LineCommonView {
    public override func stepThreeSetData(_ array: [Double]) -> Self {
        guard array.count > 0 else {return self}
        var bIsAddYAxis = false
        for e in chartView.subviews {
            if e.isKind(of: UIImageView.classForCoder()) {
                bIsAddYAxis = true
                break
            }
        }
        if !bIsAddYAxis {
            let yAxisLine = UIImageView()
            yAxisLine.contentMode = .scaleToFill
            yAxisLine.image = UIImage.loadImage(name: "flow_y", any: classForCoder)
            chartView.addSubview(yAxisLine)
            yAxisLine.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(8)
                $0.width.equalTo(4)
                $0.top.equalToSuperview().offset(92)
                $0.bottom.equalToSuperview().offset(-14)
            }
        }
        dataSorce.removeAll()
        separateY.removeAll()
        dataSorce.append(contentsOf: array)
        
        //计算抽样
        sample = array.count / maxDataCount == 0 ? 1 : Int(ceilf(Float(array.count) / Float(maxDataCount)))
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.axisMaximum = Double(100)
        chartView.leftAxis.axisMinimum = Double(0)
        separateY.append(0)
        separateY.append(33)
        separateY.append(66)
        separateY.append(99)

        return self
    }
}
