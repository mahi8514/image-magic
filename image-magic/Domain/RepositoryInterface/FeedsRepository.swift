//
//  FeedsRepository.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

protocol FeedsRepository {
    func observeFeeds() -> FeedsAsyncStream
    func fetchAndStoreFeeds(page: Int, resetCache: Bool) async throws
}
