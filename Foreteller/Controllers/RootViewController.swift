//
//  RootViewController.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 12/12/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import Tactile
import EasyPeasy
import CoreLocation
import SVProgressHUD



class RootViewController: UIViewController  {
    
    let locationHelper = LocationHelper()
    fileprivate var controllers = [UIViewController]()
    fileprivate var names = [String]()
    
    fileprivate lazy var pageViewController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
            print("setting datasource")
            $0.dataSource = self
            $0.view.backgroundColor = .white
            self.addChild($0)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removePersistentDomain(forName: "cities")
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        self.handlePermissions()
        self.configureNavbar()
        self.configureViews()
        self.configureConstraints()
        self.pageViewController.didMove(toParent: self)
    }
    
    fileprivate func configureLocationPage(){
        let vc = CityPageViewController()
        vc.delegate = self
        let city = City()
        print("LOCATION SERIVCES ENABLED")
        self.locationHelper.lookUpCurrentLocation(){ loc in
            if let loc = loc as CLPlacemark? {
                print("LOCATION FOUND")
                print(loc.locality)
                city.latitude = loc.location?.coordinate.latitude
                city.longitude = loc.location?.coordinate.longitude
                city.name = loc.locality!
                vc.city = city
                self.controllers.append(vc)
                self.loadCities()
                self.pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
                self.configureCustomPages(withEmpty: false)
            } else {
                SVProgressHUD.dismiss()
                print("ERROR NO LOCATION FOUND")
            }
        }
        
    }
    
    fileprivate func configureCustomPages(withEmpty:Bool){
        loadCities()
        print(self.names)
        if self.names.count != 0{
            print("DISABLED CITIES")
            let serialQueue = DispatchQueue(label: "serialQueue")
            let group = DispatchGroup()
            for name in names {
                serialQueue.async {
                    group.wait()
                    group.enter()
                    DispatchQueue.main.async {
                        let vc = CityPageViewController()
                        vc.delegate = self
                        self.cityByName(name: name) { city in
                            if let city = city {
                                vc.city = city
                                self.controllers.append(vc)
                                if name == self.names.last {
                                    self.pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
                                }
                                group.leave()
                            } else {
                                SVProgressHUD.dismiss()
                                print("No city found")
                                group.leave()
                            }
                        }
                    }
                }
            }
        } else {
            if withEmpty {
                SVProgressHUD.dismiss()
                print("DISABLED SEARCH")
                let vc = EmptyViewController()
                self.controllers.append(vc)
                self.pageViewController.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func configureNavbar(){
        let button: UIButton = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(fbButtonPressed), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        
        let barButton = UIBarButtonItem(customView: button)
        let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 20)
        currWidth?.isActive = true
        let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @objc func fbButtonPressed() {
        let vc = SearchController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func configureViews(){
        view.backgroundColor = .clear
        view.addSubviews(pageViewController.view)
    }
    
    func configureConstraints(){
        pageViewController.view.easy.layout(
            Edges()
        )
    }
    
    fileprivate func handlePermissions(){
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            let alertController = UIAlertController(title: "Location Permission Required", message: "We need location permissions to show weather for current location.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(cAlertAction) in
                self.locationHelper.askPermission(){ res in
                    print(res.debugDescription)
                    if let res = res {
                        switch res {
                        case .authorizedAlways, .authorizedWhenInUse:
                            print("1")
                            self.configureLocationPage()
                            self.configureCustomPages(withEmpty: false)
                        case .notDetermined:
                            print("NOT DETERMINED!!!")
                        case .restricted, .denied:
                            self.configureCustomPages(withEmpty: true)
                        }
                    } else {
                        print("NOT RESULT")
                    }
                }
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if status == .denied || status == .restricted {
            print("2")
            self.configureCustomPages(withEmpty: true)
        } else {
            print("3")
            self.locationHelper.startUpdating()
            self.configureLocationPage()
        }
        SVProgressHUD.show()
    }
    
    fileprivate func saveCities() {
        Globals.defaults.set(self.names, forKey: "cities")
    }
    
    fileprivate func loadCities() {
        let data  = Globals.getCities()
        if let cities = data{
            self.names = cities
        }
    }
    
    fileprivate func cityByName(name:String, completion: @escaping (City?) -> ()){
        let geoCoder = CLGeocoder()
        let city = City()
        geoCoder.geocodeAddressString(name) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                    print("no location found")
                    return
            }
            city.latitude = location.coordinate.latitude
            city.longitude = location.coordinate.longitude
            city.name = name
            print("\(name) \(location.coordinate.latitude) \(location.coordinate.longitude)")
            completion(city)
        }
    }
}

extension RootViewController : SearchControllerDelegate{
    func addCity(name:String){
        if !self.names.contains(name){
            self.names.append(name)
            saveCities()
            let vc = CityPageViewController()
            vc.delegate = self
            cityByName(name: name) { city in
                if let city = city {
                    vc.city = city
                    self.controllers.append(vc)
                    self.pageViewController.dataSource = nil
                    self.pageViewController.dataSource = self
                    self.pageViewController.setViewControllers([self.controllers[self.controllers.index(of:vc)!]],
                                                               direction: .forward, animated: true, completion: nil)
                    print("saved")
                } else {
                    print("No city found")
                }
            }
            
        }
        print(self.names)
    }
}

extension RootViewController : CitiesTableViewControllerDelegate {
    func removeCity(name: String, completion: @escaping (Bool?) -> ()){
        print("REMOVING")
        self.names = self.names.filter({ $0 != name})
//        var vc = CityPageViewController()
//        for cont in self.controllers {
//            if let cityCont = cont as? CityPageViewController{
//                if cityCont.city?.name == name {
//                    print("\(cityCont.city?.name) is equal \(name)")
//                    print(self.names)
//                    vc = cityCont
//                    result = true
//                }
//            }
//        }
        self.controllers = self.controllers.filter({ ($0 as! CityPageViewController).city!.name != name })
        self.pageViewController.setViewControllers([self.controllers.first!], direction: .forward, animated: true, completion: { _ in
            DispatchQueue.main.async {
                self.pageViewController.setViewControllers([self.controllers.first!], direction: .forward, animated: false, completion: { res in
                    completion(true)
                })
            }
            
        })
    
        saveCities()
    }
}

extension RootViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.controllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard self.controllers.count > previousIndex else { return nil }
        
        return self.controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.controllers.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < self.controllers.count else { return nil }
        
        return self.controllers[nextIndex]
    }

}
