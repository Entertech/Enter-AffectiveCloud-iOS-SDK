//
//  AffectiveCharts3ExpandRhythmView.swift
//  EnterAffectiveCloudUI
//
//  Created by Enter on 2022/6/15.
//  Copyright © 2022 Hangzhou Enter Electronic Technology Co., Ltd. All rights reserved.
//

import UIKit

class AffectiveCharts3ExpandRhythmView: UIView {
    public var gamaColor = UIColor.colorWithHexString(hexColor: "#FF6682")
    public var betaColor = UIColor.colorWithHexString(hexColor: "#58B9E0")
    public var alphaColor = UIColor.colorWithHexString(hexColor: "#F7C77E")
    public var thetaColor = UIColor.colorWithHexString(hexColor: "#5FC695")
    public var deltaColor = UIColor.colorWithHexString(hexColor: "#5E75FF")

    public weak var delegate: RhythmsViewDelegate?
    public weak var expandDelegate: AffectiveCharts3ExpandDelegate?
    public var style = AffectiveCharts3FormatOptional.session {
        didSet {
            var title = ""
            switch style {
            case .session:
                title = "Average Percentage".uppercased()
            case .month:
                title = "Daily Average Percentage".uppercased()
            case .year:
                title = "Monthly Average Percentage".uppercased()
            }
            _ = infoView.setUI(title: title).setLayout()
        }
    }
    private var isNotShowExpand = true
    /// 伽马线是否可用
    public lazy var gamaEnable: Bool = true {
        willSet {
            if newValue {
                gamaBtn.setImage(UIImage.loadImage(name: "icon_choose_red", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 1)
            } else {
                gamaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_red", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1)
            }
        }
    }

    /// beta线是否可用
    public lazy var betaEnable: Bool = true {
        willSet {
            if newValue {
                betaBtn.setImage(UIImage.loadImage(name: "icon_choose_cyan", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 3)
            } else {
                betaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_cyan", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 2)
            }
        }
    }

    /// alpha线是否可用
    public lazy var alphaEnable: Bool = true {
        willSet {
            if newValue {
                alphaBtn.setImage(UIImage.loadImage(name: "icon_choose_yellow", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 5)
            } else {
                alphaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_yellow", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 4)
            }
        }
    }

    /// theta线是否可用
    public lazy var thetaEnable: Bool = true {
        willSet {
            if newValue {
                thetaBtn.setImage(UIImage.loadImage(name: "icon_choose_green", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 7)
            } else {
                thetaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_green", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 6)
            }
        }
    }

    /// delta线是否可用
    public lazy var deltaEnable: Bool = true {
        willSet {
            if newValue {
                deltaBtn.setImage(UIImage.loadImage(name: "icon_choose_blue", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 9)
            } else {
                deltaBtn.setImage(UIImage.loadImage(name: "icon_unchoose_blue", any: classForCoder), for: .normal)
                delegate?.setRhythmsEnable(value: 1 << 8)
            }
        }
    }

    private var btnEnableCount: Int {
        var count = 0
        if gamaEnable {
            count += 1
        }
        if betaEnable {
            count += 1
        }
        if alphaEnable {
            count += 1
        }
        if thetaEnable {
            count += 1
        }
        if deltaEnable {
            count += 1
        }
        return count
    }

    private let gamaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let betaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let alphaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let thetaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let deltaBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
    private let btnContentView = UIStackView()

    private let expandBtn = UIButton()
    private let infoView = AffectiveCharts3RhythmsInfoView()

    public init() {
        super.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setLineEnable(value: Int) {
        if value >> 0 & 1 == 1 {
            gamaEnable = true
        } else {
            gamaEnable = false
        }
        if value >> 1 & 1 == 1 {
            betaEnable = true
        } else {
            betaEnable = false
        }
        if value >> 2 & 1 == 1 {
            alphaEnable = true
        } else {
            alphaEnable = false
        }
        if value >> 3 & 1 == 1 {
            thetaEnable = true
        } else {
            thetaEnable = false
        }
        if value >> 4 & 1 == 1 {
            deltaEnable = true
        } else {
            deltaEnable = false
        }
    }

    public func setRhythms(gamma: Int, beta: Int, alpha: Int, theta: Int, delta: Int, timeFrom: TimeInterval, timeTo: TimeInterval) {
        
        let dateFrom = Date(timeIntervalSince1970: round(timeFrom))

        if Calendar.current.component(.day, from: dateFrom) == 1 {
            lk_formatter.dateFormat = "MMM yyyy"
            let time = lk_formatter.string(from: dateFrom)
            _ = infoView.setRhythms(gamma: gamma, beta: beta, alpha: alpha, theta: theta, delta: delta, time: time)

        } else {
            lk_formatter.dateFormat = style.fromFormat
            let fromText = lk_formatter.string(from: dateFrom)
            lk_formatter.dateFormat = style.toFormat
            let dateTo = Date(timeIntervalSince1970: round(timeTo))
            let toText = lk_formatter.string(from: dateTo)
            let time = fromText + toText
            _ = infoView.setRhythms(gamma: gamma, beta: beta, alpha: alpha, theta: theta, delta: delta, time: time)
        }
        infoView.isHidden = false
    }

    /// ui
    /// - Parameter isAlreadShow: 是否已经展开横屏
    /// - Returns:
    public func setUI(isAlreadShow: Bool) -> Self {
        isNotShowExpand = !isAlreadShow
        backgroundColor = .clear
        gamaBtn.backgroundColor = gamaColor.changeAlpha(to: 0.2)
        gamaBtn.setTitle("γ", for: .normal)
        gamaBtn.setTitleColor(gamaColor, for: .normal)
        gamaBtn.layer.cornerRadius = 12
        gamaBtn.adjustsImageWhenHighlighted = false
        gamaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        gamaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        gamaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        gamaBtn.addTarget(self, action: #selector(gamaAction(_:)), for: .touchUpInside)

        betaBtn.backgroundColor = gamaColor.changeAlpha(to: 0.2)
        betaBtn.setTitle("β", for: .normal)
        betaBtn.setTitleColor(betaColor, for: .normal)
        betaBtn.layer.cornerRadius = 12
        betaBtn.adjustsImageWhenHighlighted = false
        betaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        betaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        betaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        betaBtn.addTarget(self, action: #selector(betaAction(_:)), for: .touchUpInside)

        alphaBtn.backgroundColor = alphaColor.changeAlpha(to: 0.2)
        alphaBtn.setTitle("α", for: .normal)
        alphaBtn.setTitleColor(alphaColor, for: .normal)
        alphaBtn.layer.cornerRadius = 12
        alphaBtn.adjustsImageWhenHighlighted = false
        alphaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        alphaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        alphaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        alphaBtn.addTarget(self, action: #selector(alphaAction(_:)), for: .touchUpInside)

        thetaBtn.backgroundColor = thetaColor.changeAlpha(to: 0.2)
        thetaBtn.setTitle("θ", for: .normal)
        thetaBtn.setTitleColor(thetaColor, for: .normal)
        thetaBtn.layer.cornerRadius = 12
        thetaBtn.adjustsImageWhenHighlighted = false
        thetaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        thetaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        thetaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        thetaBtn.addTarget(self, action: #selector(thetaAction(_:)), for: .touchUpInside)

        deltaBtn.backgroundColor = deltaColor.changeAlpha(to: 0.2)
        deltaBtn.setTitle("δ", for: .normal)
        deltaBtn.setTitleColor(deltaColor, for: .normal)
        deltaBtn.layer.cornerRadius = 12
        deltaBtn.adjustsImageWhenHighlighted = false
        deltaBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        deltaBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        deltaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        deltaBtn.addTarget(self, action: #selector(deltaAction(_:)), for: .touchUpInside)

        btnContentView.alignment = .fill
        btnContentView.addArrangedSubview(gamaBtn)
        btnContentView.addArrangedSubview(betaBtn)
        btnContentView.addArrangedSubview(alphaBtn)
        btnContentView.addArrangedSubview(thetaBtn)
        btnContentView.addArrangedSubview(deltaBtn)
        btnContentView.axis = .horizontal
        btnContentView.backgroundColor = .clear
        btnContentView.distribution = .fillEqually
        btnContentView.spacing = (UIScreen.main.bounds.width - 64 - 44 * 5) / 4
        // btnContentView.translatesAutoresizingMaskIntoConstraints = false

        if isNotShowExpand {
            expandBtn.setImage(UIImage.loadImage(name: "expand", any: classForCoder), for: .normal)
        } else {
            expandBtn.setImage(UIImage.loadImage(name: "expand_back", any: classForCoder), for: .normal)
        }
        expandBtn.addTarget(self, action: #selector(expandAction(_:)), for: .touchUpInside)
        infoView.isHidden = true
        

        addSubview(btnContentView)
        addSubview(expandBtn)
        addSubview(infoView)

        return self
    }

    public func setLayout() {
        btnContentView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(18)
            $0.height.equalTo(24)
        }

        expandBtn.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalTo(btnContentView.snp.bottom).offset(16)
        }

        infoView.snp.makeConstraints {
            $0.top.equalTo(btnContentView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(57)
            $0.trailing.equalTo(expandBtn.snp.leading)
        }
    }

    @objc
    private func gamaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && gamaEnable {
            return
        }
        gamaEnable = !gamaEnable
    }

    @objc
    private func betaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && betaEnable {
            return
        }
        betaEnable = !betaEnable
    }

    @objc
    private func alphaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && alphaEnable {
            return
        }
        alphaEnable = !alphaEnable
    }

    @objc
    private func thetaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && thetaEnable {
            return
        }
        thetaEnable = !thetaEnable
    }

    @objc
    private func deltaAction(_ sender: UIButton) {
        if btnEnableCount == 1 && deltaEnable {
            return
        }
        deltaEnable = !deltaEnable
    }

    @objc func expandAction(_ sender: UIButton) {
        expandDelegate?.expand(flag: isNotShowExpand)
    }
}

extension AffectiveCharts3ExpandRhythmView: AffectiveCharts3ChartChanged {
    func update(single: Int?, mult: (Int, Int, Int, Int, Int)?, from: Double, to: Double) {
        guard let mult = mult else {return}
        self.setRhythms(gamma: mult.0, beta: mult.1, alpha: mult.2, theta: mult.3, delta: mult.4, timeFrom: from, timeTo: to)
    }
    
    
}

class AffectiveCharts3RhythmsInfoView: UIView {
    public var gammaColor = UIColor.colorWithHexString(hexColor: "#FF6682")
    public var betaColor = UIColor.colorWithHexString(hexColor: "#58B9E0")
    public var alphaColor = UIColor.colorWithHexString(hexColor: "#F7C77E")
    public var thetaColor = UIColor.colorWithHexString(hexColor: "#5FC695")
    public var deltaColor = UIColor.colorWithHexString(hexColor: "#5E75FF")
    public var textColor = ColorExtension.textLv2
    public var textFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    public var numFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    public var percentFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
    public var lineColor = ColorExtension.lineLight
    public var gammaEnable = true
    public var betaEnable = true
    public var deltaEnable = true
    public var alphaEnable = true
    public var thetaEnable = true
    let titleLabel = UILabel()
    let gammaImage = UIImageView()
    let gammaNumLabel = UILabel()
    let gammaPercentLabel = UILabel()
    let split1 = UIView()
    let betaImage = UIImageView()
    let betaNumLabel = UILabel()
    let betaPercentLabel = UILabel()
    let split2 = UIView()
    let alphaImage = UIImageView()
    let alphaNumLabel = UILabel()
    let alphaPercentLabel = UILabel()
    let split3 = UIView()
    let thetaImage = UIImageView()
    let thetaNumLabel = UILabel()
    let thetaPercentLabel = UILabel()
    let split4 = UIView()
    let deltaImage = UIImageView()
    let deltaNumLabel = UILabel()
    let deltaPercentLabel = UILabel()
    let timeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUI(title: String) -> Self {
        backgroundColor = .clear
        titleLabel.textColor = textColor
        titleLabel.font = textFont
        titleLabel.text = title

        timeLabel.textColor = textColor
        timeLabel.font = textFont

        gammaImage.image = UIImage.loadImage(name: "gamma", any: classForCoder)
        gammaNumLabel.textColor = gammaColor
        gammaNumLabel.font = numFont
        gammaPercentLabel.textColor = gammaColor
        gammaPercentLabel.font = percentFont

        split1.backgroundColor = lineColor
        split1.layer.cornerRadius = 0.5
        split1.layer.masksToBounds = true

        betaImage.image = UIImage.loadImage(name: "beta", any: classForCoder)
        betaNumLabel.textColor = betaColor
        betaNumLabel.font = numFont
        betaPercentLabel.textColor = betaColor
        betaPercentLabel.font = percentFont

        split2.backgroundColor = lineColor
        split2.layer.cornerRadius = 0.5
        split2.layer.masksToBounds = true

        alphaImage.image = UIImage.loadImage(name: "alpha", any: classForCoder)
        alphaNumLabel.textColor = alphaColor
        alphaNumLabel.font = numFont
        alphaPercentLabel.textColor = alphaColor
        alphaPercentLabel.font = percentFont

        split3.backgroundColor = lineColor
        split3.layer.cornerRadius = 0.5
        split3.layer.masksToBounds = true

        thetaImage.image = UIImage.loadImage(name: "theta", any: classForCoder)
        thetaNumLabel.textColor = thetaColor
        thetaNumLabel.font = numFont
        thetaPercentLabel.textColor = thetaColor
        thetaPercentLabel.font = percentFont

        split4.backgroundColor = lineColor
        split4.layer.cornerRadius = 0.5
        split4.layer.masksToBounds = true

        deltaImage.image = UIImage.loadImage(name: "delta", any: classForCoder)
        deltaNumLabel.textColor = deltaColor
        deltaNumLabel.font = numFont
        deltaPercentLabel.textColor = deltaColor
        deltaPercentLabel.font = percentFont

        return self
    }

    public func setLayout() -> Self {
        addSubview(titleLabel)
        addSubview(gammaImage)
        addSubview(gammaNumLabel)
        addSubview(gammaPercentLabel)
        addSubview(split1)
        addSubview(betaImage)
        addSubview(betaPercentLabel)
        addSubview(betaNumLabel)
        addSubview(split2)
        addSubview(alphaImage)
        addSubview(alphaNumLabel)
        addSubview(alphaPercentLabel)
        addSubview(split3)
        addSubview(thetaImage)
        addSubview(thetaNumLabel)
        addSubview(thetaPercentLabel)
        addSubview(split4)
        addSubview(deltaImage)
        addSubview(deltaNumLabel)
        addSubview(deltaPercentLabel)
        addSubview(timeLabel)
        titleLabel.frame = CGRect(x: 8, y: 4, width: 240, height: 14)
        gammaImage.frame = CGRect(x: 8, y: 18.5, width: 16.5, height: 20)
        gammaNumLabel.frame = CGRect(x: 24.5, y: 18, width: 0, height: 21)
        gammaPercentLabel.frame = CGRect(x: 36.5, y: 22, width: 0, height: 17)
        split1.frame = CGRect(x: 53.5, y: 19.5, width: 1, height: 18)
        betaImage.frame = CGRect(x: 8, y: 18.5, width: 16.5, height: 20)
        betaNumLabel.frame = CGRect(x: 24.5, y: 18, width: 0, height: 21)
        betaPercentLabel.frame = CGRect(x: 36.5, y: 22, width: 0, height: 17)
        split2.frame = CGRect(x: 53.5, y: 19.5, width: 1, height: 18)
        alphaImage.frame = CGRect(x: 8, y: 18.5, width: 16.5, height: 20)
        alphaNumLabel.frame = CGRect(x: 24.5, y: 18, width: 0, height: 21)
        alphaPercentLabel.frame = CGRect(x: 36.5, y: 22, width: 0, height: 17)
        split3.frame = CGRect(x: 53.5, y: 19.5, width: 1, height: 18)
        thetaImage.frame = CGRect(x: 8, y: 18.5, width: 16.5, height: 20)
        thetaNumLabel.frame = CGRect(x: 24.5, y: 18, width: 0, height: 21)
        thetaPercentLabel.frame = CGRect(x: 36.5, y: 22, width: 0, height: 17)
        split4.frame = CGRect(x: 53.5, y: 19.5, width: 1, height: 18)
        deltaImage.frame = CGRect(x: 8, y: 18.5, width: 16.5, height: 20)
        deltaNumLabel.frame = CGRect(x: 24.5, y: 18, width: 0, height: 21)
        deltaPercentLabel.frame = CGRect(x: 36.5, y: 22, width: 0, height: 17)
        timeLabel.frame = CGRect(x: 8, y: 39, width: 240, height: 14)

        return self
    }

    public func setRhythms(gamma: Int, beta: Int, alpha: Int, theta: Int, delta: Int, time: String) -> CGFloat {
        if gamma > 0 {
            gammaNumLabel.text = "\(gamma)"
        } else {
            gammaEnable = false
        }
        if beta > 0 {
            betaNumLabel.text = "\(beta)"
        } else {
            betaEnable = false
        }
        if alpha > 0 {
            alphaNumLabel.text = "\(alpha)"
        } else {
            alphaEnable = false
        }
        if theta > 0 {
            thetaNumLabel.text = "\(theta)"
        } else {
            thetaEnable = false
        }
        if delta > 0 {
            deltaNumLabel.text = "\(delta)"
        } else {
            deltaEnable = false
        }

        let percentWidth: CGFloat = 13
        let spaceWidth: CGFloat = 4
        var offset: CGFloat = 8

        if gammaEnable {
            if let gammaWidth = gammaNumLabel.text?.width(withConstrainedHeight: 21, font: numFont) {
                offset += gammaImage.bounds.width
                gammaNumLabel.frame.size.width = gammaWidth
                offset += gammaWidth

                gammaPercentLabel.text = "%"
                gammaPercentLabel.frame.origin.x = offset
                gammaPercentLabel.frame.size.width = percentWidth
                offset += percentWidth

                if !betaEnable && !alphaEnable && !thetaEnable && !deltaEnable {
                    split1.isHidden = true
                } else {
                    offset += spaceWidth
                    split1.frame.origin.x = offset
                    offset += split1.frame.width
                    offset += spaceWidth
                }
            }

        } else {
            gammaImage.isHidden = true
            gammaNumLabel.isHidden = true
            gammaPercentLabel.isHidden = true
            split1.isHidden = true
        }

        if betaEnable {
            if let betaWidth = betaNumLabel.text?.width(withConstrainedHeight: 21, font: numFont) {
                betaImage.frame.origin.x = offset
                offset += betaImage.frame.width

                betaNumLabel.frame.origin.x = offset
                betaNumLabel.frame.size.width = betaWidth
                offset += betaWidth

                betaPercentLabel.text = "%"
                betaPercentLabel.frame.origin.x = offset
                betaPercentLabel.frame.size.width = percentWidth
                offset += percentWidth

                if !alphaEnable && !thetaEnable && !deltaEnable {
                    split2.isHidden = true
                } else {
                    offset += spaceWidth
                    split2.frame.origin.x = offset
                    offset += split2.frame.width
                    offset += spaceWidth
                }
            }
        } else {
            betaImage.isHidden = true
            betaNumLabel.isHidden = true
            betaPercentLabel.isHidden = true
            split2.isHidden = true
        }

        if alphaEnable {
            if let alphaWidth = alphaNumLabel.text?.width(withConstrainedHeight: 21, font: numFont) {
                alphaImage.frame.origin.x = offset
                offset += alphaImage.frame.width

                alphaNumLabel.frame.origin.x = offset
                alphaNumLabel.frame.size.width = alphaWidth
                offset += alphaWidth

                alphaPercentLabel.text = "%"
                alphaPercentLabel.frame.origin.x = offset
                alphaPercentLabel.frame.size.width = percentWidth
                offset += percentWidth

                if !thetaEnable && !deltaEnable {
                    split3.isHidden = true
                } else {
                    offset += spaceWidth
                    split3.frame.origin.x = offset
                    offset += split3.frame.width
                    offset += spaceWidth
                }
            }
        } else {
            alphaImage.isHidden = true
            alphaNumLabel.isHidden = true
            alphaPercentLabel.isHidden = true
            split3.isHidden = true
        }

        if thetaEnable {
            if let thetaWidth = thetaNumLabel.text?.width(withConstrainedHeight: 21, font: numFont) {
                thetaImage.frame.origin.x = offset
                offset += thetaImage.frame.width

                thetaNumLabel.frame.origin.x = offset
                thetaNumLabel.frame.size.width = thetaWidth
                offset += thetaWidth

                thetaPercentLabel.text = "%"
                thetaPercentLabel.frame.origin.x = offset
                thetaPercentLabel.frame.size.width = percentWidth
                offset += percentWidth

                if !deltaEnable {
                    split4.isHidden = true
                } else {
                    offset += spaceWidth
                    split4.frame.origin.x = offset
                    offset += split4.frame.width
                    offset += spaceWidth
                }
            }
        } else {
            thetaImage.isHidden = true
            thetaNumLabel.isHidden = true
            thetaPercentLabel.isHidden = true
            split4.isHidden = true
        }

        if deltaEnable {
            if let deltaWidth = deltaNumLabel.text?.width(withConstrainedHeight: 21, font: numFont) {
                deltaImage.frame.origin.x = offset
                offset += deltaImage.frame.width

                deltaNumLabel.frame.origin.x = offset
                deltaNumLabel.frame.size.width = deltaWidth
                offset += deltaWidth

                deltaPercentLabel.text = "%"
                deltaPercentLabel.frame.origin.x = offset
                deltaPercentLabel.frame.size.width = percentWidth
                offset += percentWidth
            }

        } else {
            deltaImage.isHidden = true
            deltaNumLabel.isHidden = true
            deltaPercentLabel.isHidden = true
        }
        offset += 8

        timeLabel.text = time
        if let sizeTime = timeLabel.text?.width(withConstrainedHeight: 12, font: textFont),
           let sizeTitle = titleLabel.text?.width(withConstrainedHeight: 12, font: textFont) {
            if sizeTime + 16 > offset {
                offset = sizeTime + 16
            }
            if sizeTitle + 16 > offset {
                offset = sizeTitle + 16
            }
        }

        return offset
    }
}
