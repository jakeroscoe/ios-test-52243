//
//  ViewController.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/7/22.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    
    var searchResults: [SearchResult] = []
    var hasSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 46, left: 0, bottom: 0, right: 0)
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
                searchResult.name = String(format: "Fake result %d for '\(searchResult.title)'", i)
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
        let cellIdentifier = "SearchResultCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        // get a list content configuration that has preconfigured default styling.
        var content = cell!.defaultContentConfiguration()

        
        if searchResults.count == 0 {
            content.text = "(Nothing found)"
            content.secondaryText = ""
        } else {
            // assign your content to it, customize any other properties
            content.text = "\(searchResults[indexPath.row].name)"
            content.secondaryText = "\(searchResults[indexPath.row].title)"
        }
        // assign it to your view as the current content configuration
        cell!.contentConfiguration = content
        
        return cell!
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

