//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI

struct AsyncImage<LoadingView: View, PlaceholderView: View>: View {

    @ObservedObject private var loader: ImageLoader

    private let loadingView: LoadingView
    private let placeholder: PlaceholderView
    private let image: (UIImage) -> Image
    private let url: URL?
    private var placeholderTextColor: Color
    private var contentMode: ContentMode

    init(url: URL?,
         @ViewBuilder loadingView: @escaping () -> LoadingView,
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:),
         @ViewBuilder placeholder: @escaping () -> PlaceholderView,
         contentMode: ContentMode = .fit,
         placeholderTextColor: Color = .gray) {

        self.image = image
        self.loadingView = loadingView()
        self.placeholder = placeholder()
        self.url = url
        self.placeholderTextColor = placeholderTextColor
        self.contentMode = contentMode

        if let url = url {
            loader = ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue)
        } else {
            // If url is empty just create an empty ImageLoader as StateObject
            loader = ImageLoader()
        }
    }

    var body: some View {
        content
    }

    var imageNotFound: some View {
        ImageErrorView(errorType: .incorrectData, textColor: placeholderTextColor)
            .padding(.horizontal, 50)
    }

    var imageTimedOut: some View {
        ImageErrorView(errorType: .timedOut, textColor: placeholderTextColor)
            .onTapGesture(perform: loader.load)
    }

    private var content: some View {
        Group {
            if loader.isLoading {
                if loadingView is EmptyView {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                } else {
                    loadingView
                }
            } else if let loaderImage = loader.image {
                image(loaderImage)
                    .aspectRatio(contentMode: self.contentMode)
            } else if let error = loader.error {
                switch error {
                case .incorrectData, .unknown:
                    if placeholder is EmptyView {
                        imageNotFound
                    } else {
                        placeholder
                    }
                case .timedOut:
                    if placeholder is EmptyView {
                        imageTimedOut
                    } else {
                        placeholder
                    }
                }
            }
        }
    }
}

extension AsyncImage where PlaceholderView == EmptyView {
    init(url: URL?,
         @ViewBuilder loadingView: @escaping () -> LoadingView,
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:),
         contentMode: ContentMode = .fit,
         placeholderTextColor: Color = .gray) {
        self.init(url: url, loadingView: loadingView, image: image, placeholder: { EmptyView() }, contentMode: contentMode, placeholderTextColor: placeholderTextColor)
    }
}

extension AsyncImage where LoadingView == EmptyView {
    init(url: URL?,
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:),
         @ViewBuilder placeholder: @escaping () -> PlaceholderView,
         contentMode: ContentMode = .fit,
         placeholderTextColor: Color = .gray) {
        self.init(url: url, loadingView: { EmptyView() }, image: image, placeholder: placeholder, contentMode: contentMode, placeholderTextColor: placeholderTextColor)
    }
}

extension AsyncImage where LoadingView == EmptyView, PlaceholderView == EmptyView {
    init(url: URL?,
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:),
         contentMode: ContentMode = .fit,
         placeholderTextColor: Color = .gray) {
        self.init(url: url, loadingView: { EmptyView() }, image: image, placeholder: { EmptyView() }, contentMode: contentMode, placeholderTextColor: placeholderTextColor)
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
