//
//  ViewController.swift
//  IndicatorButton
//
//  Created by quan bui on 2021/05/17.
//

import UIKit

class ViewController: UIViewController {
    var loadingBtn: LoadingButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadingBtn = LoadingButton(text: "Connect",
                                   textColor: .white,
                                   font: UIFont.systemFont(ofSize: 18),
                                   backgroundColor: .gray,
                                   cornerRadius: 12.0)

        loadingBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingBtn)
        loadingBtn.widthAnchor.constraint(equalToConstant: 220).isActive = true
        loadingBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        loadingBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingBtn.addTarget(self, action: #selector(loadingBtnClicked), for: .touchUpInside)
    }

    @objc func loadingBtnClicked() {
        loadingBtn.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadingBtn.stop()
        }
    }
}
