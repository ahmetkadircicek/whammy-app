//
//  DataPersistenceManager.swift
//  Whammy
//
//  Created by Ahmet on 21.06.2023.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedtoSaveData
        case failedtoFetchData
        case failedToDeleteData
    }
    
    
    static let shared = DataPersistenceManager()
    
    func addCartGuitarWith(model: Guitar, completion: @escaping (Result<Void, Error>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = GuitarItem(context: context)
        
        item.id = Int64(model.id)
        item.posterPath = model.posterPath
        item.model = model.model
        item.onSale = model.onSale
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedtoSaveData))
        }
    }
    
    func fetchingGuitarsFromDataBase(completion: @escaping (Result<[GuitarItem], Error>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<GuitarItem>
        
        request = GuitarItem.fetchRequest()
        
        do {
            
            let guitars = try context.fetch(request)
            completion(.success(guitars))
            
        } catch {
            completion(.failure(DatabaseError.failedtoFetchData))
        }
    }
    
    func deleteGuitarWith(model: GuitarItem, completion: @escaping (Result<Void, Error>) -> Void)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
        
    }
}

