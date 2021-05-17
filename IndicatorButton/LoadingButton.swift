//
//  LoadingButton.swift
//  IndicatorButton
//
//  Created by quan bui on 2021/05/17.
//

import UIKit

public typealias BtnCallBack = (() -> Void)?

open class LoadingButton: UIButton {
    private var activityIndicator: UIActivityIndicatorView!
    private var activityIndicatorColor: UIColor = .white

    private var indicatorPosition: IndicatorPosition = .center

    open var cornerRadius: CGFloat = 4.0 {
        didSet {
            self.clipsToBounds = (self.cornerRadius > 0)
            self.layer.cornerRadius = self.cornerRadius
        }
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
        UIView.transition(with: self, duration: 0.34, options: .curveEaseOut) {
            if self.indicatorPosition == .center {
                self.titleLabel?.alpha = 0.0
            }
            self.alpha = 0.80
        } completion: { finished in
            self.showSpinning()
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
            UIView.transition(with: self, duration: 0.4, options: .curveEaseOut) {
                self.alpha = 1.0
                if self.indicatorPosition == .center {
                    self.titleLabel?.alpha = 1.0
                }
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
