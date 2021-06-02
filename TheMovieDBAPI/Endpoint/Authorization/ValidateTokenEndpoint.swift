//
//  validateTokenEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 01.05.2021.
//

import Apexy

/// Валидация request-token для введенных username и password
public struct ValidateTokenEndpoint: VoidEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = Void
    
    // MARK: - Constants
    
    private enum Constants {
        static let validateURL = URL(string: "authentication/token/validate_with_login")!
    }
    
    // MARK: - Private properties
    
    private let userCredentials: UserCredentials
    
    // MARK: - Initialization
    
    public init(userCredentials: UserCredentials) {
        self.userCredentials = userCredentials
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        let encoder = JSONEncoder.default
        let body = try encoder.encode(userCredentials)
        guard let urlWithQuery = getValidatedComponents(from: Constants.validateURL)?.url else {
            throw TheMovieDBError.badRequestError
        }
        return post(urlWithQuery, body: HTTPBody.json(body))
    }
}
