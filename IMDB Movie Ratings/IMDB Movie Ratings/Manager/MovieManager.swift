//
//  MovieManager.swift
//  IMDB Movie Ratings
//
//  Created by Prahash Barman on 01/02/23.
//

import Foundation
import UIKit

class MovieManager {
    
    static let shared = MovieManager()
    private let httpUtility = HttpUtility()
    private let searchValidator = SearchEntryValidator()
    private init(){}
    
    func getSearchResults(for query: String, completionHandler: @escaping([Movie], MovieSearchError?) -> Void) {
        
        var movies: [Movie] = []
        
        let requestHeaders: [String:String] = ["X-RapidAPI-Key" : RequestHeaderKeys.rapidApiKey,
                                               "X-RapidAPI-Host": RequestHeaderKeys.rapidApiHost]
        let imdbRequst: URLRequestModel = URLRequestModel(urlString: URLStrings.imdbRatings, requestHeaders: requestHeaders)
        var queries: [URLQueryItem] = []
        if searchValidator.validate(query: query) {
            queries = [URLQueryItem(name: "q", value: query)]
        }
        let urlRequest: URLRequest = imdbRequst.urlRequest
        
        httpUtility.getApiData(requestUrl: urlRequest, requestBody: nil, queries: queries) { (searchResult:MovieSearchDictionary?, error: Error?) in
            if let searchResult = searchResult {
                for movie in searchResult.dict {
                    movies.append(movie)
                }
                completionHandler(movies, nil)
            } else if error != nil {
                debugPrint("Error in network call: \(String(describing: error?.localizedDescription))")
                completionHandler([], .NetworkError)
            }
        }
    }
    
    func getMovieBanner(for imageUrl: String, completionHandler: @escaping(UIImage?) -> Void) {
        
        //Quality 1 (out of 1-100) and Compress to 40 in X dimension
        let urlString = imageUrl + "_QL1_SX40"
        let urlRequest: URLRequest = URLRequest(url: URL(string: urlString)!)
        
        httpUtility.downloadData(requestUrl: urlRequest, requestBody: nil, queries: nil) { imageData in
            let image = UIImage(data: imageData)
            completionHandler(image)
        }
    }
}

struct SearchEntryValidator {
    
    func validate(query: String) -> Bool {
        if (query.count > 4) {
            return true
        }
        return false
    }
}
