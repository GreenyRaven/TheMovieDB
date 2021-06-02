//
//  ImagesLoaderService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 09.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Загрузка изображений
protocol ImagesLoaderService: AnyObject {
    
    /// Загрузка иконки профиля пользователя
    ///
    /// - Parameter completion: Иконка пользователя,  или описание возникшей ошибки `Error`
    /// - Returns: Прогресс выполнения запроса к серверу с возможностью отмены запроса
    @discardableResult
    func fetchUserIcon(iconHash: String, completion: @escaping (Result<UserIcon, Error>) -> Void) -> Progress
    
    /// Загрузка постера фильма
    /// - Parameters:
    ///   - filePath: Адрес изображения в API
    ///   - posterSize: Запрашиваемое разрешение изображения
    ///   - completion: Постер фильма, или описание возникшей ошибки `Error`
    func fetchPoster(
        filePath: String,
        posterSize: PosterSize,
        completion: @escaping (Result<MoviePoster, Error>) -> Void) -> Progress
}

final class ImagesLoaderServiceImpl: ImagesLoaderService {

    // MARK: - Private properties
    
    private let apiClient: Client
    
    // MARK: - Initialization
    
    init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public methods
    
    func fetchUserIcon(iconHash: String, completion: @escaping (Result<UserIcon, Error>) -> Void) -> Progress {
        return apiClient.request(LoadUserIconEndpoint(iconHash: iconHash), completionHandler: completion)
    }
    
    func fetchPoster(
        filePath: String,
        posterSize: PosterSize,
        completion: @escaping (Result<MoviePoster, Error>) -> Void) -> Progress {
        
        apiClient.request(
            LoadMoviePosterEndpoint(filePath: filePath, posterSize: posterSize), completionHandler: completion)
    }
}
