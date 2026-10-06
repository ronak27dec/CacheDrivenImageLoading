//
//  ImageRepositoryRemoteDataSource.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

final class ImageRepositoryRemoteDataSource: ImageRepositoryDataSource {
    private let session: UrlSessionManagerProtocol
    
    init(session: UrlSessionManagerProtocol) {
        self.session = session
    }
    
    func fetchImage(page: Int) async throws -> [ImageItem] {
        guard let url = URL(
            string: "https://picsum.photos/v2/list?page=\(page)&limit=100"
        ) else {
            return []
        }
        let request = URLRequest(url: url)
        do {
            let data = try await self.session.dispatchRequest(request: request)
            let modelDTO: [PicsumDTO] = try JSONDecoder().decode([PicsumDTO].self, from: data)
            return modelDTO.compactMap {
                ImageItem(id: $0.id,
                          author: $0.author,
                          url: $0.url)
            }
        }
    }
    
    func downloadImage(page: Int) async throws -> Data? {
        guard let url = URL(
            string: "https://picsum.photos/v2/list?page=\(page)&limit=100"
        ) else {
            return nil
        }
        let request = URLRequest(url: url)
        return try await self.session.dispatchRequest(request: request)
    }
}
