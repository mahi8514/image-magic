//
//  AsyncCoreDataFeedStream.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import CoreData

protocol AsyncCoreDataFeedStream {
    func observeFeeds() -> FeedsAsyncStream
}

final class AsyncCoreDataFeedStreamImpl: NSObject {
    
    private let viewContext: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<FeedEntity>!
    private var continuation: FeedsAsyncStream.Continuation?
    
    lazy var stream: FeedsAsyncStream = {
        AsyncStream { (continuation: FeedsAsyncStream.Continuation) -> Void in
            self.continuation = continuation
        }
    }()
    
    override init() {
        self.viewContext = CoreDataStack.shared.persistentContainer.viewContext
        super.init()
        setupFetchController()
        destroyContinuationOnTermination()
    }
    
    private func setupFetchController() {
        let fetchRequest: NSFetchRequest<FeedEntity> = FeedEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FeedEntity.datetime, ascending: false)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    private func destroyContinuationOnTermination() {
        self.continuation?.onTermination = { result in
            print(result)
            self.continuation = nil
        }
    }
}

extension AsyncCoreDataFeedStreamImpl: AsyncCoreDataFeedStream {
    func observeFeeds() -> FeedsAsyncStream {
        AsyncStream { continuation in
            self.continuation = continuation
            if let fetchedObjects = self.fetchedResultsController.fetchedObjects {
                let feeds = fetchedObjects.compactMap(\.feed)
                continuation.yield(feeds)
            }
        }
    }
}

extension AsyncCoreDataFeedStreamImpl: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return }
        continuation?.yield(fetchedObjects.compactMap(\.feed))
    }
    
}
