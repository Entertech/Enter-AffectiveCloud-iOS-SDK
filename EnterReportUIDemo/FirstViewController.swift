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


    @IBOutlet weak var attentionView: AttentionReportView!
    @IBOutlet weak var hrvView: HeartRateVariablityReportView!
    @IBOutlet weak var heartRateView: HeartRateReportView!
    @IBOutlet weak var spectrumView: BrainSpecturmReportView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //WARNING:- 不能在Layout完成前设置数据
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
        if let samplePath = samplePath {
            spectrumView.setDataFromReportFile(path: samplePath)
            heartRateView.setDataFromReportFile(path: samplePath)
            hrvView.setDataFromReportFile(path: samplePath)
            attentionView.setDataFromReportFile(path: samplePath)
        }
        
    }


}

