//
//  NetworkLayer.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public protocol NetworkLayer: Sendable {
    func execute<T: Decodable, E: Decodable>(_ api: API) async throws -> BaseResponse<T, E>
}

public enum Constants {
    public enum Undefined {
        static let code = "-1"
        static let detailedCode = "-1"
        static let unknown = "Unknown error"
    }

    public enum Failure {
        public static let sessionExpiredCode = "210"
    }
    
    public enum Success {
        static let code = "000"
    }
}

public final class NetworkLayerImpl: NetworkLayer {
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    public func execute<T: Decodable, E: Decodable>(_ api: API) async throws -> BaseResponse<T, E> {
        do {
            let response: BaseResponse<T, E> = try await networkManager.executeAPI(api)
            return response
        } catch {
            throw error
        }
    }
}


