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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    FeedListView(viewModel: .init())
}
