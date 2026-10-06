//
//  ImageRepositoryImpl.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

final class ImageRepositoryImpl: ImageRepository {
    private let dataSource: ImageRepositoryDataSource
    private let memoryCache: MemoryImageCache
    private let diskCache: DiskImageCache
    
    init(dataSource: ImageRepositoryDataSource,
         memoryCache: MemoryImageCache,
         diskCache: DiskImageCache) {
        self.dataSource = dataSource
        self.memoryCache = memoryCache
        self.diskCache = diskCache
    }
    
    func execute(page: Int) async throws -> [ImageItem] {
        try await dataSource.fetchImage(page: page)
    }
    
    func loadImageData(for url: URL, page: Int) async throws -> Data? {
        if let data = memoryCache.data(for: url) {
            print("Image found in memory cache")
            return data
        }
        
        if let data = diskCache.data(for: url) {
            print("Image found in disk cache")
            memoryCache.insert(data, for: url)
            return data
        }

        print("Image not found on memory or disk cache")
        guard let data = try await dataSource.downloadImage(page: page) else { return nil }
        memoryCache.insert(data, for: url)
        diskCache.insert(data, for: url)
        
        return data
    }
}
