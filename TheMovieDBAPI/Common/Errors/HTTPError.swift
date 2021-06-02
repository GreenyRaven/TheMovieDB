//
//  HTTPError.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 01.05.2021.
//

public struct HTTPError: Error {
    
    // MARK: - Public properties
    
    public let statusCode: Int
    public let url: URL?
}

// MARK: - LocalizedError

extension HTTPError: LocalizedError {
    
    public var errorDescription: String? {
        return """
            Не удалось подключиться к серверу. \(failureReason ?? "").
            \(recoverySuggestion ?? "")
            """
    }
    
    public var failureReason: String? {
        return HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
    
    public var recoverySuggestion: String? {
        return "Попробуйте позже"
    }
}
