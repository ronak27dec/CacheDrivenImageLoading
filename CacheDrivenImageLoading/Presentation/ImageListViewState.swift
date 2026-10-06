//
//  ImageListViewState.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation
import UIKit

enum ImageListViewState {
    case idle
    case loading
    case loaded([ImageItem])
    case error(String)
}

enum ImageViewState {
    case idle
    case loading
    case loaded(UIImage)
    case failed
}
