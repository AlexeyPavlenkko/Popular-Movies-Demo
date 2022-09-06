//
//  ApiService.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 05.09.2022.
//

import Foundation

enum ApiServiceErrors: LocalizedError {
    case emptyResponse
    case emptyData
    case urlIsNotValid
    
    var errorDescription: String? {
        switch self {
        case .emptyResponse: return "Response from server is not valid"
        case .emptyData:     return "No data from response"
        case.urlIsNotValid:  return "Provided url is not valid"
        }
    }
}

protocol ApiServiceProtocol {
    func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void)
    func getImageDataFrom(url: URL, completion: @escaping ((Data?) -> Void))
}

class ApiService: ApiServiceProtocol {
    
    private var dataTask: URLSessionDataTask?
    
    //MARK: - Get popular movies data
    func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=87db726043635956ebb8cde640e28a2f&language=en-US&page=4"
        
        guard let url = URL(string: popularMoviesURL) else {
            completion(.failure(ApiServiceErrors.urlIsNotValid))
            return
        }
        
        //Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTast error: \(error.localizedDescription)")
            }
            
            guard let httpresponse = response as? HTTPURLResponse else {
                //Handle Empty Response
                completion(.failure(ApiServiceErrors.emptyResponse))
                print("Empty Response")
                return
            }
            print("Response status code: \(httpresponse.statusCode)")
            
            guard let data = data else {
                //Handle Empty Data
                completion(.failure(ApiServiceErrors.emptyData))
                print("Empty Data")
                return
            }
            
            do {
                //Parse the data
                let moviesData = try JSONDecoder().decode(MoviesData.self, from: data)
                completion(.success(moviesData))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    //MARK: - Get image data
    func getImageDataFrom(url: URL, completion: @escaping ((Data?) -> Void)) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Handle Error
            if let error = error {
                print("DataTast error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                //Handle Empty Data
                print("Empty Data")
                completion(nil)
                return
            }
            completion(data)
            
        }.resume()
    }
    
}
