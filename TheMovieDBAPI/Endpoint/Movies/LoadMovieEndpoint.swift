//
//  LoadMovieEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy

public struct LoadMovieEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = MovieDetails
    
    // MARK: - Constants
    
    private enum Constants {
        static let movieURLBeginning = "movie/"
    }
    
    // MARK: - Private properties
    
    private let movieID: Int
    
    // MARK: - Initialization
    
    public init(movieID: Int) {
        self.movieID = movieID
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        let originalURL = URL(string: "\(Constants.movieURLBeginning)\(movieID)")!
        guard let urlWithQuery = getValidatedComponents(from: originalURL)?.url else {
            throw TheMovieDBError.badRequestError
        }
        return get(urlWithQuery)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        return movieWithFilledGenres(from: try JSONDecoder.default.decode(MovieDetails.self, from: body))
    }
}
