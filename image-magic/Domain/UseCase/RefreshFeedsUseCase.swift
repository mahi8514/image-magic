//
//  RefreshFeedsUseCase.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

protocol RefreshFeedsUseCase {
    func execute(page: Int, resetCache: Bool) async throws
}

final class DefaultRefreshFeedsUseCase: RefreshFeedsUseCase {
    
    let feedsRepository: FeedsRepository
    
    init(feedsRepository: FeedsRepository) {
        self.feedsRepository = feedsRepository
    }
    
    func execute(page: Int, resetCache: Bool) async throws {
        try await feedsRepository.fetchAndStoreFeeds(page: page, resetCache: resetCache)
    }
    
}
