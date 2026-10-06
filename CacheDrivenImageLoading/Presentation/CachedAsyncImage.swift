//
//  CachedAsyncImage.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 15/02/26.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    @ObservedObject var viewModel: ImageListViewModel
    
    var body: some View {
        content
            .task {
                await viewModel.loadImage(url: url)
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.imageStates[url] ?? .idle {
            case .idle, .loading:
                ProgressView()
                
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                
            case .failed:
                Image(systemName: "photo")
        }
    }
}
