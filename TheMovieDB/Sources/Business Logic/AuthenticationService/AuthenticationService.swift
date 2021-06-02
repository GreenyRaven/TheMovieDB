//
//  AuthenticationService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Авторизация пользователя через логин и пароль
protocol AuthenticationService: AnyObject {
    
    var isAuthorized: Bool { get }
    
    /// Деавторизация текущего пользователя с удалением активной сессии
    ///
    /// - Parameter completion: Отчет об успехе, или описание возникшей ошибки `Error`
    @discardableResult
    func signOut() -> Progress
    
    /// Генерация нового `request-token`
    /// - Parameter completion: Токен, или описание возникшей ошибки `Error`
    @discardableResult
    func createToken(completion: @escaping (Result<TokenData, Error>) -> Void) -> Progress
    
    /// Валидация `request-token`
    /// - Parameters:
    ///   - userCredentials: Логин и пароль пользователя, а также валидируемый токен
    ///   - completion: Отчет об успехе, или описание возникшей ошибки `Error`
    @discardableResult
    func validateToken(
        for userCredentials: UserCredentials,
        completion: @escaping (Result<Void, Error>) -> Void) -> Progress
    
    /// Создание новой сессии для текущего пользователя. Предоставление доступа в авторизованную зону
    /// - Parameters:
    ///   - requestToken: Валидированный токен
    ///   - completion: Сгенерированный `session_id`, или описание возникшей ошибки `Error`
    @discardableResult
    func createNewSession(
        via requestToken: String,
        completion: @escaping (Result<FullSessionData, Error>) -> Void) -> Progress 
}

final class AuthenticationServiceImpl: AuthenticationService {
    
    // MARK: - Public properties
    
    public var isAuthorized: Bool {
        return (persistentStore.value(for: .username) != nil) && (persistentStore.value(for: .sessionID) != nil)
    }
    
    // MARK: - Private properties
    
    private let apiClient: Client
    private let persistentStore: PersistentStoreService
    
    // MARK: - Initialization
    
    init(apiClient: Client, persistentStore: PersistentStoreService) {
        self.apiClient = apiClient
        self.persistentStore = persistentStore
    }
    
    // MARK: - Public methods
    
    func signOut() -> Progress {
        let progress = apiClient.request(
            DeleteSessionEndpoint(sessionID: persistentStore.value(for: .sessionID))) { _ in }
        persistentStore.removeValue(of: .username)
        persistentStore.removeValue(of: .sessionID)
        persistentStore.removeValue(of: .accountID)
        return progress
    }
    
    func createToken(completion: @escaping (Result<TokenData, Error>) -> Void) -> Progress {
        apiClient.request(CreateTokenEndpoint(), completionHandler: completion)
    }
    
    func validateToken(
        for userCredentials: UserCredentials,
        completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        
        apiClient.request(ValidateTokenEndpoint(userCredentials: userCredentials), completionHandler: completion)
    }
    
    func createNewSession(
        via requestToken: String,
        completion: @escaping (Result<FullSessionData, Error>) -> Void) -> Progress {
        
        apiClient.request(CreateSessionEndpoint(requestToken: requestToken), completionHandler: completion)
    }
}
