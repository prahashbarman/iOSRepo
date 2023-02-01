//
//  MovieViewModel.swift
//  IMDB Movie Ratings
//
//  Created by Prahash Barman on 01/02/23.
//

import Foundation

protocol MovieViewModelDelegate {
    func didReceiveMovieResult(result: [MovieViewModel], error: MovieSearchError?)
}

enum MovieSearchError {
    case NoResult
    case NetworkError
    case ParsingError
}

struct MovieSearchResultViewModel {
    
    var delegate: MovieViewModelDelegate?
    var movieData: [MovieViewModel]
    
    func searchMovie(with query: String) {
        
        MovieManager.shared.getSearchResults(for: query) { (movies: [Movie], error: MovieSearchError?) in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.delegate?.didReceiveMovieResult(result: [], error: error)
                }
                return
            }
            
            var searchResults: [MovieViewModel] = []
            
            for movie in movies {
                let model = MovieViewModel(image: movie.image, title: movie.title, rank: movie.rank ?? 0, releaseYear: movie.year ?? 0)
                searchResults.append(model)
            }
            
            DispatchQueue.main.async {
                self.delegate?.didReceiveMovieResult(result: searchResults, error: nil)
            }
        }
    }
}

struct MovieViewModel {
    let image: MovieImage?
    let title: String
    let rank: Int
    let releaseYear: Int
}

