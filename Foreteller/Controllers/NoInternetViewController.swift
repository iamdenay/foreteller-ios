//
//  DataViewController.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 12/12/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import EasyPeasy

class NoInternetViewController: UIViewController {
    
    fileprivate var labelMain = UILabel().then{
        $0.text = "Whoops!"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        $0.textColor = .darkGray
    }
    
    lazy var labelDesc = UILabel().then {
        $0.text = "There is no internet connection. Please check you wi-fi or mobile network."
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    fileprivate func configureView(){
        view.addSubviews(labelMain, labelDesc)

        labelMain.easy.layout(
            Center()
        )
        labelDesc.easy.layout(
            Top(16).to(labelMain),
            CenterX()
        )
    }
}

