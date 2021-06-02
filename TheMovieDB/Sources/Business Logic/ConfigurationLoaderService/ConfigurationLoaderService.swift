//
//  ConfigurationLoaderService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 18.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Загрузка данных конфигурации TheMovieDB
protocol ConfigurationLoaderService: AnyObject {
    
    /// Загрузка текущей конфигурации доступных жанров
    /// - Parameter completion: Отчет об успехе, или описание возникшей ошибки `Error`
    @discardableResult
    func fetchGenres(completion: @escaping (Result<Void, Error>) -> Void) -> Progress
    
    /// Загрузка текущей конфигурации API
    /// - Parameter completion: Отчет об успехе, или описание возникшей ошибки `Error`
    @discardableResult
    func fetchConfiguration(completion: @escaping (Result<Void, Error>) -> Void) -> Progress
}

final class ConfigurationLoaderServiceImpl: ConfigurationLoaderService {
    
    // MARK: - Private properties
    
    private let apiClient: Client
    
    // MARK: - Initialization
    
    init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public methods
    
    func fetchGenres(completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        apiClient.request(GenresEndpoint(), completionHandler: completion)
    }
    
    func fetchConfiguration(completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        apiClient.request(ConfigurationEndpoint(), completionHandler: completion)
    }
}
