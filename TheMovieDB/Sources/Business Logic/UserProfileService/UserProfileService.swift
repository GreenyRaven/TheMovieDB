//
//  UserProfileService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 06.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Загрузка данных профиля пользователя
protocol UserProfileService: AnyObject {
    
    /// Загрузка основных данных профиля пользователя
    ///
    /// - Parameter completion: Полученные данные профиля пользователя,  или описание возникшей ошибки `Error`
    /// - Returns: Прогресс выполнения запроса к серверу с возможностью отмены запроса
    @discardableResult
    func fetchProfile(completion: @escaping (Result<UserProfileDetails, Error>) -> Void) -> Progress
}

final class UserProfileServiceImpl: UserProfileService {
    
    // MARK: - Private properties
    
    private let apiClient: Client
    private let persistentStore: PersistentStoreService
    
    // MARK: - Initialization
    
    init(apiClient: Client, persistentStore: PersistentStoreService) {
        self.apiClient = apiClient
        self.persistentStore = persistentStore
    }
    
    // MARK: - Public methods
    
    func fetchProfile(completion: @escaping (Result<UserProfileDetails, Error>) -> Void) -> Progress {
        return apiClient.request(
            LoadUserProfileEndpoint(sessionID: persistentStore.value(for: .sessionID)),
            completionHandler: completion)
    }
}
