//
//  DiskImageCache.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

final class DiskImageCache {
    private let directory: URL
    private let config: DiskCacheConfig
    private let fm = FileManager.default
    
    init(config: DiskCacheConfig) {
        self.config = config
        self.directory = fm.urls(
            for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("image-cache"
            )
        
        try? fm.createDirectory(at: directory, withIntermediateDirectories: true)
    }
    
    func data(for url: URL) -> Data? {
        let fileURL = filePath(for: url)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        touch(fileURL)
        return data
    }
    
    func insert(_ data: Data, for url: URL) {
        let fileURL = filePath(for: url)
        try? data.write(to: fileURL)
        evictIfNeeded()
    }
    
    private func filePath(for url: URL) -> URL {
        directory.appendingPathComponent(url.lastPathComponent)
    }
    
    /// LRU based eviction
    private func evictIfNeeded() {
        guard currentSize() > config.maxSize else { return }
        
        let files = (try? fm.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.contentAccessDateKey, .fileSizeKey],
            options: .skipsHiddenFiles
        )) ?? []
        
        let sorted = files.sorted {
            let d1 = try? $0.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate
            let d2 = try? $1.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate
            return (d1 ?? .distantPast) < (d2 ?? .distantPast)
        }
        
        for file in sorted {
            try? fm.removeItem(at: file)
            if currentSize() <= config.maxSize { break }
        }
    }
    
    private func currentSize() -> Int {
        let files = (try? fm.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.fileSizeKey])) ?? []
        return files.reduce(0) {
            $0 + ((try? $1.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0)
        }
    }
    
    private func touch(_ url: URL) {
        try? fm.setAttributes([.modificationDate: Date()], ofItemAtPath: url.path)
    }
}
