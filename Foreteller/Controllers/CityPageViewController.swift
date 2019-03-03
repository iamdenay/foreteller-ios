//
//  DataViewController.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 12/12/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import EasyPeasy
import SVProgressHUD
import ChameleonFramework

class CityPageViewController: UIViewController {
    var delegate : CitiesTableViewControllerDelegate?
    var index = 0
    var scrollView = UIScrollView()
    var containerView = UIView()
    var city : City? {
        didSet {
            print("DIDSET")
            self.loadData()
        }
    }
    fileprivate var colors = Globals.colorsCloudyPartly
    fileprivate var forecasts = [Forecast]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK UI
    
    fileprivate lazy var topView = GradientView(colors: self.colors)
    
    fileprivate lazy var tableView : UITableView = {
        return UITableView().then {
            $0.register(cellType: ForecastTableViewCell.self)
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.backgroundColor = .clear
        }
    }()
    
    fileprivate var imageWeather = UIImageView()
    
    fileprivate var containerWeather = UIView()
    
    fileprivate var labelWeatherShort = UILabel().then{
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .white
    }
    
    lazy var labelCityName = UILabel().then {
        $0.text = "--"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    lazy var labelTempMain = UILabel().then {
        $0.text = ""
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    
    lazy var labelTempMax = UILabel().then {
        $0.text = ""
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var labelTempMin = UILabel().then {
        $0.text = ""
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var labelToday = UILabel().then {
        $0.text = ""
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var labelSummary = UILabel().then {
        $0.text = ""
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.numberOfLines = 0
        $0.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    fileprivate lazy var bottomView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEWDIDLOAD")
        configureView()
        configureTopView()
        configureBottomView()
        loadData()
    }
    
    //MARK Load data
    
    fileprivate func loadData(){
        if let lat = self.city?.latitude, let lon = self.city?.longitude, let name = self.city?.name {
            Repository().getPopular(lat:lat,lon:lon){ res,error in
                if let res = res {
                    self.labelCityName.text = name
                    self.labelToday.text = "Today"
                    let current = res.currently
                    if var daily = res.daily{
                        daily.remove(at: 0)
                        self.forecasts = daily
                    }
                    let today = res.daily?[0]
                    if let summary = current?.summary {
                        self.labelWeatherShort.text = summary
                    }
                    if let temperature = current?.temperature{
                        self.labelTempMain.text = String(describing:temperature) + "°"
                    }
                    if let tempMax = today?.temperatureMax{
                        self.labelTempMax.text = String(describing: tempMax)
                    }
                    if let tempMin = today?.temperatureMin{
                        self.labelTempMin.text = String(describing: tempMin)
                    }
                    if let todaySummary = today?.summary{
                        self.labelSummary.text = todaySummary
                    }
                    if let icon = today?.icon{
                        self.imageWeather.image = Globals.imageByWeather[icon]
                        self.topView.setColors(colors: Globals.colorsByWeather[icon]!)
                    }
                    SVProgressHUD.dismiss()
                } else {
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("empty city")
        }
        
    }
    
    fileprivate func configureView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(topView, bottomView)
        scrollView.easy.layout(
            Edges()
        )
        containerView.easy.layout(
            Top(),
            Bottom(),
            Left().to(self.view, .left),
            Right().to(self.view, .right)
        )
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
            Bottom(0),
            Height().like(topView)
        )
    }
    
    fileprivate func configureTopView(){
        topView.addSubviews(labelCityName, containerWeather, labelWeatherShort, labelToday,
                            labelTempMax, labelTempMin, labelSummary)
        
        containerWeather.addSubviews(imageWeather, labelTempMain)
        
        
        labelCityName.easy.layout(
            Top(64),
            CenterX()
        )
        
        containerWeather.easy.layout(
            Top(46).to(labelCityName, .bottom),
            CenterX()
        )
        
        imageWeather.easy.layout(
            Top(),
            Left(),
            Right(8).to(labelTempMain),
            Bottom(),
            Height(48),
            Width(48)
        )
        
        labelTempMain.easy.layout(
            CenterY(0).to(imageWeather),
            Left(8).to(imageWeather, .right),
            Right()
        )
        
        labelWeatherShort.easy.layout(
            Top(16).to(containerWeather, .bottom),
            CenterX()
        )
        
        labelToday.easy.layout(
            Top(32).to(labelWeatherShort),
            Left(16)
        )
        
        labelTempMin.easy.layout(
            Top(0).to(labelToday, .top),
            Right(16)
        )
        
        labelTempMax.easy.layout(
            Top().to(labelToday, .top),
            Right(24).to(labelTempMin, .left)
        )
        
        labelSummary.easy.layout(
            Top(12).to(labelToday, .bottom),
            Right(16),
            Left(16),
            Bottom(16)
        )
    }
    
    fileprivate func configureBottomView(){
        bottomView.addSubviews(tableView)
        tableView.easy.layout(
            Top(16),
            Left(),
            Right(),
            Bottom(16)
        )
    }
}

extension CityPageViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ForecastTableViewCell
        let today = forecasts[indexPath.row]
        if let timestamp = today.time, let weather = today.icon, let min = today.temperatureMin, let max = today.temperatureMax {
            let date = Date(timeIntervalSince1970: timestamp)
            let day = dayOfWeek(for: date)
            cell.configure(day: day, weather: weather, min: min, max: max)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 7
    }
    
    func dayOfWeek(for date:Date) -> String {
        let customDateFormatter = DateFormatter()
        return customDateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
    }
}

