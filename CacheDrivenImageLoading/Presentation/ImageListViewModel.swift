//
//  ImageListViewModel.swift
//  CacheDrivenImageLoading
//
//  Created by Ronak Malick on 14/02/26.
//

import Foundation
import Combine
import UIKit

@MainActor
final class ImageListViewModel: ObservableObject {
    @Published private(set) var state: ImageListViewState = .idle
    @Published private(set) var imageStates: [URL: ImageViewState] = [:]
    
    private let useCase: FetchImagesUseCase
    
    init(useCase: FetchImagesUseCase) {
        self.useCase = useCase
    }
    
    func fetchImages() async {
        state = .loading
        do {
            let images = try await useCase.fetchImage(page: 1)
            state = .loaded(images)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadImage(url: URL) async {
        guard imageStates[url] == nil else { return }
        imageStates[url] = .loading
        do {
            guard let data = try await useCase.imageData(url: url) else { return  }
            guard let image = UIImage(data: data) else {
                imageStates[url] = .failed
                return
            }
            imageStates[url] = .loaded(image)
        } catch {
            imageStates[url] = .failed
        }
    }
}
