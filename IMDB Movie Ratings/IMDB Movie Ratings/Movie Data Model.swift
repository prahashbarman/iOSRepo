//
//  Movie Data Model.swift
//  IMDB Movie Ratings
//
//  Created by Himangshu Barman on 01/02/23.
//

import Foundation

struct Movie : Decodable {
    let title: String
    let id: String
    let year: Int?
    let rank: Int?
    let image: MovieImage?
    
    enum CodingKeys: String, CodingKey {
        case title = "l"
        case id
        case year = "y"
        case rank
        case image = "i"
    }
}

struct MovieImage : Decodable {
    let height: Int
    let width: Int
    let imageUrl: String
}

struct MovieSearchDictionary : Decodable {
    let dict : [Movie]
    
    enum CodingKeys: String, CodingKey {
        case dict = "d"
    }
}
