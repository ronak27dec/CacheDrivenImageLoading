//
//  CacheDrivenImageLoadingApp.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import SwiftUI

@main
struct CacheDrivenImageLoadingApp: App {
    var body: some Scene {
        WindowGroup {
            let config = URLSessionConfiguration.default
            let session = UrlSessionManager(configuration: config)
            let dataSource = ImageRepositoryRemoteDataSource(session: session)
            let diskCacheConfig = DiskCacheConfig()
            let memoryCache = MemoryImageCache()
            let diskCache = DiskImageCache(config: diskCacheConfig)
            let repository = ImageRepositoryImpl(dataSource: dataSource,
                                                 memoryCache: memoryCache,
                                                 diskCache: diskCache)
            let useCase = FetchImagesUseCase(repository: repository)
            let viewModel = ImageListViewModel(useCase: useCase)
            ImageListView(viewModel: viewModel)
        }
    }
}
