//
//  NetworkManager.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public protocol NetworkConfigurations {
    var baseURL: String { get }
    var timeoutInterval: TimeInterval { get }
    var session: URLSession { get }
    
    func getDefaultHeaders() async -> [String: String]
}


public protocol NetworkManager: Sendable {
    func setConfigurations(_ configurations: NetworkConfigurations)
    func executeAPI<T: Decodable>(_ api: API) async throws -> T
}

public final class NetworkManagerImp: NetworkManager, @unchecked Sendable {

    private init() {}

    private static let shared = NetworkManagerImp()
    private let privateQueue: DispatchQueue = .init(
        label: "com.network.manager"
    )
    private var configurations: NetworkConfigurations? {
        get {
            privateQueue.sync {
                return _configurations
            }
        }
        set {
            privateQueue.sync {
                self._configurations = newValue
            }
        }
    }
    //MARK: Not Used It as it is not safe thread
    private var _configurations: NetworkConfigurations?
    
    
    public func setConfigurations(_ configurations: NetworkConfigurations) {
        self.configurations = configurations
    }

    public func executeAPI<T>(_ api: any API) async throws -> T
    where T: Decodable {

        try Reachability.isConnectedToNetwork()
        
        do {
            let request = try await RequestBuilder.request(configuration: configurations, api: api)
            let (data, response) = try await configurations!.session.data(for: request)
//            try ErrorHandler.checkError(response: response)
            
            return try ResponseBuilder.response(from: data)
            
        } catch (let error) {
            throw ErrorHandler.mapError(error)
        }
    }

    public static func sharedInstance() -> NetworkManager {
        return shared
    }
}
