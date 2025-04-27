//
//  FeedListViewModel.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import SwiftUI

final class FeedListViewModel: ViewModel {
    
    let observeFeedsUseCase: ObserveFeedsUseCase
    let refreshFeedsUseCase: RefreshFeedsUseCase
    
    init(observeFeedsUseCase: ObserveFeedsUseCase, refreshFeedsUseCase: RefreshFeedsUseCase) {
        self.observeFeedsUseCase = observeFeedsUseCase
        self.refreshFeedsUseCase = refreshFeedsUseCase
    }
    
    @Published private(set) var feeds: [Feed] = []
    private var page: Int = 0
    
    private var observeTask: Task<Void, Never>?
    private var fetchTask: Task<Void, Never>?
    
    override func task() async {
        await super.task()
        observeTask = Task {
            await observeFeeds()
        }
        await fetchData()
    }
    
    private func observeFeeds() async {
        for await feeds in observeFeedsUseCase.execute() {
            if Task.isCancelled {
                print("observe feeds task cancelled. Exiting loop.")
                break
            }
            if page == 0 {
                self.feeds.removeAll()
            }
            self.feeds = feeds
        }
    }
    
    func fetchData(reset: Bool = true) async {
        fetchTask?.cancel()
        fetchTask = Task {
            await fetchFeeds(reset: reset)
        }
    }
    
    private func fetchFeeds(reset: Bool) async {
        isLoading = true
        defer {
            isLoading = false
        }
        if reset {
            page = 0
        }
        do {
            try await refreshFeedsUseCase.execute(page: page, resetCache: page == 0)
            self.page += 1
        } catch {
            alertItem = .init(title: "Something went wrong", message: "Unable to fetch feeds. Please try again later.", actions: nil)
            isPresentingAlert = true
        }
    }
    
    deinit {
        observeTask?.cancel()
    }
    
}
