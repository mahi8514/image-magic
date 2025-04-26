//
//  DefaultFeedsRepository.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

final class DefaultFeedsRepository: FeedsRepository {
    
    let localDataStore: FeedLocalDataSource
    let remoteDataSource: FeedRemoteDataSource
    
    init(localDataStore: FeedLocalDataSource, remoteDataSource: FeedRemoteDataSource) {
        self.localDataStore = localDataStore
        self.remoteDataSource = remoteDataSource
    }
    
    func observeFeeds() -> FeedsAsyncStream {
        localDataStore.observeFeeds()
    }
    
    func fetchAndStoreFeeds(page: Int, resetCache: Bool) async throws {
        let feeds = try await remoteDataSource.fetchFeeds(page: page)
        try await localDataStore.save(feeds, resetCache: resetCache)
    }
    
}
