//
//  createTokenEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 01.05.2021.
//

import Apexy

/// Генерация нового request-token
public struct CreateTokenEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = TokenData
    
    // MARK: - Constants
    
    private enum Constants {
        static let tokenURL = URL(string: "authentication/token/new")!
    }
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        guard let urlWithQuery = getValidatedComponents(from: Constants.tokenURL)?.url else {
            throw TheMovieDBError.badRequestError
        }
        return get(urlWithQuery)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        let body = try JSONDecoder.default.decode(FullTokenData.self, from: body)
        return TokenData(requestToken: body.requestToken)
    }
}
