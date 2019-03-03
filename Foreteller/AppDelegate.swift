//
//  AppDelegate.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 12/12/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import Sugar
import GooglePlaces
import SVProgressHUD
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let nav = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds).then {
            $0.backgroundColor = .white
        }
        SVProgressHUD.setDefaultMaskType(.black)
        GMSPlacesClient.provideAPIKey("AIzaSyAnbcnEMYptMRnjFcxDsuYuxonGnAsXTfA")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.controlFlow()

        return true
    }
    
    func controlFlow(){
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { status in
            switch status {
                case .notReachable:
                    print("The network is not reachable")
                    self.toNoInternetViewController()

                case .unknown :
                    print("It is unknown whether the network is reachable")
                    self.toNoInternetViewController()

                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")
                    self.toRootViewController()

                case .reachable(.wwan):
                    print("The network is reachable over the WWAN connection")
                    self.toRootViewController()
            }
        }
    }
    //comment
    func toRootViewController(){
        let mainView = RootViewController()
        nav.viewControllers = [mainView]
        self.window!.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func toNoInternetViewController(){
        let mainView = NoInternetViewController()
        nav.viewControllers = [mainView]
        self.window!.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }

}

