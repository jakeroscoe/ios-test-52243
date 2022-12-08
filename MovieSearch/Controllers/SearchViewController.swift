//
//  ViewController.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/7/22.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    struct TableView {
        struct CellIdentifiers {
            static let movieCell = "MovieCell"
            static let noResultsCell = "NoResults"
        }
    }
    
    var searchResults: [SearchResult] = []
    var hasSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 46, left: 0, bottom: 0, right: 0)

        var cellNib = UINib(nibName: TableView.CellIdentifiers.movieCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.movieCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.noResultsCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.noResultsCell)
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
}

// MARK: - Search Bar Delegate Methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResults = []
        
        if searchBar.text! != "justin bieber" {
            for i in 1...3 {
                let searchResult = SearchResult()
                searchResult.title = searchBar.text!
                searchResult.year = String(format: "Fake result %d for '\(searchResult.title)'", i)
                searchResults.append(searchResult)
            }
        }
        
        hasSearched = true
        tableView.reloadData()
        searchBar.text! = ""
        searchBar.resignFirstResponder()
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("text is changing: '\(searchBar.text!)'")
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - Table View Delegate/Data Source Methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.noResultsCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.movieCell, for: indexPath) as! MCTableViewCell
            let searchResult = searchResults[indexPath.row]
            cell.titleLabel.text = searchResult.title
            cell.yearLabel.text = searchResult.year
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // only able to select rows when they exist
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}

