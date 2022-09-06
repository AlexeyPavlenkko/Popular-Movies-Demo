//
//  AssemblyBuilder.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 05.09.2022.
//

import UIKit

protocol AssemblyBuilder {
    func createSplashScreenWith(apiService: ApiServiceProtocol) -> UIViewController
    func createMovieListVC() -> UIViewController
    func createMovieDetailsVC(with movie: MovieEntity) -> UIViewController
}

class MainAssemblyBuilder {
    func createSplashScreenWith(apiService: ApiServiceProtocol) -> UIViewController {
        let splashVC = SplashScreenViewController.instantiate() as! SplashScreenViewController
        splashVC.apiService = apiService
        return splashVC
    }
    
    func createMovieListVC() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.navigationItem.largeTitleDisplayMode = .always
        let movieListVC = MovieListViewController.instantiate()
        navigationController.viewControllers = [movieListVC]
        return navigationController
    }
    
    func createMovieDetailsVC(with movie: MovieEntity) -> UIViewController {
        let movieDetailsVC = MovieDetailsViewController.instantiate() as! MovieDetailsViewController
        movieDetailsVC.movie = movie
        return movieDetailsVC
    }
}
