import Foundation
import UIKit
import SVProgressHUD
import Tactile
import GooglePlaces
import EasyPeasy

protocol SearchControllerDelegate
{
    func addCity(name:String)
}

class SearchController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var delegate: SearchControllerDelegate?
    var history : [String]?
    var placesClient = GMSPlacesClient.shared()
    
    fileprivate var cities = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let temp = UserDefaults.standard.object(forKey: "history"){
            history = temp as? [String]
        } else {
            history = [String]()
        }
        view.backgroundColor = .white
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.layer.cornerRadius = 18
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.titleView = self.searchController.searchBar
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(cellType: CityTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        
        
    }
    
    // searchBar not presented in viewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        self.searchController.isActive = false
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cities.count != 0 {
            return cities.count
        } else {
            return history!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as CityTableViewCell
        
        let name = self.cities[indexPath.row]
        cell.configure(text: name)
        
        cell.contentView.tap { tap in
            self.delegate?.addCity(name: name.split(",")[0])
            self.searchBarCancelButtonClicked(self.searchController.searchBar)
            self.dismiss(animated: true, completion: nil)
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            placeAutocomplete(text:searchText)
        }else {
            self.cities = [String]()
        }
    }
    
    func placeAutocomplete(text:String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        placesClient.autocompleteQuery(text, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                self.cities = [String]()
                for result in results {
                    self.cities.append(result.attributedFullText.string)
                }
            }
        })
    }
}
