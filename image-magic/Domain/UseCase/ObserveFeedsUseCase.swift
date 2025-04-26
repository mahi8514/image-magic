//
//  ObserveFeedsUseCase.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

protocol ObserveFeedsUseCase {
    func execute() -> FeedsAsyncStream
}

final class DefaultObserveFeedsUseCase: ObserveFeedsUseCase {
    
    let feedsRepository: FeedsRepository
    
    init(feedsRepository: FeedsRepository) {
        self.feedsRepository = feedsRepository
    }
    
    func execute() -> FeedsAsyncStream {
        feedsRepository.observeFeeds()
    }
    
}
