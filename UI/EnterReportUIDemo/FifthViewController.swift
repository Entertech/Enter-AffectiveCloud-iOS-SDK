//
//  FifthViewController.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter M1 on 2023/12/13.
//  Copyright © 2023 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import SnapKit

class FifthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if true {
            let stageView = AffectiveChartsSleepStageView()
            let param = AffectiveChartsSleepParameter()
            let array = [0, 0, 1, 1, 1, 4, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3]
            let start = Date().timeIntervalSince1970
            let end = start + Double(array.count * 300)
            param.start = start
            param.end = end
            param.lineColors = [
                                UIColor.colorWithHexString(hexColor: "#FFC56F"),
                                UIColor.colorWithHexString(hexColor: "#3479FF"),
                                UIColor.colorWithHexString(hexColor: "#8B7AF3"),UIColor.colorWithHexString(hexColor: "#3634A2")]
            param.xAxisLabelColor = UIColor.colorWithHexString(hexColor: "#A6A7AF")
            param.xAxisLineColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
            param.xGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
            param.yAxisLabelColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
            param.yGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
            param.text = ["Awake", "REM", "Light", "Deep"]
            stageView.setData(array, param: param)
                .stepTwoSetLayout()
                .build()
            
            self.view.addSubview(stageView)
            stageView.snp.makeConstraints {
                $0.leading.top.equalTo(32)
                $0.trailing.equalTo(-32)
                $0.height.equalTo(126)
            }
        }
        
        if true {
            let stageView = AffectiveChartsSleepSingleLineView()
            let param = AffectiveChartsSleepParameter()
            var array = [Double]()
            for e in 0..<64 {
                array.append(Double(Int.random(in: 50..<80)))
            }
            let start = Date().timeIntervalSince1970
            let end = start + Double(array.count * 300)
            param.start = start
            param.end = end
            param.lineColors = [UIColor.colorWithHexString(hexColor: "#FF6682")]
            param.xAxisLabelColor = UIColor.colorWithHexString(hexColor: "#A6A7AF")
            param.xAxisLineColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
            param.xGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
            param.yAxisLabelColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
            param.yGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
            stageView.setData(array, param: param)
                .stepTwoSetLayout()
                .build()
            
            self.view.addSubview(stageView)
            stageView.snp.makeConstraints {
                $0.top.equalTo(200)
                $0.leading.equalTo(32)
                $0.trailing.equalTo(-32)
                $0.height.equalTo(132)
            }
        }
        
        if true {
            let stageView = AffectiveChartsSleepPositionView()
            let param = AffectiveChartsSleepParameter()
            let array = [0, 0, 1, 1, 1, 4, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 2, 2, 2, 2, 2, 3, 3, 3, 5, 5, 5, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3]
            let start = Date().timeIntervalSince1970
            let end = start + Double(array.count * 300)
            param.start = start
            param.end = end
            param.lineColors = [UIColor.colorWithHexString(hexColor: "#FFC56F"),
                                UIColor.colorWithHexString(hexColor: "#3479FF"),
                                UIColor.colorWithHexString(hexColor: "#8B7AF3"),
                                UIColor.colorWithHexString(hexColor: "#3634A2"),
                                UIColor.colorWithHexString(hexColor: "#3634A2")]
            param.xAxisLabelColor = UIColor.colorWithHexString(hexColor: "#A6A7AF")
            param.xAxisLineColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
            param.xGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
            param.yAxisLabelColor = UIColor.colorWithHexString(hexColor: "#C3C5C8")
            param.yGrideLineColor = UIColor.colorWithHexString(hexColor: "#DDE1EB")
            param.text = ["Upright", "Left", "Right", "Back", "Front"]
            stageView.setData(array, param: param)
                .stepTwoSetLayout()
                .build()
            
            self.view.addSubview(stageView)
            stageView.snp.makeConstraints {
                $0.top.equalTo(350)
                $0.leading.equalTo(32)
                $0.trailing.equalTo(-32)
                $0.height.equalTo(132)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
