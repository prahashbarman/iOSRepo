//
//  MovieCell.swift
//  IMDB Movie Ratings
//
//  Created by Himangshu Barman on 01/02/23.
//

import UIKit

protocol MovieCellDelegate {
    func saveImageToCache(title: String, image: UIImage)
}

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var yearReleasedLabel: UILabel!
    @IBOutlet weak var movieBanner: UIImageView!
    
    var delegate: MovieCellDelegate?
    
    //Update data with the view model
    func updateCell(with viewModel: MovieViewModel, image: UIImage? = nil) {
        titleLabel.text = viewModel.title
        rankLabel.text = "Rank: " + ((viewModel.rank == 0) ? "N/A" : "\(viewModel.rank)")
        yearReleasedLabel.text = "Year: " + ((viewModel.releaseYear == 0) ? "N/A" : "\(viewModel.releaseYear)")
        guard let urlString = viewModel.image?.imageUrl else {
            self.movieBanner.image = UIImage()
            return
        }
        
        if let image = image {
            DispatchQueue.main.async {
                self.movieBanner.image = image
            }
        } else {
            MovieManager.shared.getMovieBanner(for: urlString) { image in
                DispatchQueue.main.async {
                    let image: UIImage = image?.scalePreservingAspectRatio(targetSize: CGSize(width: 112, height: 140)) ?? UIImage()
                    self.movieBanner.image = image
                    self.delegate?.saveImageToCache(title: viewModel.title, image: image)
                }
            }
        }
    }
}
