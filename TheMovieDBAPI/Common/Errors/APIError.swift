//
//  APIError.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 01.05.2021.
//

public struct APIError: Decodable, Error {
    
    // MARK: - Public properties
    
    public let statusCode: Int
    public let statusMessage: String?
    public let success: Bool?
    public var isReasonToSighOut: Bool {
        [30, 3, 7].contains(statusCode)
    }
    
    // MARK: - Initialization
    
    init(statusCode: Int, statusMessage: String?) {
        success = false
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }
}

// MARK: - LocalizedError

extension APIError: LocalizedError {
    
    public var errorDescription: String? {
        return "\(failureReason ?? ""). \(recoverySuggestion ?? "")"
    }
    
    public var failureReason: String? {
        switch statusCode {
        case 30:
            return "Неверно указаны логин или пароль"
        case 3:
            return "Отказано в доступе"
        case 7:
            return "Неверный ключ API"
        default:
            return "Что-то пошло не так"
        }
    }
    
    public var recoverySuggestion: String? {
        switch statusCode {
        case 3:
            return ""
        case 30:
            return "Проверьте правильность логина и пароля"
        case 7:
            return "Обратитесь в техподдержку"
        default:
            return "Попробуйте позже"
        }
    }
}
