//
//  LogOutEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 02.05.2021.
//

import Apexy

/// Удаление  сессии  валидированного requestToken
public struct DeleteSessionEndpoint: VoidEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = Void
    
    // MARK: - Constants
    
    private enum Constants {
        static let sessionURL = URL(string: "authentication/session")!
    }
    
    // MARK: - Private properties
    
    private let sessionID: String?
    
    // MARK: - Initializers
    
    public init(sessionID: String?) {
        self.sessionID = sessionID
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        guard let sessionID = sessionID else {
            throw TheMovieDBError.badRequestError
        }
        let encoder = JSONEncoder.default
        let body = try encoder.encode(SessionData(sessionId: sessionID))
        guard let urlWithQuery = getValidatedComponents(from: Constants.sessionURL)?.url else {
            throw TheMovieDBError.badRequestError
        }
        return delete(urlWithQuery, body: HTTPBody.json(body))
    }
}
