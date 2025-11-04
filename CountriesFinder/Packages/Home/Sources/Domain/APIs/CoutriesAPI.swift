//
//  CoutriesAPI.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import UIKit
import NetworkManager

public enum ResetPasswordAPI: API, Sendable {
    case search(request: BaseRequest?)
    
    public var fullURL: String? { nil }
    
    public var endPoint: String? {
        switch self {
        case .search:
            return "/all"
        }
    }

    public var path: String? {
       return "/v3.1"
    }
    
    public var method: HTTPMethod {
        switch self {
        case .search: .GET
        }
    }
    
    public var customHeaders: [String : String]? {
        nil
    }
    
    public var parameters: (any Encodable)? {
        ["fields": "name,capital,currencies"]
    }
}
