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

    @IBInspectable open var cornerRadius: CGFloat = 4.0 {
        didSet {
            self.clipsToBounds = (self.cornerRadius > 0)
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable open var animatedScale: CGFloat = 1.0

    @IBInspectable open var animatedScaleDuration: Double = 0.2

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
        withShadow: Bool = false,
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
}
