//
//  ForecastTableViewCell.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 1/12/19.
//  Copyright © 2019 IcyFlame Studios. All rights reserved.
//

import UIKit
import Reusable
import EasyPeasy

class ForecastTableViewCell: UITableViewCell, Reusable {
    
    fileprivate lazy var imageWeather: UIImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "cloudy")
    }
    
    fileprivate lazy var labelDay = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    fileprivate lazy var labelTempMax = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    fileprivate lazy var labelTempMin = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViews() {
        contentView.addSubviews(imageWeather, labelDay, labelTempMin, labelTempMax)
    }
    
    fileprivate func configureConstraints() {
        labelDay.easy.layout(
            Left(16),
            CenterY()
        )
        imageWeather.easy.layout(
            Center(),
            Height(20),
            Width(20)
        )
        labelTempMin.easy.layout(
            CenterY(),
            Right(16)
        )
        labelTempMax.easy.layout(
            CenterY(),
            Right(24).to(labelTempMin)
        )
    }
    
    func configure(day:String, weather:String, min:Int, max:Int) {
        labelDay.text = day
        imageWeather.image = Globals.imageByWeather[weather]
        labelTempMax.text = String(describing: max)
        labelTempMin.text = String(describing: min)
    }
   
}
