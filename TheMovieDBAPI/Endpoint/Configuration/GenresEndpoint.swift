//
//  GenresEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 21.05.2021.
//

import Apexy

public struct GenresEndpoint: VoidEndpoint, URLRequestBuildable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let configURL = URL(string: "genre/movie/list")!
    }
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        var components = getValidatedComponents(from: Constants.configURL)
        components?.queryItems?.append(
            URLQueryItem(name: ApiConstants.languageTag, value: ApiConstants.languageISO6391code))
        guard let urlWithQuery = components?.url else {
            throw APIError(statusCode: ApiConstants.badRequestCode, statusMessage: "Не удалось создать запрос")
        }
        return get(urlWithQuery)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        ApiConstants.genresConfiguration = try JSONDecoder.default.decode(GenresConfiguration.self, from: body)
    }
}
