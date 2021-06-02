//
//  LoadMoviePosterEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 18.05.2021.
//

import Apexy

/// Размер изображения
public enum PosterSize: String {
    case thumb = "w92"
    case compressed = "w500"
    case original = "original"
}

public struct LoadMoviePosterEndpoint: ValidatingEndpoint, URLRequestBuildable {
    
    // MARK: - Types
    
    public typealias Content = MoviePoster
    
    // MARK: - Constants
    
    private enum Constants {
        static let fallbackSize = "w342"
        static let defaultSize = "original"
    }
    
    // MARK: - Private properties
    
    private let filePath: String
    private let posterSize: PosterSize
    
    // MARK: - Initialization
    
    public init(filePath: String, posterSize: PosterSize) {
        self.posterSize = posterSize
        self.filePath = filePath
    }
    
    // MARK: - Public methods
    
    public func makeRequest() throws -> URLRequest {
        guard
            let configuration = ApiConstants.apiConfiguration
        else {
            throw TheMovieDBError.badRequestError
        }
        var urlString = configuration.images.secureBaseUrl
        let size = getSize(from: configuration)
        urlString.append("\(size)/")
        urlString.append(filePath)
        guard let url = URL(string: urlString) else {
            throw TheMovieDBError.badRequestError
        }
        return get(url)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        return MoviePoster(posterImageData: body)
    }
    
    // MARK: - Private methods
    
    private func getSize(from configuration: MovieDBConfiguration) -> String {
        let requestedSizeAvailable = configuration.images.posterSizes.first(
            where: { $0 == posterSize.rawValue }) != nil
        let thumbnailSize = configuration.images.posterSizes.first(where: { Int($0.suffix(3)) ?? 200 < 150 })
        let fallbackSizeAvailable = configuration.images.posterSizes.first(
            where: { $0 == Constants.fallbackSize }) != nil
        let minimalSuitableSize = configuration.images.posterSizes.first(where: { Int($0.suffix(3)) ?? 1 > 200 })
        if requestedSizeAvailable {
            return posterSize.rawValue
        } else if posterSize == .thumb,
                  let thumbnailSize = thumbnailSize {
            return thumbnailSize
        } else if fallbackSizeAvailable {
            return Constants.fallbackSize
        } else if let minimalSuitableSize = minimalSuitableSize {
            return minimalSuitableSize
        }
        return Constants.defaultSize
    }
}
