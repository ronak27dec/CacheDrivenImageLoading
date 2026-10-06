//
//  UrlSessionManager.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

protocol UrlSessionManagerProtocol {
    func dispatchRequest(request: URLRequest) async throws -> Data
}

final class UrlSessionManager: UrlSessionManagerProtocol {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    func dispatchRequest(request: URLRequest) async throws -> Data {
        let (data, _) = try await session.data(for: request)
        guard data.isEmpty == false else {
            throw NSError(domain: "NoData", code: 0, userInfo: nil)
        }
        return data
    }
}
