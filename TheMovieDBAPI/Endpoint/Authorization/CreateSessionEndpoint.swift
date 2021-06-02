//
//  CreateSessionEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 02.05.2021.
//

import Apexy

/// Получение sessionID на основе валидированного requestToken
public struct CreateSessionEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = FullSessionData
    
    // MARK: - Constants
    
    private enum Constants {
        static let sessionURL = URL(string: "authentication/session/new")!
    }
    
    // MARK: - Private properties
    
    private let requestToken: String
    
    // MARK: - Initialization
    
    public init(requestToken: String) {
        self.requestToken = requestToken
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        let encoder = JSONEncoder.default
        let body = try encoder.encode(TokenData(requestToken: requestToken))
        guard let urlWithQuery = getValidatedComponents(from: Constants.sessionURL)?.url else {
            throw TheMovieDBError.badRequestError
        }
        return post(urlWithQuery, body: HTTPBody.json(body))
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        return try JSONDecoder.default.decode(FullSessionData.self, from: body)
    }
}
