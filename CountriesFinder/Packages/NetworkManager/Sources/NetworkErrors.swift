//
//  NetworkErrors.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public enum DataError: Error {
    case parsing
}
public enum RequestBuilderError: String, Error {
    case missingURL = "Faild to full URL or one of these parameters is missing: base URL, path, endpoint."
    case invalidURL = "URL could not be created from the full URL string. Please check the URL components."
    case invalidParameters = "The provieded parameters are invalid."
    case missingParameters = "Request parameters are missing."
    case noInternetConnection = "Failed to connect to the network. Please check your internet connection."
    case invalidQueryParameters = "Fiald to serialized the query parameters to [String: String]"
    case queryParametersNotBindedToURL = "Faild to create URL with query parameters."
    case missingRequest = "Faild to create URLRequest"
    case missingConfiguration = "Faild to find NetworkConfigurations"

}


public enum NetworkError: Error {
    case missingInternetConnection
    case unAuthorized
    case badRequest
    case server
    case networkConfiguration
    case decoding
    case other
}

public enum ResponseBuilderError: String, Error {
    case responseDataMissing = "Data passed to responde func inside ResponseBuilder is nil"
    case failedToParse = "Failed to decode the data response to the target type"
}

