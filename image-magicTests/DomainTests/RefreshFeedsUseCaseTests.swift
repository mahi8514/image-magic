//
//  RefreshFeedsUseCaseTests.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import XCTest
@testable import image_magic

final class DefaultRefreshFeedsUseCaseTests: XCTestCase {
    
    private var useCase: DefaultRefreshFeedsUseCase!
    private var mockFeedsRepository: MockFeedsRepository!

    override func setUp() {
        super.setUp()
        mockFeedsRepository = MockFeedsRepository()
        useCase = DefaultRefreshFeedsUseCase(feedsRepository: mockFeedsRepository)
    }

    override func tearDown() {
        useCase = nil
        mockFeedsRepository = nil
        super.tearDown()
    }

    func testExecute_CallsFetchAndStoreFeeds() async throws {
        let expectedPage = 1
        let expectedResetCache = true
        
        try await useCase.execute(page: expectedPage, resetCache: expectedResetCache)
        
        XCTAssertEqual(mockFeedsRepository.fetchAndStoreFeedsCalledWith?.page, expectedPage)
        XCTAssertEqual(mockFeedsRepository.fetchAndStoreFeedsCalledWith?.resetCache, expectedResetCache)
    }
    
    func testExecute_WhenRepositoryThrows_PropagatesError() async {
        mockFeedsRepository.shouldThrowError = true
        
        do {
            try await useCase.execute(page: 0, resetCache: false)
            XCTFail("Expected error was not thrown")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }
}
