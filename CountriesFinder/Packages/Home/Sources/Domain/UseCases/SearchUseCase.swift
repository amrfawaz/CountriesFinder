//
//  SearchUseCase.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import NetworkManager
import SharedModels

public protocol SearchUseCase: Sendable {
    func search() async throws -> [Country]
}

final public class SearchUseCaseUseCaseImpl: SearchUseCase {
    private let networkLayer: NetworkLayer

    public init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }

    public func search() async throws -> [Country] {
        let api: ResetPasswordAPI = ResetPasswordAPI.search(request: nil)

        do {
            let response: BaseResponse<[CountryDTO]> = try await networkLayer.execute(api)
            return response.data?.compactMap({ $0.toDomain() }) ?? []
        } catch {
            return []
        }
    }
}
