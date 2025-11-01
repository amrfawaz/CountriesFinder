//
//  RequestBuilder.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

internal struct RequestBuilder {
    static func request(
        configuration: NetworkConfigurations?,
        api: API
    ) async throws -> URLRequest {
        
        guard let configuration else {
            throw RequestBuilderError.missingConfiguration
        }
        
        let url = try RequestBuilder.createURL(
            baseURL: configuration.baseURL,
            api: api
        )

        // Create URLRequest from provieded url string
        var request = URLRequest(url: url)

        request.httpMethod =  api.method.rawValue
        let defaultHeaders = await configuration.getDefaultHeaders()
        request.allHTTPHeaderFields = api.getAllHeaders(defaultHeaders: defaultHeaders)
        request.timeoutInterval = configuration.timeoutInterval

        switch api.method {
        case .GET, .DELETE:
            if let params = api.parameters {
                do {
                    try RequestBuilder.bindQueryParamsToURL(
                        request: &request,
                        url: url,
                        parameters: params
                    )
                } catch {
                    debugPrint(RequestBuilderError.invalidQueryParameters.rawValue)
                    throw RequestBuilderError.invalidQueryParameters
                }
            }
        case .POST, .PUT:
            if let params = api.parameters {
                do {
                    try buildRequestBody(request: &request, parameters: params)
                } catch {
                    debugPrint(RequestBuilderError.invalidParameters.rawValue)
                    throw RequestBuilderError.invalidParameters
                }
            } else {
                debugPrint(RequestBuilderError.missingParameters.rawValue)
                throw RequestBuilderError.missingParameters
            }
        }
        return request
    }
}


private extension RequestBuilder {
    private static func createURL(
        baseURL: String,
        api: API
    ) throws -> URL {
        // Try to calculate the url from provided url components
        guard let fullStringURL = try api.getFullURL(baseURL: baseURL) else {
            debugPrint(RequestBuilderError.missingURL.rawValue)
            throw RequestBuilderError.missingURL
        }

        // Try to create URL from url string
        guard let url = URL(string: fullStringURL) else {
            debugPrint(RequestBuilderError.invalidURL.rawValue)
            throw RequestBuilderError.invalidURL
        }
        return url
    }

    private static func bindQueryParamsToURL(
        request: inout URLRequest,
        url: URL,
        parameters: Encodable
    ) throws {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let encodedData = try JSONEncoder().encode(parameters)

        // Try to convert encoeded parameters to [String: String], then add them to url as query parameters
        guard let dictionary = try JSONSerialization.jsonObject(
            with: encodedData,
            options: .allowFragments
        ) as? [String: String] else {
            debugPrint(RequestBuilderError.invalidQueryParameters.rawValue)
            throw RequestBuilderError.invalidQueryParameters
        }

        components?.queryItems = dictionary.compactMap { key, value in
            URLQueryItem(name: key, value: value)
        }

        // Update the request URL with query items
        guard let url = components?.url else {
            debugPrint(RequestBuilderError.queryParametersNotBindedToURL.rawValue)
            throw RequestBuilderError.queryParametersNotBindedToURL
        }

        // Set the updated url + query parameters to request.url
        request.url = url
    }

    private static func buildRequestBody(
        request: inout URLRequest,
        parameters: Encodable
    ) throws {
        do {
            // Encode the parameters proveded to data
            let jsonData = try JSONEncoder().encode(parameters)
            
            // Update the request body in request.httpBody
            request.httpBody = jsonData
        } catch {
            debugPrint(RequestBuilderError.invalidParameters.rawValue)
            throw RequestBuilderError.invalidParameters
        }
    }
}
