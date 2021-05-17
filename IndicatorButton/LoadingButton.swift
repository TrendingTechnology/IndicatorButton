//
//  LoadingButton.swift
//  IndicatorButton
//
//  Created by quan bui on 2021/05/17.
//

import UIKit

public enum IndicatorPosition {
    case left
    case right
    case center
}

open class LoadingButton: UIButton {

    private var activityIndicator: UIActivityIndicatorView!
    private var title: String?

    open var activityIndicatorColor: UIColor = .lightGray
    open var indicatorPosition: IndicatorPosition = .center

    open func start() {
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        self.isEnabled = false
        self.alpha = 0.7
        if indicatorPosition == .center {
            title = self.titleLabel?.text
            self.setTitle("", for: .normal)
        }
        showSpinning()
    }

    open func stop() {
        guard activityIndicator != nil else { return }

        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.isEnabled = true
            self.alpha = 1.0
            if self.indicatorPosition == .center {
                self.setTitle(self.title, for: .normal)
            }
            self.activityIndicator.removeFromSuperview()
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
        default:
            nsLayout = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: activityIndicator, attribute: .trailing, multiplier: 1, constant: 12.0)
        }
        self.addConstraint(nsLayout)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
