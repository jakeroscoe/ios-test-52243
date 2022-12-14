//
//  MovieDetail.swift
//  MovieSearch
//
//  Created by Anthony Rubbo on 12/13/22.
//

import Foundation

struct MovieDetail: Codable {
    let Plot: String
    let Rated: String
    let Ratings: [Rating]?
}

struct Rating: Codable {
    let Value: String?
}
