//
//  RatingsViewController.swift
//  Tennis
//
//  Created by Atabay Ziyaden on 04.11.17.
//  Copyright © 2017 IcyFlame Studios. All rights reserved.
//

import UIKit
import Reusable
import EasyPeasy
import Sugar
import Tactile
import SVProgressHUD

protocol CitiesTableViewControllerDelegate
{
    func removeCity(name:String,completion: @escaping (Bool?) -> ())
}

class CitiesTableViewController: UIViewController , UITableViewDataSource {
    
    var delegate: CitiesTableViewControllerDelegate?
    
    
    fileprivate var cities = [String]()
    
    fileprivate lazy var tableView: UITableView = {
        return UITableView().then {
            $0.register(cellType: CityTableViewCell.self)
            $0.dataSource = self
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 64
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.sectionHeaderHeight = 70
            $0.backgroundColor = .clear
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cities = Globals.getCities() ?? [String]()
        configureViews()
        configureConstraints()
    }
    
    fileprivate func configureViews() {
        self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = .white
        navigationItem.title = "Tap to remove city"
        view.addSubviews(tableView)
    }
    
    fileprivate func configureConstraints() {
        tableView.easy.layout(Edges())
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CityTableViewCell
        cell.configure(text: cities[indexPath.row])
        cell.contentView.tap { tap in
            self.delegate?.removeCity(name: self.cities[indexPath.row]) { res in
                if res! {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        return cell
    }
}






