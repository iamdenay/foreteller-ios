//
//  GradientView.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 1/11/19.
//  Copyright © 2019 IcyFlame Studios. All rights reserved.
//

import UIKit
import EasyPeasy

class GradientView: UIView {
    
    private var layer0: CAGradientLayer!
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    lazy var textLabel = UILabel().then {
        $0.text = "CITY NAME"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    required init(colorFirst: UIColor, colorSecond: UIColor){
        super.init(frame: CGRect.zero)
        setColors(colorFirst: colorFirst, colorSecond: colorSecond)
        addSubviews(textLabel)
        textLabel.easy.layout(
            Center()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColors(colorFirst: UIColor, colorSecond: UIColor){
        layer0 = self.layer as? CAGradientLayer
        layer0.colors = [
            colorFirst.cgColor,
            colorSecond.cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.5, y: 0.25)
        layer0.endPoint = CGPoint(x: 0.5, y: 0.75)
    }
}
