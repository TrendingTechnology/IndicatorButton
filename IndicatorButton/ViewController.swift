//
//  ViewController.swift
//  IndicatorButton
//
//  Created by quan bui on 2021/05/17.
//

import UIKit

class ViewController: UIViewController {
    var button1: LoadingButton!
    var button2: LoadingButton!
    var button3: LoadingButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        button1 = LoadingButton(text: "Tap me",
                                   textColor: .white,
                                   font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                                   backgroundColor: .systemBlue,
                                   cornerRadius: 4.0,
                                   indicatorPosition: .left)
        button2 = LoadingButton(text: "Tap me",
                                   textColor: .white,
                                   font: UIFont.systemFont(ofSize: 18, weight: .regular),
                                   backgroundColor: .systemPurple,
                                   cornerRadius: 12.0)
        button3 = LoadingButton(text: "Tap me",
                                   textColor: .white,
                                   font: UIFont.systemFont(ofSize: 20, weight: .medium),
                                   backgroundColor: .systemPink,
                                   cornerRadius: 10.0,
                                   indicatorPosition: .right)

        button1.animatedScale = 0.95
        button2.animatedScale = 0.70

        button1.gradientEnabled = true
        button1.gradientStartColor = .systemRed
        button1.gradientEndColor = .systemBlue
        button1.gradientDirection = 6

        button3.gradientStartColor = .systemGreen
        button3.gradientEndColor = .systemPurple
        button3.gradientDirection = 7

        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)

        button1.widthAnchor.constraint(equalToConstant: 220).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button1.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true

        button2.widthAnchor.constraint(equalToConstant: 220).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20).isActive = true
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        button3.widthAnchor.constraint(equalToConstant: 220).isActive = true
        button3.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20).isActive = true

        button1.addTarget(self, action: #selector(loadingBtnClicked), for: .touchUpInside)
    }

    @objc func loadingBtnClicked() {
        button1.start()
        button2.start()
        button3.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.button1.stop()
            self.button2.stop()
            self.button3.stop()
        }
    }
}
