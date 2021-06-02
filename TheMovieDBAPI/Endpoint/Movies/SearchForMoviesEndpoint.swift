//
//  SearchForMoviesEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy

public struct SearchForMoviesEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = [MovieDetails]
    
    // MARK: - Constants
    
    private enum Constants {
        static let searchURL = URL(string: "search/movie")!
        static let adultQueryTag = "adult"
        static let queryTag = "query"
    }
    
    // MARK: - Private properties
    
    private let searchTerm: String
    private let page: Int
    
    // MARK: - Initialization
    
    public init(searchTerm: String, page: Int) {
        self.searchTerm = searchTerm
        self.page = page
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        var components = getValidatedComponents(from: Constants.searchURL)
        components?.queryItems?.append(URLQueryItem(name: Constants.queryTag, value: "\(searchTerm)"))
        components?.queryItems?.append(URLQueryItem(name: ApiConstants.pageTag, value: "\(page)"))
        components?.queryItems?.append(URLQueryItem(name: Constants.adultQueryTag, value: "true"))
        components?.queryItems?.append(
            URLQueryItem(name: ApiConstants.languageTag, value: ApiConstants.languageISO6391code))
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
