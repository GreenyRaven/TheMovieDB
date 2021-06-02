//
//  LoadUserIconEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 09.05.2021.
//

import Apexy

public struct LoadUserIconEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = UserIcon
    
    // MARK: - Constants
    
    private enum Constants {
        static let iconBaseURL = URL(string: "https://www.gravatar.com/avatar/")!
        static let errorInsteadOfBlankImage = "404"
    }
    
    // MARK: - Private properties
    
    private let iconHash: String
    
    // MARK: - Initialization
    
    public init(iconHash: String) {
        self.iconHash = iconHash
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        let urlWithHash = Constants.iconBaseURL.appendingPathComponent(iconHash)
        var components = URLComponents(url: urlWithHash, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "d", value: Constants.errorInsteadOfBlankImage)]
        guard let urlWithQuery = components?.url else {
            throw TheMovieDBError.badRequestError
        }
        return get(urlWithQuery)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        return UserIcon(data: body)
    }
}
