//
//  LoadUserProfileEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 06.05.2021.
//

import Apexy

public struct LoadUserProfileEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = UserProfileDetails
    
    // MARK: - Constants
    
    private enum Constants {
        static let profileURL = URL(string: "account")!
    }
    
    // MARK: - Private properties
    
    private let sessionID: String?
    
    // MARK: - Initialization
    
    public init(sessionID: String?) {
        self.sessionID = sessionID
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        guard let sessionID = sessionID else {
            throw TheMovieDBError.badRequestError
        }
        var components = getValidatedComponents(from: Constants.profileURL)
        components?.queryItems?.append(URLQueryItem(name: ApiConstants.sessionIDQueryTag, value: sessionID))
        guard let urlWithQuery = components?.url else {
            throw TheMovieDBError.badRequestError
        }
        return get(urlWithQuery)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        return try JSONDecoder.default.decode(UserProfileDetails.self, from: body)
    }
}
