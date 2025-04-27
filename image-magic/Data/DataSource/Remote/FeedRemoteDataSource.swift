//
//  FeedRemoteDataSource.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

protocol FeedRemoteDataSource {
    func fetchFeeds(page: Int) async throws -> [Feed]
}

final class DefaultFeedRemoteDataSource: APIClient<FeedTargetType>, FeedRemoteDataSource {
    
    func fetchFeeds(page: Int) async throws -> [Feed] {
        let response: Response<[Feed]> = try await request(target: .feeds(page: page))
        return response.data ?? []
    }
    
}
