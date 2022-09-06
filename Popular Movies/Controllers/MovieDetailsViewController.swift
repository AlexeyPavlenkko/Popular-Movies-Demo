//
//  MovieDetailsViewController.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 06.09.2022.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieRateLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    //MARK: - Variables
    var apiService: ApiServiceProtocol = ApiService()
    var movie: MovieEntity!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    //MARK: - Methods
    private func updateUI() {
        movieTitleLabel.text = movie.title
        movieRateLabel.text = movie.rate
        movieReleaseDateLabel.text = movie.year
        movieOverviewLabel.text = movie.overview
        
        guard let posterString = movie.posterImage ,let posterImageURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterString) else {
            moviePosterImageView.image = UIImage(named: "noImageAvailable")
            return
        }
        
        apiService.getImageDataFrom(url: posterImageURL) { [weak self] data in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.moviePosterImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.moviePosterImageView.image = UIImage(named: "noImageAvailable")
                }
            }
        }
        
        configureViews()
    }
    
    //Views attributes
    private func configureViews() {
        //Movie Rate
        movieRateLabel.layer.masksToBounds = true
        movieRateLabel.layer.cornerRadius = 10
    }

}

//MARK: - Storyboarded
extension MovieDetailsViewController: Storyboarded {
    static var storyboardName: String {
        "Main"
    }
    
    static var identifier: String {
        "MovieDetailsViewController"
    }
}
