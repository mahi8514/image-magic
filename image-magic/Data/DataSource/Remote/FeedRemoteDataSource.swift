//
//  FeedRemoteDataSource.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

protocol FeedRemoteDataSource {
    func fetchFeeds(page: Int) async throws -> [Feed]
}

final class DefaultFeedRemoteDataSource: FeedRemoteDataSource {
    
    let remoteStore: FeedRemoteStore
    
    init(remoteStore: FeedRemoteStore) {
        self.remoteStore = remoteStore
    }
    
    func fetchFeeds(page: Int) async throws -> [Feed] {
        try await remoteStore.feeds(page: page).data ?? []
    }
    
}
