//
//  BaseResponse.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public struct BaseResponse<T: Decodable>: Decodable {
    public var data: T?
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            data = try container.decodeIfPresent(T.self, forKey: .data)
        } else {
            data = try? T(from: decoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }
}
