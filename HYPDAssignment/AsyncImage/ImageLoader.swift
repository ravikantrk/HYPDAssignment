//
//  ImageLoader.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Combine
import UIKit

enum ImageLoadingError: Error {
    case incorrectData
    case timedOut
    case unknown
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var error: ImageLoadingError?
    @Published private(set) var isLoading = false
    
    private let url: URL?
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    private var TIMEOUT_TIME: Int = 10

    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    /// This initializer is only being used in cases where AsyncImage didn't get any URL
    convenience init() {
        self.init(url: nil)
    }
    
    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
        self.load()
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        isLoading = true

        guard let url = self.url else {
            isLoading = false
            self.error = .incorrectData
            return
        }

        if let image = cache?[url] {
            self.image = image
            isLoading = false
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .timeout(.seconds(TIMEOUT_TIME), scheduler: RunLoop.main, customError: { URLError(.timedOut) })
            .tryMap { data, _ in
                guard let image = UIImage(data: data) else {
                    throw ImageLoadingError.incorrectData
                }
                return image
            }
            .handleEvents(receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                        case let urlError as URLError where urlError.code == .timedOut:
                            self?.error = ImageLoadingError.timedOut
                        case let loadingError as ImageLoadingError:
                            self?.error = loadingError
                        default:
                            self?.error = .unknown
                        }
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] image in
                    self?.image = image
                    self?.isLoading = false
                }
            )
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onFinish() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }

    private func cache(_ image: UIImage?) {
        guard let url = url else { return }
        image.map { cache?[url] = $0 }
    }
}
