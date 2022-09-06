//
//  MovieListViewController.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 05.09.2022.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    private var fetchedResultsController: NSFetchedResultsController<MovieEntity>!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavController()
        setupTableView()
        prepareFetchedResultsController()
    }
    
    //MARK: - Methods
    private func configureNavController() {
        title = "Popular Movies"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.secondaryColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.secondaryColor]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationItem.backButtonTitle = " "
        navigationItem.backBarButtonItem?.tintColor = .secondaryColor
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150
    }
    
    private func prepareFetchedResultsController() {
        fetchedResultsController = CoreDataManager.shared.fetchedResultsController()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            fatalError("Failed to init fetchedResultsController. \(error.localizedDescription)")
        }
    }
    
}

//MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        
        let movieEntity = movie(for: indexPath)
        cell.setCellWith(movieEntity)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movie(for: indexPath)
        let movieDetailsVC = MainAssemblyBuilder().createMovieDetailsVC(with: movie)
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

//MARK: - NSFetchedResultsController Helpers
extension MovieListViewController {
    private var sections: [NSFetchedResultsSectionInfo] {
        return fetchedResultsController.sections ?? []
    }
    
    private func movie(for indexPath: IndexPath) -> MovieEntity {
        return fetchedResultsController.object(at: indexPath)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension MovieListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

//MARK: - Storyboarded
extension MovieListViewController: Storyboarded {
    static var storyboardName: String {
        "Main"
    }
    
    static var identifier: String {
        "MovieListViewController"
    }
}
