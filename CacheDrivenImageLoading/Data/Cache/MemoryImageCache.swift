//
//  MemoryImageCache.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

final class MemoryImageCache {
    private let cache = NSCache<NSNumber, NSData>()
    
    func data(for url: URL) -> Data? {
        let key = NSNumber(value: url.absoluteString.hashValue)
        return cache.object(forKey: key) as Data?
    }
    
    func insert(_ data: Data, for url: URL) {
        let key = NSNumber(value: url.absoluteString.hashValue)
        cache.setObject(data as NSData, forKey: key)
    }
}
