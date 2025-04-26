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
            .navigationTitle("Viral feeds")
            .alert(isPresenting: $viewModel.isPresentingAlert, item: $viewModel.alertItem)
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack {
                feedListView
            }
            .padding()
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
    
    private var feedListView: some View {
        ForEach(viewModel.feeds, id: \.self) { feed in
            VStack {
                HStack {
                    Text(feed.title)
                        .lineLimit(1)
                    Spacer()
                }
                Divider()
            }
            .onAppear {
                if feed == viewModel.feeds.last {
                    print("Total item: \(viewModel.feeds.count)")
                    Task { await viewModel.fetchData(reset: false) }
                }
            }
        }
    }
}
