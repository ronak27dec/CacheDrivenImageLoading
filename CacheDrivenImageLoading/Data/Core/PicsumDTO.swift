//
//  PicsumDTO.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation

struct PicsumDTO: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
