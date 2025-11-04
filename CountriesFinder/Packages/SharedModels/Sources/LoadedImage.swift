//
//  LoadedImage.swift
//  Packages
//
//  Created by Amr Fawaz on 04/11/2025.
//

import Foundation
import SwiftUI

public struct LoadedImage: View {
    private let url: URL?
    private let shape: ImageShape
    private let placeholderColor: Color
    private let placeholderImage: Image?
    private let placeholderShape: ImageShape
    private let errorBackgroundColor: Color
    private let errorImage: Image?
    private let errorAndShimmerHeight: CGFloat?
    private let contentMode: ContentMode
    private let imageLoadedHandler: (() -> Void)?

    public init(
        _ urlString: String,
        shape: ImageShape = .default,
        placeholderImage: Image? = nil,
        placeholderColor: Color = Color.gray,
        placeholderShape: ImageShape? = nil,
        errorImage: Image? = nil,
        errorAndShimmerHeight: CGFloat? = nil,
        errorBackgroundColor: Color = .pink,
        contentMode: ContentMode = .fit,
        imageLoadedHandler: (() -> Void)? = nil
    ) {
        self.init(
            URL(string: urlString),
            shape: shape,
            placeholderImage: placeholderImage,
            placeholderColor: placeholderColor,
            placeholderShape: placeholderShape,
            errorImage: errorImage,
            errorAndShimmerHeight: errorAndShimmerHeight,
            errorBackgroundColor: errorBackgroundColor,
            contentMode: contentMode,
            imageLoadedHandler: imageLoadedHandler
        )
    }

    public init(
        _ url: URL?,
        shape: ImageShape = .default,
        placeholderImage: Image? = nil,
        placeholderColor: Color = .gray,
        placeholderShape: ImageShape? = nil,
        errorImage: Image? = nil,
        errorAndShimmerHeight: CGFloat? = nil,
        errorBackgroundColor: Color = .pink,
        shouldShowShimmer: Bool = true,
        contentMode: ContentMode = .fit,
        imageLoadedHandler: (() -> Void)? = nil
    ) {
        self.url = url
        self.shape = shape
        self.placeholderImage = placeholderImage
        self.errorImage = errorImage
        self.errorAndShimmerHeight = errorAndShimmerHeight
        self.placeholderColor = placeholderColor
        self.errorBackgroundColor = errorBackgroundColor

        if let placeholderShape {
            self.placeholderShape = placeholderShape
        } else {
            self.placeholderShape = shape
        }

        self.contentMode = contentMode

        self.imageLoadedHandler = imageLoadedHandler
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizableClipped(to: shape, contentMode: contentMode)
                    .onAppear {
                        imageLoadedHandler?()
                    }
            } else if phase.error != nil, let errorImage {
                shape.view.foregroundColor(errorBackgroundColor)
                    .frame(height: errorAndShimmerHeight)
                    .overlay {
                        errorImage
                    }
            } else {
                if let placeholderImage {
                    placeholderImage.resizableClipped(
                        to: placeholderShape,
                        contentMode: contentMode
                    )
                }
            }
        }
    }
}

public enum ImageShape {
    case `default`
    case circle
    case rounded(cornerRadius: CGFloat)

    @ViewBuilder
    var view: some View {
        switch self {
        case .default:
            Rectangle()
        case .circle:
            Circle()
        case let .rounded(cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
        }
    }
}

public extension Image {
    /// Sets a clipping shape for this `Image`, applying a `ContentMode`.
    /// - Parameters:
    ///   - shape: The clipping shape to use for this image.
    ///   - contentMode: A `ContentMode` to be applied.
    /// - Returns: A view that clips this `Image` to shape, with `ContentMode` applied.
    @ViewBuilder
    func resizableClipped(
        to shape: ImageShape,
        contentMode: ContentMode = .fit
    ) -> some View {
        let resizedImage = resizable()
            .aspectRatio(contentMode: contentMode)
        switch shape {
        case .default:
            resizedImage
        case .circle:
            resizedImage
                .clipShape(Circle())
        case let .rounded(cornerRadius):
            resizedImage
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
