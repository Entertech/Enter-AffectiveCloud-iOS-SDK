//
//  BaseView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2019/10/9.
//  Copyright © 2019 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

open class BaseView: UIView {
    
    var maskCorner: CGFloat = 8.0
    open var bIsNeedUpdateMask = true

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setLayout()
    }
    
    func setUI() {}
    
    func setLayout() {}
    
    
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if let _ = newWindow {
            for e in self.subviews {
                if e.tag == 9999 {
                    for v in e.subviews {
                        if v.isKind(of: UIImageView.classForCoder()) {
                            let iv = v as! UIImageView
                            if !iv.isAnimating {
                                iv.startAnimating()
                            }
                            break
                        }

                    }
                    break
                }
            }
        }
    }
    
    public func restoreAnimation() {
        for e in self.subviews {
            if e.tag == 9999 {
                for v in e.subviews {
                    if v.isKind(of: UIImageView.classForCoder()) {
                        let iv = v as! UIImageView
                        if !iv.isAnimating {
                            iv.startAnimating()
                        }
                        break
                    }

                }
                break
            }
        }
    }

    /// 设备未连接实时数据无法显示时显示提示
    public func showTip(text: String = "连接设备以显示实时数据") {
        dismissMask()
        bIsNeedUpdateMask = false
        let maskView = UIView()
        maskView.tag = 9999
        maskView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        maskView.layer.cornerRadius = maskCorner
        maskView.layer.masksToBounds = true
        self.addSubview(maskView)
        maskView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        let tipLabel = UILabel()
        maskView.addSubview(tipLabel)
        tipLabel.text = text
        tipLabel.textColor = .white
        tipLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tipLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.layoutIfNeeded()
    }
    
    public func showProgress() {
        dismissMask()
        bIsNeedUpdateMask = true
        let maskView = UIView()
        maskView.tag = 9999
        maskView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        maskView.layer.cornerRadius = maskCorner
        maskView.layer.masksToBounds = true
        self.addSubview(maskView)
        maskView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        let imageView = UIImageView()
        maskView.addSubview(imageView)
        imageView.animationImages = UIImage.resolveGifImage(gif: "loading", any: classForCoder)
        imageView.animationDuration = 2
        imageView.animationRepeatCount = Int.max
        imageView.startAnimating()
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(36)
        }
    }
    
    public func dismissMask() {
        for e in self.subviews {
            if e.tag == 9999 {
                e.removeFromSuperview()
                break
            }
        }
    }
    
    public func showReportTip() {
        dismissMask()
        let maskView = UIView()
        maskView.tag = 9999
        maskView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        maskView.layer.cornerRadius = maskCorner
        maskView.layer.masksToBounds = true
        self.addSubview(maskView)
        maskView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        let tipLabel = UILabel()
        maskView.addSubview(tipLabel)
        tipLabel.text = "示例数据"
        tipLabel.textColor = .white
        tipLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tipLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.layoutIfNeeded()
    }

}
