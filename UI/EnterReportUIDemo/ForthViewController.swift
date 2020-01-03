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
    @IBOutlet weak var brainReportView: PrivateChartBrainSpectrum!
    @IBOutlet weak var hrvView: PrivateReportChartHRV!
    @IBOutlet weak var hrView: PrivateReportChartHR!
    @IBOutlet weak var pressureView: PrivateReportChartPressure!
    @IBOutlet weak var arView: PrivateReportChartAttentionAndRelaxation!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
        if let samplePath = samplePath {
            service.dataOfReport = ReportFileHander.readReportFile(samplePath)
            service.braveWaveView = brainReportView
            service.hrvView = hrvView
            service.heartRateView = hrView
            service.pressureView = pressureView
            service.attentionView = arView
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        service.show(object: self)
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
