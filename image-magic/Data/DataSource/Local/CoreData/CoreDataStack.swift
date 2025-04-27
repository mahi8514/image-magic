//
//  PersistenceContainer.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() { }
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ImageMagicModel")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
}
