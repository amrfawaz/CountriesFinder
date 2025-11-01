//
//  ErrorHandler.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public struct ErrorHandler {
    static func checkError(response: URLResponse?) throws {
        try handleResponseError(response)
    }

    private static func handleResponseError(_ response: URLResponse?) throws {
        if let response = response as? HTTPURLResponse {
            try self.handleStatusCode(response.statusCode)
        }
    }

    private static func handleStatusCode(_ statusCode: Int) throws {
        switch statusCode {
        case 200..<300:
            return
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unAuthorized
        case 1009 , 1020 :
            throw NetworkError.missingInternetConnection
        default:
            throw NetworkError.server
        }
    }

    static func mapError(_ error: any Error) -> NetworkError {
        if let error = error as? RequestBuilderError{
            return mapRequestBuilderError(error)
        } else if let error = error as? ResponseBuilderError {
            return .networkConfiguration
        } else if let error = error as? DataError {
            return mapDataDecodingError(error)
        } else if let error = error as? NetworkError {
            return error
        } else if error is URLError {
            return .networkConfiguration
        }
        return .other
    }

    private static func mapRequestBuilderError(_ error: RequestBuilderError) -> NetworkError {
        .networkConfiguration
    }

    private static func mapDataDecodingError(_ error: DataError) -> NetworkError {
        switch error {
        case .parsing:
            return .decoding
        }
    }
}
