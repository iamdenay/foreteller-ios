//
//  RootViewController.swift
//  Foreteller
//
//  Created by Atabay Ziyaden on 12/12/18.
//  Copyright © 2018 IcyFlame Studios. All rights reserved.
//

import UIKit
import EasyPeasy

class RootViewController: UIViewController {
    
    fileprivate lazy var pageViewController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
            $0.dataSource = self
            $0.view.backgroundColor = .clear
            self.addChild($0)
            $0.setViewControllers([CityPageViewController()], direction: .forward, animated: true, completion: nil)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        self.pageViewController.didMove(toParent: self)
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
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

extension RootViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return CityPageViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return CityPageViewController()
        
    }

}

