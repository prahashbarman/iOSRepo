//
//  HTTP Utility.swift
//  IMDB Movie Ratings
//
//  Created by Prahash Barman on 01/02/23.
//

import Foundation

final class HttpUtility {
    
    func getApiData<T: Decodable>(requestUrl: URLRequest, requestBody: Data?, queries: [URLQueryItem], completionHandler: @escaping(T?, Error?)->Void) {
        var request: URLRequest = requestUrl
        request.httpBody = requestBody
        request.url?.append(queryItems: queries)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, let data = data {
                let allowedCodes = 200...299
                if (allowedCodes.contains(response.statusCode)) {
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(result, nil)
                    }
                    catch let errorInParsing {
                        debugPrint("Error in Http Utility class: \(errorInParsing)")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func downloadData(requestUrl: URLRequest, requestBody: Data?, queries: [URLQueryItem]?, completionHandler: @escaping(Data)->Void) {
        var request: URLRequest = requestUrl
        request.httpBody = requestBody
        if let queries = queries {
            request.url?.append(queryItems: queries)
        }
        
        let task = URLSession.shared.downloadTask(with: request) { url, response, error in
            guard error == nil else {
                return
            }
            
            if let response = response as? HTTPURLResponse, let url = url {
                let allowedCodes = 200...299
                if (allowedCodes.contains(response.statusCode)) {
                    do {
                        let data = try Data(contentsOf: url)
                        completionHandler(data)
                    }
                    catch let errorInParsing {
                        debugPrint("Error in Http Utility class: \(errorInParsing)")
                    }
                }
            }
        }
        
        task.resume()
    }
}
