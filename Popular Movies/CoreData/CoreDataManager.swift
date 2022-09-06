//
//  CoreDataManager.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 05.09.2022.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    //MARK: - Stack
    //Create NSPersistentContainer
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Popular_Movies")
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    //Create ViewContex from CoreData
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //Standart Fetch Request
    private let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
    
    //MARK: - CRUD
    
    //Save Movie from server to CoreData
    private func saveMoviesToCoreData(movies: [Movie], context: NSManagedObjectContext) {
        context.perform {
            for movie in movies {
                let movieEntity = MovieEntity(context: self.viewContext)
                movieEntity.title = movie.title
                movieEntity.year = movie.year
                movieEntity.rate = String(movie.rate ?? 0)
                movieEntity.posterImage = movie.posterImage
                movieEntity.backdropImage = movie.backdropImage
                movieEntity.overview = movie.overview
            }
            
            do {
                try context.save()
            } catch {
                fatalError("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
    
    //Delete Core Data Objects before saving new data
    private func deleteObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            let objects = try context.fetch(fetchRequest)
            _ = objects.map { context.delete($0) }
            try context.save()
        } catch {
            fatalError("Failed to delete objects: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Save Movies
    
    public func saveDataOf(movies: [Movie]) {
        //Updates CoreData with the new data from the server - Off the main thread
        persistentContainer.performBackgroundTask { [weak self] context in
            self?.deleteObjectsFromCoreData(context: context)
            self?.saveMoviesToCoreData(movies: movies, context: context)
        }
    }
    
    //MARK: - FetchedResultsController
    
    //Get fetchedResultsController From CoreData
    public func fetchedResultsController(with sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \MovieEntity.rate, ascending: false)] ) -> NSFetchedResultsController<MovieEntity> {
        //creates fetch request
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = sortDescriptors
        return NSFetchedResultsController<MovieEntity>(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
}
