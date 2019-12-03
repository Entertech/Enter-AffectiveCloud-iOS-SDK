//
//  FirstViewController.swift
//  EnterReportUIDemo
//
//  Created by Enter on 2019/10/16.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
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
        spectrumView.setShadow()
        heartRateView.setShadow()
        hrvView.setShadow()
        attentionView.setShadow()
        relaxationView.setShadow()
        pressureView.setShadow()
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hrvView.isChartScale = true
        attentionView.isChartScale = true
        service.show(object: self)
        
    }


}

extension UIView {
    func setShadow() {
        self.layer.shadowRadius  = 5.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

