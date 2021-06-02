//
//  FavoritesManageService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Управление списком избранных фильмов
protocol FavoritesManageService: AnyObject {
    
    ///   Добавление или удаление фильма из списка избранного
    
    /// - Parameters:
    ///   - accountID: Идентификатор аккаунта пользователя
    ///   - mediaType: Тип медиаобьекта: `movie` или `tv`
    ///   - mediaID: Идентификатор медиаобьекта
    ///   - favourite: Добавить или удалить из избранного
    ///   - completion: Отчет об успехе, или описание возникшей ошибки `Error`
    @discardableResult
    func setMovieFavorite(
        mediaType: MediaType,
        mediaID: Int,
        favorite: Bool,
        completion: @escaping (Result<Void, Error>) -> Void) -> Progress
}

// MARK: - MediaType

/// Тип медиа, с которым решил взаимодействовать пользователь. Фильм или ТВ-программа
public enum MediaType: String {
    case movie = "movie"
    case tvShow = "tv"
}

final class FavoritesManageServiceImpl: FavoritesManageService {
    
    // MARK: - Private properties
    
    private let apiClient: Client
    private let persistentStore: PersistentStoreService
    
    // MARK: - Initialization
    
    init(apiClient: Client, persistentStore: PersistentStoreService) {
        self.apiClient = apiClient
        self.persistentStore = persistentStore
    }
    
    // MARK: - Public methods
    
    func setMovieFavorite(
        mediaType: MediaType,
        mediaID: Int,
        favorite: Bool,
        completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        
        return apiClient.request(
            ManageFavoritesEndpoint(
                sessionID: persistentStore.value(for: .sessionID),
                accountID: persistentStore.value(for: .accountID),
                mediaType: mediaType.rawValue,
                mediaID: mediaID,
                favorite: favorite),
            completionHandler: completion)
    }
}
