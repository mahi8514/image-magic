//
//  FeedListView.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import SwiftUI

struct FeedListView: View {
    
    @StateObject var viewModel: FeedListViewModel
    
    var body: some View {
        contentView
            .navigationTitle("Top feeds")
            .alert(isPresenting: $viewModel.isPresentingAlert, item: $viewModel.alertItem)
    }
    
    private var contentView: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVStack {
                    feedListView(size: proxy.size)
                }
            }
            .refreshable {
                await viewModel.fetchData(reset: true)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    private func feedListView(size: CGSize) -> some View {
        ForEach(viewModel.feeds, id: \.self) { feed in
            FeedItemView(feed: feed, size: size)
                .onAppear {
                    if feed == viewModel.feeds.last {
                        print("Total item: \(viewModel.feeds.count)")
                        Task { await viewModel.fetchData(reset: false) }
                    }
                }
        }
    }
}
