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

    @IBOutlet weak var spectrumView: BrainSpecturmReportView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
        if let samplePath = samplePath {
            spectrumView.setDataFromReportFile(path: samplePath)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }


}

