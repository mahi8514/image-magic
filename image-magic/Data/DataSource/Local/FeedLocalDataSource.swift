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

final class DefaultFeedsLocalDataSource: FeedLocalDataSource {
    
    let asyncCoreDataFeedStream: AsyncCoreDataFeedStream
    let viewContext: NSManagedObjectContext
    
    init(asyncCoreDataFeedStream: AsyncCoreDataFeedStream) {
        self.asyncCoreDataFeedStream = asyncCoreDataFeedStream
        self.viewContext = CoreDataStack.shared.persistentContainer.viewContext
    }
    
    func observeFeeds() -> FeedsAsyncStream {
        asyncCoreDataFeedStream.observeFeeds()
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
            
            entity.images = NSOrderedSet(array: imageEntities)
        }
    }
}
