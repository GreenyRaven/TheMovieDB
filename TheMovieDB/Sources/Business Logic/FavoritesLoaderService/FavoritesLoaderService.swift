//
//  FavoritesLoaderService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Загрузка данных избранных фильмов пользователя
protocol FavoritesLoaderService: AnyObject {
    
    /// Загрузка данных избранных фильмов пользователя
    ///
    /// - Parameter completion: Полученные данные избранных фильмов пользователя,  или описание возникшей ошибки `Error`
    /// - Returns: Прогресс выполнения запроса к серверу с возможностью отмены запроса
    @discardableResult
    func fetchFavorites(
        page: Int,
        completion: @escaping (Result<[MovieDetails], Error>) -> Void) -> Progress
}

final class FavoritesLoaderServiceImpl: FavoritesLoaderService {
    
    // MARK: - Private properties
    
    private let apiClient: Client
    private let persistentStore: PersistentStoreService
    
    // MARK: - Initialization
    
    init(apiClient: Client, persistentStore: PersistentStoreService) {
        self.apiClient = apiClient
        self.persistentStore = persistentStore
    }
    
    // MARK: - Public methods
    
    func fetchFavorites(
        page: Int,
        completion: @escaping (Result<[MovieDetails], Error>) -> Void) -> Progress {
        
        return apiClient.request(
            LoadFavouritesEndpoint(
                sessionID: persistentStore.value(for: .sessionID),
                accountID: persistentStore.value(for: .accountID),
                page: page),
            completionHandler: completion)
    }
}
