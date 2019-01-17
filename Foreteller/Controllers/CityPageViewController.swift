//
//  DataViewController.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 12/12/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import EasyPeasy

class CityPageViewController: UIViewController {

    var index = 0
    fileprivate var colorFirst = UIColor(red: 0.94, green: 0.63, blue: 0.63, alpha: 1)
    fileprivate var colorSecond = UIColor(red: 0.94, green: 0.66, blue: 0.24, alpha: 1)
    
    fileprivate lazy var topView = GradientView(colorFirst: self.colorFirst, colorSecond: self.colorSecond)

    
    fileprivate lazy var bottomView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
        }
    }()
    
    fileprivate lazy var dataLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold",size: 18)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.text = "Page \(index)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(topView, bottomView)
        topView.easy.layout(
            Top(0),
            Left(0),
            Right(0),
            Bottom(0).to(bottomView, .top),
            Height().like(bottomView)
        )
        bottomView.easy.layout(
            Top(0).to(topView, .bottom),
            Left(0),
            Right(0),
            Bottom(0)
        )
    }
}

