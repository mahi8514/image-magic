//
//  FeedsNavigation.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import SwiftUI

//Conform to navigatable protocol - navigation in future
struct FeedsCoordinator: View {
    
    //Create Navigation enum with destination views and its dependencies  - navigation in future.
    //Create path variable which is of type array of Navigation - navigation in future.
    
    var body: some View {
        //Use patch variable in NavigationStack - navigation in future.
        NavigationStack {
            rootView
        }
    }
    
    @ViewBuilder private var rootView: some View {
        
        // Composition root
        
        let feedsRepository = DefaultFeedsRepository(localDataStore: DefaultFeedsLocalDataSource(),
                                                     remoteDataSource: DefaultFeedRemoteDataSource())
        let observeFeedsUseCase = DefaultObserveFeedsUseCase(feedsRepository: feedsRepository)
        let refreshFeedsUseCase = DefaultRefreshFeedsUseCase(feedsRepository: feedsRepository)
        
        FeedListView(viewModel: .init(observeFeedsUseCase: observeFeedsUseCase, refreshFeedsUseCase: refreshFeedsUseCase))
    }
    
}
