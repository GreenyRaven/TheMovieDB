//
//  SearchContainerViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 22.05.2021.
//

import TheMovieDBAPI
import UIKit

final class SearchContainerViewController: MoviesContainerViewController {
    
    // MARK: - Public properties
    
    weak var favoritesOuterUpdateDelegate: FavoritesOuterUpdateDelegate?
    
    // MARK: - Private properties
    
    private let searchResultsLoaderService: SearchMoviesService
    private var currentSearchTerm: String = ""
    private let searchResultsContentViewController = MoviesCollectionViewController(collectionPurpose: .search)
    private var favoriteList: [MovieDetails] = []
    
    // MARK: - Initialization
    
    init(searchResultsLoaderService: SearchMoviesService = ServiceLayer.shared.searchMoviesService) {
        self.searchResultsLoaderService = searchResultsLoaderService
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ContainerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsContentViewController.moviesCollectionDelegate = self
    }
    
    // MARK: - Private methods
    
    private func fetchSearchResults(for searchTerm: String, replaceExisting: Bool) {
        loadFavorites()
        guard !searchTerm.isEmpty else { return }
        let progress = searchResultsLoaderService.fetchMovies(
            searchTerm: searchTerm,
            page: loadedPages + 1) { [weak self] result in
            self?.handleFetchResult(result: result, replaceExisting: replaceExisting)
        }
        addDownloadsProgress(newProgress: progress)
    }
    
    private func loadFavorites() {
        let progress = favoritesLoaderService.fetchFavorites(page: loadedPages + 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                self.favoriteList = favorites
            case .failure(let error):
                guard let error = error as? TheMovieDBError else { return }
                self.handleFavoritesError(error: error)
            }
        }
        addDownloadsProgress(newProgress: progress)
    }
    
    private func handleFetchResult(result: Result<[MovieDetails], Error>, replaceExisting: Bool) {
        switch result {
        case .success(let loadedMovies) where !loadedMovies.isEmpty:
            handleLoadedMovies(loadedMovies, replaceExisting: replaceExisting, in: searchResultsContentViewController)
            fetchPosters(for: loadedMovies, in: searchResultsContentViewController)
            updateLoadedPages(to: loadedPages + 1)
        case .failure(let error):
            guard let error = error as? TheMovieDBError else { return }
            handleSearchError(error: error)
        default:
            if replaceExisting {
                setZeroScreen(for: nil)
            }
        }
    }
    
    private func setZeroScreen(for error: TheMovieDBError?) {
        let zeroScreen: ZeroScreenViewController
        switch error {
        case .none:
            zeroScreen = ZeroScreenViewController(zeroState: .noneFound, error: nil) {}
        case .some(let error):
            zeroScreen = ZeroScreenViewController(zeroState: .noneFound, error: error) { [weak self] in
                guard let self = self else { return }
                self.fetchSearchResults(for: self.currentSearchTerm, replaceExisting: false)
            }
        }
        setContent(zeroScreen)
    }
    
    private func handleFavoritesError(error: TheMovieDBError) {
        switch error {
        case .apiError(let apiError) where apiError.isReasonToSighOut:
            rootDelegate?.presentationRootController(self, didRequestUpdateFor: .locked)
        default:
            return
        }
    }
    
    private func handleSearchError(error: TheMovieDBError) {
        switch error {
        case .apiError(let apiError) where apiError.isReasonToSighOut:
            rootDelegate?.presentationRootController(self, didRequestUpdateFor: .locked)
        default:
            setZeroScreen(for: error)
        }
    }
}

// MARK: - SearchDelegate

extension SearchContainerViewController: SearchDelegate {
    
    func searchViewController(_ searchViewController: SearchViewController, requestedSearchWith searchTerm: String) {
        currentSearchTerm = searchTerm
        updateLoadedPages(to: 0)
        fetchSearchResults(for: searchTerm, replaceExisting: true)
    }
}

// MARK: - MoviesDelegate

extension SearchContainerViewController: MoviesDelegate {
    
    func moviesCollectionView(
        _ moviesCollectionView: MoviesCollectionViewController,
        userTappedOnMovie movie: FullMovieDetails) {
        
        let isFavorite = favoriteList.contains(where: { $0.id == movie.details.id })
        let movieDetailsViewController = MovieDetailsViewController(fullMovieDetails: movie, isFavorite: isFavorite)
        movieDetailsViewController.moviesCollectionDelegate = self
        containerDelegate?.containerViewController(self, requestedNavigationAppearanceFor: movieDetailsViewController)
    }
    
    func moviesViewController(
        _ viewController: UIViewController,
        userAddedMovieToFavorites movie: FullMovieDetails) {
        setMovieFavorite(movie, isNowFavorite: true, in: searchResultsContentViewController)
        favoritesOuterUpdateDelegate?.favoritesListAddedMovie(movie)
    }
    
    func moviesViewController(
        _ viewController: UIViewController,
        userRemovedMovieFromFavorites movie: FullMovieDetails) {
        setMovieFavorite(movie, isNowFavorite: false, in: searchResultsContentViewController)
        favoritesOuterUpdateDelegate?.favoritesListDeletedMovie(movie)
    }
    
    func moviesCollectionViewRequestedReload(_ moviesCollectionView: MoviesCollectionViewController) {
        updateLoadedPages(to: 0)
        fetchSearchResults(for: currentSearchTerm, replaceExisting: true)
    }
    
    func moviesCollectionViewRequestedNextPage(_ moviesCollectionView: MoviesCollectionViewController) {
        fetchSearchResults(for: currentSearchTerm, replaceExisting: false)
    }
}

// MARK: - AppearanceDelegate

extension SearchContainerViewController: AppearanceDelegate {
    
    func viewControllerToggleAppearance(_ viewController: ViewController) {
        searchResultsContentViewController.setAppearance(
            searchResultsContentViewController.appearance == .grid ? .list : .grid)
    }
}
