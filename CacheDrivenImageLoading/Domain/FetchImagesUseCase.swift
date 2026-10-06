//
//  FetchImagesUseCase.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

final class FetchImagesUseCase {
    private let repository: ImageRepository
    
    init(repository: ImageRepository) {
        self.repository = repository
    }
    
    func fetchImage(page: Int) async throws -> [ImageItem] {
        try await repository.execute(page: page)
    }
    
    func imageData(url: URL) async throws -> Data? {
        try await repository.loadImageData(for: url, page: 1)
    }
}
