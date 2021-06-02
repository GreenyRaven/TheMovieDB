//
//  MovieLoaderService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Загрузка данных фильма
protocol MovieLoaderService: AnyObject {
    
    /// Загрузка данных фильма
    /// - Parameters:
    ///   - movieID: Идентификатор фильма
    ///   - completion: Полученные данные фильма,  или описание возникшей ошибки `Error`
    /// - Returns: Прогресс выполнения запроса к серверу с возможностью отмены запроса
    @discardableResult
    func fetchMovie(
        movieID: Int,
        completion: @escaping (Result<MovieDetails, Error>) -> Void) -> Progress
}

final class MovieLoaderServiceImpl: MovieLoaderService {
    
    // MARK: - Private properties
    
    private let apiClient: Client
    
    // MARK: - Initialization
    
    init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public methods
    
    func fetchMovie(movieID: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) -> Progress {
        return apiClient.request(LoadMovieEndpoint(movieID: movieID), completionHandler: completion)
    }
}
