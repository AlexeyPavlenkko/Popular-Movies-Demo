//
//  MovieListTableViewCell.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 05.09.2022.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    static let identifier = "movieCell"
    
    @IBOutlet weak var movieBackdrop: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    
    private let baseUrlStringForImage: String = "https://image.tmdb.org/t/p/w300"
    private let apiService: ApiServiceProtocol = ApiService()
    
    //Setup cell with movie
    func setCellWith(_ movie: MovieEntity) {
        updateUI(title: movie.title, rate: movie.rate, overview: movie.overview, backdrop: movie.backdropImage)
    }
    
    //Update UI
    private func updateUI(title: String?, rate: String?, overview: String?, backdrop: String?) {
        movieTitle.text = title
        movieRate.text = rate
        movieOverview.text = overview
        
        guard let backdropString = backdrop, let backdropImageURL = URL(string: baseUrlStringForImage + backdropString) else {
            movieBackdrop.image = UIImage(named: "noImageAvailable")
            return
        }
        
        //Before download need to clear out the old one
        self.movieBackdrop.image = UIImage(systemName: "film")
        self.movieBackdrop.contentMode = .scaleAspectFit
        self.movieBackdrop.preferredSymbolConfiguration = .init(pointSize: 20, weight: .ultraLight)
        
        apiService.getImageDataFrom(url: backdropImageURL) { [weak self] data in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.movieBackdrop.contentMode = .scaleAspectFill
                    self?.movieBackdrop.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.movieBackdrop.contentMode = .scaleAspectFill
                    self?.movieBackdrop.image = UIImage(named: "noImageAvailable")
                }
            }
        }
        
        configureViews()
    }
    
    //Views attributes
    private func configureViews() {
        //Movie Backdrop
        movieBackdrop.layer.cornerRadius = 20
        movieBackdrop.layer.borderWidth = 0.8
        movieBackdrop.layer.borderColor = UIColor.secondaryColor.cgColor
        movieBackdrop.contentMode = .scaleAspectFill
        
        //Movie Rate
        movieRate.layer.masksToBounds = true
        movieRate.layer.cornerRadius = 10
    }
    
    
}
