//
//  Error.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 21.05.2021.
//

public enum TheMovieDBError: Error {
    
    // MARK: - TheMovieDBError
    
    case apiError(error: APIError)
    case httpError(error: HTTPError)
    
    // MARK: - Public properties
    
    public var description: String {
        switch self {
        case .apiError(let apiError):
            return apiError.localizedDescription
        case .httpError(let httpError):
            return httpError.localizedDescription
        }
    }
    
    static let badRequestError = TheMovieDBError.apiError(
        error: APIError(statusCode: 3, statusMessage: "Не удалось создать запрос"))
}
