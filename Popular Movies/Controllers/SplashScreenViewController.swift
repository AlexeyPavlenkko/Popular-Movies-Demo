//
//  SplashScreenViewController.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 05.09.2022.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    var apiService: ApiServiceProtocol!
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        loadPopularMoviesData()
    }

    //MARK: - Methods
    //Load movies with api service
    private func loadPopularMoviesData() {
        //Fetch data from server
        apiService.getPopularMoviesData { [weak self] result in
            switch result {
            case .success(let listOf):
                //Save movies to CoreData
                CoreDataManager.shared.saveDataOf(movies: listOf.movies)
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.goToMoviesListScreen()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.showAlertWith(title: "Could not connect!", message: error.localizedDescription)
                }
                print("Error processing json data: \(error)")
            }
        }
    }

    //Show alertController
    private func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    //Perform transition to the main screen (MoviesListViewController)
    private func goToMoviesListScreen() {
        let moviesListNavController = MainAssemblyBuilder().createMovieListVC()
        moviesListNavController.modalPresentationStyle = .fullScreen
        moviesListNavController.modalTransitionStyle = .crossDissolve
        self.present(moviesListNavController, animated: true)
        
    }
    
}

//MARK: - Storyboarded
extension SplashScreenViewController: Storyboarded {
    static var storyboardName: String {
        "Main"
    }
    
    static var identifier: String {
        "SplashScreenViewController"
    }
}
