//
//  ServiceLayer.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import Apexy
import TheMovieDBAPI

/// Осуществляет доступ к сервисам
final class ServiceLayer {
    
    // MARK: - Public properties
    
    static let shared = ServiceLayer()
    
    // MARK: - Private properties
    
    private(set) var configuration: URLSessionConfiguration = .ephemeral
    private(set) lazy var apiClient: Client = {
        return URLSessionClient(
            baseURL: ApiConstants.baseURL,
            configuration: configuration,
            responseObserver: { [weak self] _, _, _, error in
                self?.validateSession(responseError: error)
            })
    }()
    private let persistentStore: PersistentStoreService = PersistentStoreServiceImpl()
    private(set) lazy var movieLoaderService = MovieLoaderServiceImpl(apiClient: apiClient)
    private(set) lazy var biometricAuthService = BiometricAuthServiceImpl()
    private(set) lazy var persistentStoreService = PersistentStoreServiceImpl()
    private(set) lazy var configurationLoaderService = ConfigurationLoaderServiceImpl(apiClient: apiClient)
    private(set) lazy var imagesLoaderService = ImagesLoaderServiceImpl(apiClient: apiClient)
    private(set) lazy var favoritesManageService = FavoritesManageServiceImpl(
        apiClient: apiClient,
        persistentStore: persistentStore)
    private(set) lazy var favoritesLoaderService = FavoritesLoaderServiceImpl(
        apiClient: apiClient,
        persistentStore: persistentStore)
    private(set) lazy var authService = AuthenticationServiceImpl(
        apiClient: apiClient,
        persistentStore: persistentStore)
    private(set) lazy var userProfileService = UserProfileServiceImpl(
        apiClient: apiClient,
        persistentStore: persistentStore)
    private(set) lazy var searchMoviesService = SearchMoviesServiceImpl(apiClient: apiClient)
    
    // MARK: - Private methods
    
    private func deauthorize() {
        authService.signOut()
    }
    
    private func validateSession(responseError: Error?) {
        guard
            let error = responseError as? APIError,
            [3, 7, 30].contains(error.statusCode)
        else {
            return
        }
        deauthorize()
    }
}
