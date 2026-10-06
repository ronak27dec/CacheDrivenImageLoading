//
//  ImageListView.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import SwiftUI

struct ImageListView: View {
    @StateObject private var viewModel: ImageListViewModel
    
    init(viewModel: ImageListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .task {
                await viewModel.fetchImages()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                
            case .error(let message):
                Text(message)
                
            case .loaded(let images):
                ScrollView {
                    LazyVStack {
                        ForEach(images) { item in
                            CachedAsyncImage(url: URL(string: item.url)!, viewModel: viewModel)
                        }
                    }
                    .padding(30.0)
                }
        }
    }
}
