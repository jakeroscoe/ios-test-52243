//
//  ViewController.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/7/22.
//

import UIKit
import Alamofire
import Kingfisher

class SearchViewController: UIViewController {
    struct CellIdentifiers {
        static let movieCell = "MovieCell"
        static let noResultsCell = "NoResults"
    }
    
    var searchResults: [Movie] = []
    var hasSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInset = UIEdgeInsets(top: 46, left: 0, bottom: 0, right: 0)

        var cellNib = UINib(nibName: CellIdentifiers.movieCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.movieCell)
        
        cellNib = UINib(nibName: CellIdentifiers.noResultsCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellIdentifiers.noResultsCell)
        
        searchBar.becomeFirstResponder()
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    func omdbURL(searchText: String) -> URL {
        let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!.lowercased()
        let searchUrl = URL(string: "https://www.omdbapi.com/?i=tt3896198&apikey=919af252&&type=movie&s=\(encodedSearch)")
        return searchUrl!
    }
}

// MARK: - Search Bar Delegate Methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            // this will make the cancel button disabled
            
            searchResults = []
            hasSearched = true
            
            let url = omdbURL(searchText: searchBar.text!)

            fetchMovies(for: url)
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // fetch could possibly be performed here on every letter input?
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // keep cancel button enabled
        DispatchQueue.main.async {
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = []
        hasSearched = false
        searchBar.text = ""
        searchBar.becomeFirstResponder()
        tableView.reloadData()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - Table View Delegate/Data Source Methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 1
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.separatorStyle = .none
        if !hasSearched {
            let startSearchIdentifier = "startSearch"
            let startSearch = UITableViewCell(style: .default, reuseIdentifier: startSearchIdentifier)
            startSearch.textLabel!.text = "Enter a movie title above to start your search!"
//            print(startSearch.textLabel!.text!)
            return startSearch
        } else if searchResults.count == 0 {
            let noResults = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.noResultsCell, for: indexPath)
            searchBar.text = ""
            searchBar.becomeFirstResponder()
            return noResults
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.movieCell, for: indexPath) as! MCTableViewCell
            let searchResult = searchResults[indexPath.row]
            cell.titleLabel.text = searchResult.Title
            cell.yearLabel.text = searchResult.Year
            cell.posterImageView.kf.setImage(with: URL(string: searchResult.Poster))
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "goToDetails", sender: indexPath)
    }
    
    // only able to select rows when they exist
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let destinationVC = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let searchResult = searchResults[indexPath.row]
            destinationVC.searchResult = searchResult
        }
    }
}

// MARK: - Alamofire Fetch Request

extension SearchViewController {
    func fetchMovies(for url: URL) {
        AF.request(url).responseDecodable(of: SearchResultArray.self) { response in
            if let error = response.error {
                print("Search error: \(error.localizedDescription)")
                self.searchResults = []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                if let results = response.value?.Search {
                    self.searchResults = results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

