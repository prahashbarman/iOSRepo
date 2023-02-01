//
//  URLRequestModel.swift
//  IMDB Movie Ratings
//
//  Created by Himangshu Barman on 01/02/23.
//

import Foundation

struct URLRequestModel {
    let urlString: String
    let requestHeaders: [String:String]
    var urlRequest: URLRequest {
        get {
            var request = URLRequest(url: URL(string: urlString)!)
            for (header, param) in requestHeaders {
                request.setValue(param, forHTTPHeaderField: header)
            }
            return request
        }
    }
}
