//
//  ThirdViewController.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/12/20.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class ThirdViewController: UIViewController {

    @IBOutlet weak var head1: PrivateReportViewHead!
    @IBOutlet weak var view1: PrivateReportBrainwaveSpectrum!
    @IBOutlet weak var bView2: UIView!
    @IBOutlet weak var head2: PrivateReportViewHead!
    @IBOutlet weak var view2: PrivateReportHRV!
    @IBOutlet weak var head3: PrivateReportViewHead!
    @IBOutlet weak var view3: PrivateReportHR!
    @IBOutlet weak var head4: PrivateReportViewHead!
    @IBOutlet weak var view4: PrivateReportRelaxationAndAttention!
    @IBOutlet weak var head5: PrivateReportViewHead!
    @IBOutlet weak var view5: PrivateReportPressure!

    @IBOutlet weak var view6: PrivateAverageView!
    @IBOutlet weak var head6: PrivateReportViewHead!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        head1.titleText = "Brainwave Spectrum"
        head1.image = #imageLiteral(resourceName: "brain")
        
        view1.values = [ 0.1, 0.25, 0.30, 0.15, 0.2]
        
        head2.titleText = "Heart Rate Variability"
        head2.image = #imageLiteral(resourceName: "brain")
        
        view2.value = 25
        
        bView2.layer.cornerRadius = 8
        view2.corner = 8
        bView2.layer.shadowColor = UIColor.lightGray.cgColor
        bView2.layer.shadowOpacity = 0.5
        bView2.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        head3.image = #imageLiteral(resourceName: "brain")
        head3.titleText = "Heart Rate"
        view3.value = 35
        
        head4.image = #imageLiteral(resourceName: "brain")
        head4.titleText = "Relaxation & Attention"
        view4.attentionValue = 87
        view4.relaxationValue = 30
        
        head5.image = #imageLiteral(resourceName: "brain")
        head5.titleText = "Pressure"
        view5.value = 64
        
        head6.image = #imageLiteral(resourceName: "brain")
        head6.titleText = "Meditation Time"
        view6.mainColor = UIColor.blue
        view6.unitText = "mins"
        view6.categoryName = .Meditation
        view6.values = [35, 17, 29, 30, 77]
        
        
    }

}
