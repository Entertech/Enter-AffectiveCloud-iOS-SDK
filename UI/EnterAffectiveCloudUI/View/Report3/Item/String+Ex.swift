//
//  String+Ex.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import Accelerate

var zoomText = "Zoom in on the curve and slide to view it."
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


extension Array where Element == Int {
    func smoothData() -> [Int] {
        var newData = [Int]()
        if (self.count == 0) {
            return newData
        } else {
            for i in 0..<self.count {
                if (i == 0 || i == self.count - 1) {
                    newData.append(self[i])
                } else {
                    let average = Int(round(Double(self[i - 1] + self[i] + self[i+1]) / 3.0))
                    newData.append(average)
                }
            }
            return newData
        }
    }
}

extension Array where Element == Double {
    func smoothData() -> [Double] {
        var newData = [Double]()
        var halfSmoothLen = 9
        let recLen = self.count
        let tmp = recLen / 100
        let max = tmp > 16 ? tmp : 16
        let min = max > recLen ? recLen : max
        halfSmoothLen = min
        
        //无效点处理
        var firstValue = 0.0
        for e in self {
            if e > 0 {
                firstValue = e
                break
            }
        }

        var lastValue = 0.0
        for e in self {
            if e > 0 {
                lastValue = e
                newData.append(e)
            } else {
                if lastValue == 0 {
                    newData.append(firstValue)
                } else {
                    newData.append(lastValue)
                }
            }
        }
        
        var curveExpand = [Double]()
        curveExpand.append(contentsOf: Array.init(repeating: newData.first ?? 0, count: halfSmoothLen))
        curveExpand.append(contentsOf: newData)
        curveExpand.append(contentsOf: Array.init(repeating: newData.last ?? 0, count: halfSmoothLen))
        var curve = Array.init(repeating: 0.0, count: newData.count)
        for i in 0..<newData.count {
            curve[i] = vDSP.mean(Array(curveExpand[i...i+halfSmoothLen*2]))

        }
        
        return curve
    }
}
