//
//  LoadingButton.swift
//  IndicatorButton
//
//  Created by quan bui on 2021/05/17.
//

import UIKit

public typealias BtnCallBack = (() -> Void)?

@IBDesignable
open class LoadingButton: UIButton {

    private var activityIndicator: UIActivityIndicatorView!

    private var activityIndicatorColor: UIColor = .white

    private var indicatorPosition: IndicatorPosition = .center

    @IBInspectable open var animatedScale: CGFloat = 1.0

    @IBInspectable open var animatedScaleDuration: Double = 0.2

    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }

    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }

    @IBInspectable open var cornerRadius: CGFloat = 4.0 {
        didSet {
            self.clipsToBounds = (self.cornerRadius > 0)
            self.layer.cornerRadius = self.cornerRadius
            if let gradientLayer = gradient {
                gradientLayer.cornerRadius = cornerRadius
            }
        }
    }

    @IBInspectable open var shadowColor: UIColor = UIColor.clear {
        didSet {
            self.layer.shadowColor = self.shadowColor.cgColor
        }
    }

    @IBInspectable open var shadowOffset: CGSize = .zero {
        didSet {
            self.layer.masksToBounds = !(self.shadowOffset != .zero)
            self.layer.shadowOffset = self.shadowOffset
        }
    }

    @IBInspectable open var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }

    @IBInspectable open var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
        }
    }

    @IBInspectable open var gradientEnabled: Bool = false {
        didSet {
            customGradient()
        }
    }

    @IBInspectable open var gradientStartColor: UIColor = UIColor.clear {
        didSet {
            customGradient()
        }
    }

    @IBInspectable open var gradientEndColor: UIColor = UIColor.clear {
        didSet {
            customGradient()
        }
    }

    private var direction: GradientDirection = .toRight
    @IBInspectable open var gradientDirection: Int {
        get {
            return self.direction.rawValue
        }
        set (index) {
            self.direction = GradientDirection(rawValue: index) ?? .toRight
            customGradient()
        }
    }

    var gradient: CAGradientLayer?

    func customGradient() {
        gradient?.removeFromSuperlayer()
        guard gradientEnabled else { return }

        gradient = CAGradientLayer()
        guard let gradient = gradient else { return }

        gradient.frame = self.layer.bounds
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.locations = [0.0, 1.0]
        let dirPoint = directionPoint(CGSize(width: 1, height: 1))
        gradient.startPoint = dirPoint.start
        gradient.endPoint = dirPoint.end
        gradient.cornerRadius = self.cornerRadius

        self.layer.insertSublayer(gradient, below: self.imageView?.layer)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        gradient?.frame = self.layer.bounds
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init(
        frame: CGRect = .zero,
        text: String? = nil,
        textColor: UIColor? = .white,
        font: UIFont? = nil,
        backgroundColor: UIColor? = .black,
        cornerRadius: CGFloat = 4.0,
        indicatorPosition: IndicatorPosition = .center
    ) {
        super.init(frame: frame)
        if let text = text {
            self.setTitle(text)
            self.setTitleColor(textColor, for: .normal)
            self.activityIndicatorColor = textColor!
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.setCornerBorder(cornerRadius: cornerRadius)
        self.indicatorPosition = indicatorPosition
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open func start() {
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }

        self.isUserInteractionEnabled = false
        activityIndicator.isUserInteractionEnabled = false

        UIView.animate(withDuration: animatedScaleDuration) {
            self.transform = CGAffineTransform(scaleX: self.animatedScale, y: self.animatedScale)
        } completion: { done in
            UIView.animate(withDuration: self.animatedScaleDuration) {
                self.transform = CGAffineTransform.identity
            } completion: { done in
                UIView.transition(with: self, duration: 0.5, options: .curveEaseOut) {
                    self.alpha = 0.8
                    self.titleLabel?.alpha = self.indicatorPosition == .center ? 0.0 : 0.6
                } completion: { finished in
                    self.showSpinning()
                }
            }
        }
    }

    open func stop() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  self.activityIndicator != nil else {
                return
            }

            self.activityIndicator.stopAnimating()
            self.isUserInteractionEnabled = true
            self.activityIndicator.removeFromSuperview()

            UIView.transition(with: self,
                              duration: 0.5,
                              options: .curveEaseOut) {
                self.alpha = 1.0
                self.titleLabel?.alpha = 1.0
            } completion: { finished in
            }
        }
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        positionActivityIndicator()
        activityIndicator.startAnimating()
    }

    private func positionActivityIndicator() {
        var nsLayout: NSLayoutConstraint!
        switch indicatorPosition {
        case .left:
            nsLayout = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: activityIndicator, attribute: .leading, multiplier: 1, constant: -12.0)
        case .center:
            nsLayout = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        case .right:
            nsLayout = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: activityIndicator, attribute: .trailing, multiplier: 1, constant: 12.0)
        }

        self.addConstraint(nsLayout)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

    private func directionPoint(_ size: CGSize) -> (start: CGPoint, end: CGPoint) {
        switch direction {
        case .toTop:
            return (CGPoint(x: size.width / 2, y: size.height),
                    CGPoint(x: size.width / 2, y: 0.0))
        case .toRight:
            return (CGPoint(x: 0.0, y: size.width / 2),
                    CGPoint(x: size.width, y: size.height / 2))
        case .toBottom:
            return (CGPoint(x: size.width / 2, y: 0.0),
                    CGPoint(x: size.width / 2, y: size.height))
        case .toLeft:
            return (CGPoint(x: size.width, y: size.height / 2),
                    CGPoint(x: 0.0, y: size.height / 2))
        case .toTopRight:
            return (CGPoint(x: 0.0, y: size.height),
                    CGPoint(x: size.width, y: 0.0))
        case .toTopLeft:
            return (CGPoint(x: size.width, y: size.height),
                    CGPoint(x: 0.0, y: 0.0))
        case .toBottomRight:
            return (CGPoint(x: 0.0, y: 0.0),
                    CGPoint(x: size.width, y: size.height))
        case .toBottomLeft:
            return (CGPoint(x: size.width, y: 0.0),
                    CGPoint(x: 0.0, y: size.height))
        }
    }
}
