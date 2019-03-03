//
//  DataViewController.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 12/12/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import EasyPeasy

class EmptyViewController: UIViewController {
    
    fileprivate var backgroundView = GradientView(colors: Globals.colorsSunny)
    
    fileprivate var labelMain = UILabel().then{
        $0.text = "Disabled location?"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        $0.textColor = .darkGray
    }
    
    lazy var labelDesc = UILabel().then {
        $0.text = "Not a problem. Just tap \"+\" to add city."
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    fileprivate func configureView(){
        view.backgroundColor = .darkGray
        view.addSubviews(backgroundView)
        backgroundView.easy.layout(
            Edges()
        )
        backgroundView.addSubviews(labelMain, labelDesc)
        labelMain.easy.layout(
           Center()
        )
        labelDesc.easy.layout(
            Top(16).to(labelMain),
            CenterX()
        )
    }
}

