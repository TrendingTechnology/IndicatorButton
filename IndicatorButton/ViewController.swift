//
//  ViewController.swift
//  IndicatorButton
//
//  Created by quan bui on 2021/05/17.
//

import UIKit

class ViewController: UIViewController {
    var loadingBtn: LoadingButton = LoadingButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        loadingBtn.backgroundColor = .black
        loadingBtn.setTitle("印刷", for: .normal)
        loadingBtn.clipsToBounds = true
        loadingBtn.layer.cornerRadius = 6.0
        loadingBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingBtn)
        loadingBtn.widthAnchor.constraint(equalToConstant: 220).isActive = true
        loadingBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        loadingBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingBtn.addTarget(self, action: #selector(loadingBtnClicked), for: .touchUpInside)
    }

    @objc func loadingBtnClicked() {
//        print("Clicked")
        loadingBtn.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loadingBtn.stop()
        }
    }
}
