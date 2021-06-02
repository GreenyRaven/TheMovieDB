//
//  LoadFavouritesEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy

public struct LoadFavouritesEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = [MovieDetails]
    
    // MARK: - Constants
    
    private enum Constants {
        static let favouritesURLBeginning = "account/"
        static let favouritesURLEnding = "/favorite/movies"
    }
    
    // MARK: - Private properties
    
    private let sessionID: String?
    private let accountID: String?
    private let page: Int
    
    // MARK: - Initialization
    
    public init(sessionID: String?, accountID: String?, page: Int) {
        self.accountID = accountID
        self.page = page
        self.sessionID = sessionID
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        guard
            let sessionID = sessionID,
            let accountID = accountID
        else {
            throw TheMovieDBError.badRequestError
        }
        let originalURL = URL(
            string: "\(Constants.favouritesURLBeginning)\(accountID)\(Constants.favouritesURLEnding)")!
        var components = getValidatedComponents(from: originalURL)
        components?.queryItems?.append(URLQueryItem(name: ApiConstants.sessionIDQueryTag, value: sessionID))
        components?.queryItems?.append(
            URLQueryItem(name: ApiConstants.languageTag, value: ApiConstants.languageISO6391code))
        components?.queryItems?.append(URLQueryItem(name: ApiConstants.pageTag, value: "\(page)"))
        guard let urlWithQuery = components?.url else {
            throw TheMovieDBError.badRequestError
        }
        return get(urlWithQuery)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        let movies = try JSONDecoder.default.decode(ResponseData.self, from: body).results
        return movies.map { movieWithFilledGenres(from: $0) }
    }
}

// MARK: - ResponseData

private struct ResponseData: Decodable {
    let page: Int
    let results: [MovieDetails]
}
