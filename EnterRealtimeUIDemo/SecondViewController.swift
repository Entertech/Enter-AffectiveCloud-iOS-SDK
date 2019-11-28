//
//  SecondViewController.swift
//  EnterRealtimeUIDemo
//
//  Created by Enter on 2019/10/12.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class SecondViewController: UIViewController {

    @IBOutlet weak var brainwaveView: RealtimeBrainwaveView!
    @IBOutlet weak var spectrumView: RealtimeBrainwaveSpectrumView!
    @IBOutlet weak var heartRateView: RealtimeHeartRateView!
    @IBOutlet weak var attentionView: RealtimeAttentionView!
    @IBOutlet weak var relaxationView: RealtimeRelaxationView!
    @IBOutlet weak var pressureView: RealtimePressureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    /**********************************************************************************/
    /*************observe(with: 65)中的值为demo演示所用，实际使用请直接用observe()****************/
    /**********************************************************************************/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        brainwaveView.bgColor = .black //背景色
        brainwaveView.mainColor = .white    //主色调
        brainwaveView.textColor = .white    //文字颜色
        brainwaveView.buttonImageName = "white"
        var leftArray: [Float] = []
        for _ in 0...200 {
            let random: Int = Int(arc4random_uniform(200))
            leftArray.append(Float(random - 100))
        }
        var rightArray: [Float] = []
        for _ in 0...200 {
            let random: Int = Int(arc4random_uniform(200))
            rightArray.append(Float(random - 100))
        }
        brainwaveView.observe(with: leftArray, right: rightArray)//开始观察
        
        spectrumView.bgColor = UIColor(red: 229.0/225.0, green: 234.0/255.0, blue: 247.0/255.0, alpha: 1)
        spectrumView.observe(with: (0.1, 0.28, 0.59, 0.22, 0.1))
        
        heartRateView.bgColor = UIColor(red: 1, green: 229.0/255.0, blue: 231.0/255.0, alpha: 1)
        heartRateView.mainColor = UIColor(red: 1, green: 72.0/255.0, blue: 82.0/255.0, alpha: 1)
        heartRateView.observe(with: 65)
        
        attentionView.bgColor = UIColor(red: 227.0/255.0, green: 1, blue: 241.0/255.0, alpha: 1)
        attentionView.mainColor = UIColor(red: 0, green: 217.0/255.0, blue: 147.0/255.0, alpha: 1)
        attentionView.observe(with:39)
        
        relaxationView.bgColor = UIColor(red: 1, green: 248.0/255.0, blue: 224.0/255.0, alpha: 1)
        relaxationView.mainColor = UIColor(red: 1, green: 194.0/255.0, blue: 0, alpha: 1)
        relaxationView.observe(with: 69)
        
        pressureView.bgColor = UIColor(red: 1, green: 229.0/255.0, blue: 231.0/255.0, alpha: 1)
        pressureView.mainColor = UIColor(red: 1, green: 72.0/255.0, blue: 82.0/255.0, alpha: 1)
        pressureView.observe()
    }


}

