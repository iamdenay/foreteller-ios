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
    
    required init(colors: [CGColor]){
        super.init(frame: CGRect.zero)
        setColors(colors: colors)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColors(colors: [CGColor]){
        layer0 = self.layer as? CAGradientLayer
        layer0.colors = colors
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.5, y: 0)
        layer0.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
