//
//  MockFeedsRepository.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

@testable import image_magic

final class MockFeedsRepository: FeedsRepository {
    
    struct CallArguments {
        let page: Int
        let resetCache: Bool
    }
    
    var fetchAndStoreFeedsCalledWith: CallArguments?
    var shouldThrowError = false
    
    func observeFeeds() -> image_magic.FeedsAsyncStream {
        .init { continuation in
            continuation.yield([.preview])
        }
    }
    
    func fetchAndStoreFeeds(page: Int, resetCache: Bool) async throws {
        if shouldThrowError {
            throw MockError.someError
        }
        fetchAndStoreFeedsCalledWith = CallArguments(page: page, resetCache: resetCache)
    }
}

enum MockError: Error {
    case someError
}
