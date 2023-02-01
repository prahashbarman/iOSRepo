//
//  ViewController.swift
//  IMDB Movie Ratings
//
//  Created by Prahash Barman on 01/02/23.
//

import UIKit

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    private var cache: NSCache<NSString, UIImage> = NSCache()
    private var movieSearchResultViewModel: MovieSearchResultViewModel = MovieSearchResultViewModel(movieData: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSearchResultViewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        guard (textField.text?.count ?? 0 >= 5) else { return }
        
        movieSearchResultViewModel.searchMovie(with: textField.text ?? "")
        
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.tableView.reloadData()
        }
    }
}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSearchResultViewModel.movieData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        let movie = movieSearchResultViewModel.movieData[indexPath.row]
        let image = cache.object(forKey: movie.title as NSString)
        cell.updateCell(with: movie, image: image)
        
        return cell
    }
    
}

extension MovieSearchViewController : MovieViewModelDelegate {
    
    func didReceiveMovieResult(result: [MovieViewModel], error: MovieSearchError?) {
        
        guard error == nil else {
            debugPrint(error.debugDescription)
            return
        }
        
        guard result.count > 0 else {
            let alertController: UIAlertController = UIAlertController(title: "Search Result",
                                                                       message: "No result matched your search criteria. Try searching again with other keywords",
                                                                       preferredStyle: .alert)
            let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(alertAction)
            DispatchQueue.main.async {
                self.textField.text = ""
                self.present(alertController, animated: true)
                self.tableView.reloadData()
            }
            return
        }
        
        movieSearchResultViewModel.movieData = result
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension MovieSearchViewController : MovieCellDelegate {
    func saveImageToCache(title: String, image: UIImage) {
        cache.setObject(image, forKey: title as NSString)
    }
}
