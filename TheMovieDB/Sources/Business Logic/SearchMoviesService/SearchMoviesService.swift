//
//  SearchMoviesService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Загрузка данных фильмов в ходе поиска по ключевому слову
protocol SearchMoviesService: AnyObject {
    
    /// Загрузка данных фильмов в ходе поиска по ключевому слову
    /// - Parameters:
    ///   - searchTerm: Ключевое слово для осуществления поиска длиной один или более символов
    ///   - page: Страница результатов поиска
    ///   - completion: Полученные данные фильмов,  или описание возникшей ошибки `Error`
    /// - Returns: Прогресс выполнения запроса к серверу с возможностью отмены запроса
    @discardableResult
    func fetchMovies(
        searchTerm: String,
        page: Int,
        completion: @escaping (Result<[MovieDetails], Error>) -> Void) -> Progress
}

final class SearchMoviesServiceImpl: SearchMoviesService {
    
    // MARK: - Private properties
    
    private let apiClient: Client
    
    // MARK: - Initialization
    
    init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public methods
    
    func fetchMovies(
        searchTerm: String,
        page: Int,
        completion: @escaping (Result<[MovieDetails], Error>) -> Void) -> Progress {
        
        return apiClient.request(
            SearchForMoviesEndpoint(searchTerm: searchTerm, page: page), completionHandler: completion)
    }
}
