//
//  Style+Modifier.swift
//  Packages
//
//  Created by Amr Fawaz on 04/11/2025.
//

import SwiftUI

public extension Style {
    enum Modifier {}
}

public extension Style.Modifier {

    /// Clipping and setting contentShape are needed to prevent touch outside bounds of rounded corner view
    /// Clipping shape you preserve the parts of the view covered by the shape, while eliminating other parts
    /// of the view, however using contentShape defines the content shape for hit testing.
    struct RoundCorners: ViewModifier {
        let radius: CGFloat
        let corners: UIRectCorner

        public init(radius: CGFloat, corners: UIRectCorner) {
            self.radius = radius
            self.corners = corners
        }

        public func body(content: Content) -> some View {
            content
                .clipShape(CornerRadiusShape(radius: radius, corners: corners))
                .contentShape(CornerRadiusShape(radius: radius, corners: corners))
        }
    }
}

// MARK: - Private structs

private extension Style.Modifier {
    /// A shape used by RoundCorners modifier to set views shape with a set of rounded corners
    struct CornerRadiusShape: Shape {
        let radius: CGFloat
        let corners: UIRectCorner

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
}
