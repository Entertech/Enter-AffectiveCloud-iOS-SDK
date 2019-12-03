//
//  SecondViewController.swift
//  EnterReportUIDemo
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
import EnterAffectiveCloudUI

class SecondViewController: UIViewController {

    private let service = ReportViewService()
    
    @IBOutlet weak var pressureReportView: PressureReportView!
    @IBOutlet weak var relaxationReportView: RelaxationReportView!
    @IBOutlet weak var attentionReportView: AttentionReportView!
    @IBOutlet weak var hrvReportView: HeartRateVariablityReportView!
    @IBOutlet weak var heartReportView: HeartRateReportView!
    @IBOutlet weak var brainReportView: BrainSpecturmReportView!
    override func viewDidLoad() {
        super.viewDidLoad()
            let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
            if let samplePath = samplePath {
                   service.dataOfReport = ReportFileHander.readReportFile(samplePath)
                   service.braveWaveView = brainReportView
                   service.heartRateView = heartReportView
                   service.hrvView = hrvReportView
                   service.attentionView = attentionReportView
                   service.relaxationView = relaxationReportView
                   service.pressureView = pressureReportView
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bgColor = UIColor(red: 12.0/255.0, green: 18.0/255.0, blue: 65.0/255.0, alpha: 1)
        brainReportView.bgColor = bgColor
        brainReportView.textColor = .white
        
        heartReportView.bgColor = bgColor
        heartReportView.textColor = .white
        heartReportView.heartRateLineColors = [
            UIColor(red: 0, green: 217.0/255.0, blue: 147.0/255.0, alpha: 1),
            UIColor(red: 1, green: 194.0/255.0, blue: 0, alpha: 1),
            UIColor(red: 1, green: 72.0/255.0, blue: 82.0/255.0, alpha: 1)
        ]
        
        hrvReportView.bgColor = bgColor
        hrvReportView.textColor = .white
        
        attentionReportView.bgColor = bgColor
        attentionReportView.textColor =  .white
        
        relaxationReportView.bgColor = bgColor
        relaxationReportView.textColor = .white
        
        pressureReportView.bgColor = bgColor
        pressureReportView.textColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        service.show(object: self) 
    }


}

