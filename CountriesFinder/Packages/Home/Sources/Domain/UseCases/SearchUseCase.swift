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

final class MockSearchUseCase: SearchUseCase, @unchecked Sendable {
    var searchResult: Result<[Country], Error> = .success([])
    var searchCallCount = 0
    var delay: TimeInterval = 0
    
    func search() async throws -> [Country] {
        searchCallCount += 1
        
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        switch searchResult {
        case .success(let countries):
            return countries
        case .failure(let error):
            throw error
        }
    }
}
