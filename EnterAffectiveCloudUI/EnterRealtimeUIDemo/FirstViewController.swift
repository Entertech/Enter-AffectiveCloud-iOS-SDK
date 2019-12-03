//
//  FirstViewController.swift
//  EnterRealtimeUIDemo
//
//  Created by Enter on 2019/10/12.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class FirstViewController: UIViewController {

    @IBOutlet weak var brainwaveView: RealtimeBrainwaveView!
    @IBOutlet weak var spectrumView: RealtimeBrainwaveSpectrumView!
    @IBOutlet weak var pressureView: RealtimePressureView!
    @IBOutlet weak var relaxationView: RealtimeRelaxationView!
    @IBOutlet weak var attentionSmallView: RealtimeAttentionView!
    @IBOutlet weak var attentionView: RealtimeAttentionView!
    @IBOutlet weak var heartNoValueView: RealtimeHeartRateView!
    @IBOutlet weak var heartSmallView: RealtimeHeartRateView!
    @IBOutlet weak var heartLargeView: RealtimeHeartRateView!
    @IBOutlet weak var tipView: RealtimeAttentionView!
    @IBOutlet weak var progressView: RealtimeAttentionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    /**********************************************************************************/
    /*************observe(with: 65)中的65为demo演示所用，实际使用请直接用observe()*****************/
    /**********************************************************************************/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        heartLargeView.observe(with: 65) // 开始开启监听
        heartLargeView.setShadow()
        
        heartSmallView.observe(with: 65)
        heartSmallView.isShowExtremeValue = false //不显示最大最小值
        heartSmallView.setShadow()
        
        heartNoValueView.observe()  // 观察者并且不用赋值初始值
        heartNoValueView.isShowExtremeValue = false
        heartNoValueView.setShadow()
        
        attentionView.observe(with: 39)
        attentionView.setShadow()
        
        attentionSmallView.observe(with: 39)
        attentionSmallView.setShadow()
        
        relaxationView.observe(with: 69)
        relaxationView.setShadow()
        
        spectrumView.observe(with: (0.1, 0.28, 0.59, 0.02, 0.1))
        spectrumView.setShadow()
        
        // 为eeg脑波复制，创建左右脑数组
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
        brainwaveView.observe(with: leftArray, right: rightArray)
        brainwaveView.setShadow()
        
        tipView.showTip()
        
        progressView.showProgress()
        
        
    }

}


extension UIView {
    func setShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.shadowColor  = UIColor.gray.cgColor
    }
}
