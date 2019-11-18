//
//  FirstViewController.swift
//  EnterReportUIDemo
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class FirstViewController: UIViewController {

    private let service = ReportViewService()
    
    @IBOutlet weak var pressureView: PressureReportView!
    @IBOutlet weak var relaxationView: RelaxationReportView!
    @IBOutlet weak var attentionView: AttentionReportView!
    @IBOutlet weak var hrvView: HeartRateVariablityReportView!
    @IBOutlet weak var heartRateView: HeartRateReportView!
    @IBOutlet weak var spectrumView: BrainSpecturmReportView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
        if let samplePath = samplePath {
            service.dataOfReport = ReportFileHander.readReportFile(samplePath)
            service.braveWaveView = spectrumView
            service.heartRateView = heartRateView
            service.hrvView = hrvView
            service.attentionView = attentionView
            service.relaxationView = relaxationView
            service.pressureView = pressureView
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        service.show() // 展示图表请在layout完成之后

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // service.show()

    }


}

