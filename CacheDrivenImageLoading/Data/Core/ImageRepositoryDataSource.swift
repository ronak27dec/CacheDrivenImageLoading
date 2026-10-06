//
//  ImageRepositoryDataSource.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

protocol ImageRepositoryDataSource {
    func fetchImage(page: Int) async throws -> [ImageItem]
    func downloadImage(page: Int) async throws -> Data?
}
