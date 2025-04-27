//
//  FeedLocalDataSource.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import CoreData

protocol FeedLocalDataSource {
    func observeFeeds() -> FeedsAsyncStream
    func save(_ feeds: [Feed], resetCache: Bool) async throws
}

final class DefaultFeedsLocalDataSource: NSObject, FeedLocalDataSource {
    
    private let viewContext: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<FeedEntity>!
    private var continuation: FeedsAsyncStream.Continuation?
    
    private lazy var stream: FeedsAsyncStream = {
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
    
    func observeFeeds() -> FeedsAsyncStream {
        AsyncStream { continuation in
            self.continuation = continuation
            if let fetchedObjects = self.fetchedResultsController.fetchedObjects {
                let feeds = fetchedObjects.compactMap(\.feed)
                continuation.yield(feeds)
            }
        }
    }
    
    func save(_ feeds: [Feed], resetCache: Bool) async throws {
        try await viewContext.perform { [weak self] in
            guard let self else { return }
            if resetCache {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FeedEntity.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try viewContext.execute(deleteRequest)
                viewContext.reset()
            }
            feeds.setFeedsEntity(in: viewContext)
            try viewContext.save()
        }
    }
    
}

extension DefaultFeedsLocalDataSource: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return }
        continuation?.yield(fetchedObjects.compactMap(\.feed))
    }
    
}

extension Array where Element == Feed {
    func setFeedsEntity(in context: NSManagedObjectContext) {
        
        for feed in self {
            let entity = FeedEntity(context: context)
            entity.id = feed.id
            entity.title = feed.title
            entity.feedDescription = feed.description
            entity.datetime = feed.datetime
            entity.views = Int32(feed.views)
            entity.ups = Int32(feed.ups)
            entity.downs = Int32(feed.downs)
            entity.commentCount = Int32(feed.commentCount)
            entity.favoriteCount = Int32(feed.favoriteCount)
            
            var imageEntities: [ImageEntity] = []
            
            for image in feed.images ?? [] {
                let imageEntity = ImageEntity(context: context)
                imageEntity.id = image.id
                imageEntity.title = image.title
                imageEntity.datetime = image.datetime
                imageEntity.size = image.size
                imageEntity.type = image.type.rawValue
                imageEntity.link = image.link
                imageEntity.gifv = image.gifv
                
                imageEntities.append(imageEntity)
            }
            
            entity.images = NSSet(array: imageEntities)
        }
    }
}
