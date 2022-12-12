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
    
    func parse(data: Data) -> [Movie] {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(
          SearchResultArray.self, from: data)
          print(result.description)
        return result.Search
      } catch {
        print("Parse JSON Error: \(error)")
        return []
      }
    }

    func showSearchError() {
        let alert = UIAlertController(title: "Oh no!", message: "There was a problem connecting to the network. Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

// MARK: - Search Bar Delegate Methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            
            searchResults = []
            hasSearched = true
            
            let url = omdbURL(searchText: searchBar.text!)
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                } else {
                    if let safeData = data {
                        self.searchResults = self.parse(data: safeData)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        return
                    }
                }
                
                DispatchQueue.main.async {
                    self.hasSearched = false
                    self.tableView.reloadData()
                    self.showSearchError()
                }
            } // completion handler
            
            task.resume()
        }
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
            return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.noResultsCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.movieCell, for: indexPath) as! MCTableViewCell
            let searchResult = searchResults[indexPath.row]
            cell.titleLabel.text = searchResult.Title
            cell.yearLabel.text = searchResult.Year
            cell.posterImageView.kf.setImage(with: URL(string: searchResult.Poster))
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

