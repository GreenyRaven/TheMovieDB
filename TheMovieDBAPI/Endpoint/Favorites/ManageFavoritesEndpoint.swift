//
//  ManageFavoritesEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy

public struct ManageFavoritesEndpoint: VoidEndpoint, URLRequestBuildable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let favoritesURLBeginning = "account/"
        static let favoritesURLEnding = "/favorite"
    }
    
    // MARK: - Private properties
    
    private let sessionID: String?
    private let accountID: String?
    private let mediaType: String
    private let mediaID: Int
    private let favorite: Bool
    
    // MARK: - Initialization
    
    public init(sessionID: String?, accountID: String?, mediaType: String, mediaID: Int, favorite: Bool) {
        self.accountID = accountID
        self.favorite = favorite
        self.mediaID = mediaID
        self.mediaType = mediaType
        self.sessionID = sessionID
    }
    
    // MARK: - Public methods
    
    public func validate(_ request: URLRequest?, response: HTTPURLResponse, data: Data?) throws {
        guard
            let data = data,
            let falseAlarm = try? JSONDecoder.default.decode(APIError.self, from: data),
            falseAlarm.success == false
        else {
            return
        }
        try ResponseValidator.validate(response, with: data)
    }
    
    public func makeRequest() throws -> URLRequest {
        guard
            let sessionID = sessionID,
            let accountID = accountID
        else {
            throw TheMovieDBError.badRequestError
        }
        let originalURL = URL(
            string: "\(Constants.favoritesURLBeginning)\(accountID)\(Constants.favoritesURLEnding)")!
        var components = getValidatedComponents(from: originalURL)
        components?.queryItems?.append(URLQueryItem(name: ApiConstants.sessionIDQueryTag, value: sessionID))
        let body = try JSONEncoder.default.encode(
            CustomBody(mediaType: mediaType, mediaId: mediaID, favorite: favorite))
        guard let urlWithQuery = components?.url else {
            throw TheMovieDBError.badRequestError
        }
        return post(urlWithQuery, body: HTTPBody.json(body))
    }
}

// MARK: - CustomBody

private struct CustomBody: Encodable {
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
}
