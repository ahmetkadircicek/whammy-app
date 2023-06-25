//
//  APICaller.swift
//  Whammy
//
//  Created by Ahmet on 19.06.2023.
//

import Foundation

struct Constants {
    static let baseURL = "http://localhost:3000"
}

enum APIError: Error{
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()
    
    func getStratocasterGuitars(completion: @escaping (Result<[Guitar], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                var results = try JSONDecoder().decode([Guitar].self, from: data)
                results = results.filter { $0.model == "Stratocaster" }
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getTelecasterGuitars(completion: @escaping (Result<[Guitar], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                var results = try JSONDecoder().decode([Guitar].self, from: data)
                results = results.filter { $0.model == "Telecaster" }
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getJaguarGuitars(completion: @escaping (Result<[Guitar], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                var results = try JSONDecoder().decode([Guitar].self, from: data)
                results = results.filter { $0.model == "Jaguar" }
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getJazzmasterGuitars(completion: @escaping (Result<[Guitar], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                var results = try JSONDecoder().decode([Guitar].self, from: data)
                results = results.filter { $0.model == "Jazzmaster" }
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }

    
    func getUpComingGuitars(completion: @escaping (Result<[Guitar], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                var results = try JSONDecoder().decode([Guitar].self, from: data)
                results = results.filter { $0.onSale == false }
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverGuitars(completion: @escaping (Result<[Guitar], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                var results = try JSONDecoder().decode([Guitar].self, from: data)
                results = results.filter { $0.onSale == true }
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Guitar], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedTogetData))
                return
            }
            
            do {
                let allGuitars = try JSONDecoder().decode([Guitar].self, from: data)
                
                let filteredGuitars = allGuitars.filter { guitar in
                    let model = guitar.model.lowercased()
                    let query = query.lowercased()
                    return model.contains(query)
                }
                
                completion(.success(filteredGuitars))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        
        task.resume()
    }
    
    func getGuitar(with query: Int, completion: @escaping (Result<Guitar, Error>) -> Void) {
        let query = query
        guard let url = URL(string: "\(Constants.baseURL)/guitars") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.failedTogetData))
                return
            }
            do {
                let results = try JSONDecoder().decode([Guitar].self, from: data)
                if let guitar = results.first(where: { $0.id == query }) {
                    completion(.success(guitar))
                } else {
                    completion(.failure(APIError.failedTogetData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
