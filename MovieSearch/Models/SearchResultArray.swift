//
//  MovieData.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/7/22.
//

import Foundation

class SearchResultArray: Codable, CustomStringConvertible {
//    var count = 0
    var description: String {
        return Search.reduce("") { partialResult, mov in
            partialResult + "\(mov.Title) \(mov.Year) \n"
        }
    }
    var Search: [Movie]
}

struct Movie: Codable {
    var Title: String
    var Year: String
    var Poster: String
    var imdbID: String
}
