//
//  ForthViewController.swift
//  EnterReportUIDemo
//
//  Created by Enter on 2019/12/24.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
import EnterAffectiveCloudUI

class ForthViewController: UIViewController {
    private let service = ChartService()
    @IBOutlet weak var brainReportView: AffectiveChartBrainSpectrumView!
    @IBOutlet weak var hrvView: AffectiveChartHRVView!
    @IBOutlet weak var hrView: AffectiveChartHeartRateView!
    @IBOutlet weak var pressureView: AffectiveChartPressureView!
    @IBOutlet weak var attentionView: AffectiveChartAttentionView!
    @IBOutlet weak var relaxationView: AffectiveChartRelaxationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //示例数据
        let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
        if let samplePath = samplePath {
            service.dataOfReport = ReportFileHander.readReportFile(samplePath)
            service.braveWaveView = brainReportView
            service.hrvView = hrvView
            service.heartRateView = hrView
            service.pressureView = pressureView
            service.attentionView = attentionView
            service.relaxationView = relaxationView
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //设置值显示数据
        service.show(object: self)
    }
    
}
