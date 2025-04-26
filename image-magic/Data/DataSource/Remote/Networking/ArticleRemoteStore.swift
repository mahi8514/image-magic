//
//  ArticleRemoteStore.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

protocol FeedRemoteStore {
    func feeds(page: Int) async throws -> Response<[Feed]>
}

final class FeedRemoteStoreImpl: APIClient<FeedTargetType>, FeedRemoteStore {
    
    func feeds(page: Int) async throws -> Response<[Feed]> {
        try await request(target: .feeds(page: page))
    }
    
}
