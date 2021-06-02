//
//  MoviesContainerViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 25.05.2021.
//

import TheMovieDBAPI
import UIKit

class MoviesContainerViewController: ContainerViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let mediaIDMissingError = "Внутренняя ошибка сервера"
    }
    
    // MARK: - Public properties
    
    private(set) var downloadsProgress: [Progress] = []
    private(set) var favoritesLoaderService: FavoritesLoaderService
    private(set) var favoritesManageService: FavoritesManageService
    private(set) var imagesLoaderService: ImagesLoaderService
    private(set) var loadedPages = 0
    
    // MARK: - Initialization
    
    init(
        favoritesLoaderService: FavoritesLoaderService = ServiceLayer.shared.favoritesLoaderService,
        favoritesManageService: FavoritesManageService = ServiceLayer.shared.favoritesManageService,
        imagesLoaderService: ImagesLoaderService = ServiceLayer.shared.imagesLoaderService) {
        
        self.favoritesLoaderService = favoritesLoaderService
        self.favoritesManageService = favoritesManageService
        self.imagesLoaderService = imagesLoaderService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        downloadsProgress.forEach {
            $0.cancel()
        }
    }
    
    // MARK: - Public methods
    
    func handleLoadedMovies(
        _ loadedMovies: [MovieDetails],
        replaceExisting: Bool,
        in movieCollectionController: MoviesCollectionViewController) {
        
        let moviesData = loadedMovies.map { details in
            FullMovieDetails(details: details, poster: nil)
        }
        setContent(movieCollectionController)
        
        replaceExisting
            ? movieCollectionController.replaceMovies(moviesData: moviesData)
            : movieCollectionController.updateMovies(moviesData: moviesData)
        if movieCollectionController.collectionPurpose == .search && replaceExisting {
            movieCollectionController.collectionView.scrollToItem(
                at: IndexPath(item: 0, section: 0),
                at: .bottom,
                animated: true)
        }
    }
    
    func fetchPosters(
        for movies: [MovieDetails],
        in movieCollectionController: MoviesCollectionViewController) {
        
        movies.forEach { movie in
            fetchPoster(for: movie, in: movieCollectionController, quality: .thumb) { [weak self] in
                self?.fetchPoster(for: movie, in: movieCollectionController, quality: .compressed, completion: nil)
            }
        }
    }
    
    func fetchPoster(
        for movieDetails: MovieDetails,
        in movieCollectionController: MoviesCollectionViewController,
        quality: PosterSize,
        completion: (() -> Void)?) {
        
        guard let posterPath = movieDetails.posterPath else { return }
        let progress = imagesLoaderService.fetchPoster(
            filePath: posterPath,
            posterSize: quality) { result in
            switch result {
            case .success(let poster):
                movieCollectionController.updateMovie(
                    movieData: FullMovieDetails(details: movieDetails, poster: poster))
                completion?()
            case .failure:
                return
            }
        }
        downloadsProgress.append(progress)
    }
    
    func setMovieFavorite(
        _ movie: FullMovieDetails,
        isNowFavorite favorite: Bool,
        in movieCollectionController: MoviesCollectionViewController) {
        
        guard let mediaID = movie.details.id else {
            showAlert(with: Constants.mediaIDMissingError)
            return
        }
        favoritesManageService.setMovieFavorite(
            mediaType: .movie,
            mediaID: mediaID,
            favorite: favorite) { [weak self] result in
            
            switch result {
            case .success where movieCollectionController.collectionPurpose == .favorites:
                favorite
                    ? movieCollectionController.updateMovies(moviesData: [movie])
                    : movieCollectionController.removeMovie(movieData: movie)
            case .failure(let error):
                guard let error = error as? TheMovieDBError else { return }
                self?.showAlert(with: error.description)
            default:
                return
            }
        }
    }
    
    func updateLoadedPages(to newValue: Int) {
        loadedPages = newValue
    }
    
    func addDownloadsProgress(newProgress: Progress) {
        downloadsProgress.append(newProgress)
    }
}
