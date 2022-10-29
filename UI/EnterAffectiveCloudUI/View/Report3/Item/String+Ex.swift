//
//  String+Ex.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

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
        if (self.count == 0) {
            return newData
        } else {
            for i in 0..<self.count {
                if (i == 0 || i == self.count - 1) {
                    newData.append(self[i])
                } else {
                    let average = (Double(self[i - 1] + self[i] + self[i+1]) / 3.0)
                    newData.append(average)
                }
            }
            return newData
        }
    }
}
