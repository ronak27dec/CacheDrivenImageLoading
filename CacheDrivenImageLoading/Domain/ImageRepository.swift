//
//  ImageRepository.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

protocol ImageRepository {
    func execute(page: Int) async throws -> [ImageItem]
    func loadImageData(for url: URL, page: Int) async throws -> Data?
}
