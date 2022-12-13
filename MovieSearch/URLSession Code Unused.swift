//
//  URLSession Code Unused.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/13/22.
//

import Foundation
/*
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


//task.resume()
*/

// --------------------------------------------------------------------------

/*
 func parse(data: Data) -> [Movie] {
   do {
     let decoder = JSONDecoder()
     let result = try decoder.decode(SearchResultArray.self, from: data)
     return result.Search
   } catch {
     print("JSON parsing error: \(error)")
     return []
   }
 }
 */
