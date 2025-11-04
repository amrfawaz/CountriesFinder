//
//  File.swift
//  Packages
//
//  Created by Amr Fawaz on 04/11/2025.
//

import SwiftUI
//import GDCoreUI

public enum GenericAPIError: Errors {
    case genericError(
        title: String? = nil,
        description: String? = nil,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil,
        image: Image? = nil
    )
    
    var image: Image {
        switch self {
        case .genericError(_, _, _, _, let image):
            return image ?? Image(.warningIcon)
        }
    }
    
    var title: String {
        switch self {
        case .genericError(let title, _, _, _, _):
            return title ?? "Something went wrong!"
        }
    }
    
    var description: String {
        switch self {
        case .genericError(_, let description, _, _, _):
            return description ?? ""
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .genericError(_, _, let primaryButtonTitle, _, _):
            return primaryButtonTitle ?? "Ok"
        }
    }
    
    var secondaryButtonTitle: String {
        switch self {
        case .genericError(_, _, _, let secondaryButtonTitle, _):
            return secondaryButtonTitle ?? "Cancel"
        }
    }
}

public protocol Errors: Error, Equatable {
    var localizedDescription: String { get }
}
