//
//  MovieData.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/7/22.
//

import Foundation

struct SearchResultArray: Codable {
    var Search: [Movie]
}

struct Movie: Codable {
    var Title: String
    var Year: String
    var Poster: String
    var imdbID: String
}
