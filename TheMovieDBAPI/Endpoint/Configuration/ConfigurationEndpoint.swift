//
//  ConfigurationEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 18.05.2021.
//

import Apexy

public struct ConfigurationEndpoint: VoidEndpoint, URLRequestBuildable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let configURL = URL(string: "configuration")!
    }
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        guard let urlWithQuery = getValidatedComponents(from: Constants.configURL)?.url else {
            throw TheMovieDBError.badRequestError
        }
        return get(urlWithQuery)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        ApiConstants.apiConfiguration = try JSONDecoder.default.decode(MovieDBConfiguration.self, from: body)
    }
}
