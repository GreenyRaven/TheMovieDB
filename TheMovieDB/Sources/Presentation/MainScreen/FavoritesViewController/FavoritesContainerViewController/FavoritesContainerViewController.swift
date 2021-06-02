//
//  FavoritesContainerViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 20.05.2021.
//

import TheMovieDBAPI
import UIKit

/// Позволяет обновить отображаемое содержимое списка избранного извне экрана избранного
protocol FavoritesOuterUpdateDelegate: AnyObject {
    
    /// Фильм был добавлен в избранное
    /// - Parameter movie: Данные фильма
    func favoritesListDeletedMovie(_ movie: FullMovieDetails)
    
    /// Фильм был удален из избранного
    /// - Parameter movie: Данные фильма
    func favoritesListAddedMovie(_ movie: FullMovieDetails)
}

final class FavoritesContainerViewController: MoviesContainerViewController {
    
    // MARK: - Private properties
    
    private let favoritesContentViewController = MoviesCollectionViewController(collectionPurpose: .favorites)
    
    // MARK: - ContainerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesContentViewController.moviesCollectionDelegate = self
        setContent(favoritesContentViewController)
    }
    
    // MARK: - Private methods
    
    private func fetchFavorites(replaceExisting: Bool) {
        let progress = favoritesLoaderService.fetchFavorites(page: loadedPages + 1) { [weak self] result in
            self?.handleFetchResult(result: result, replaceExisting: replaceExisting)
        }
        addDownloadsProgress(newProgress: progress)
    }
    
    private func handleFetchResult(result: Result<[MovieDetails], Error>, replaceExisting: Bool) {
        switch result {
        case .success(let loadedMovies) where !loadedMovies.isEmpty:
            handleLoadedMovies(loadedMovies, replaceExisting: replaceExisting, in: favoritesContentViewController)
            fetchPosters(for: loadedMovies, in: favoritesContentViewController)
            updateLoadedPages(to: loadedPages + 1)
        case .failure(let error):
            guard let error = error as? TheMovieDBError else { return }
            handleError(error: error)
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
            zeroScreen = ZeroScreenViewController(zeroState: .emptyCollection, error: nil) { [weak self] in
                self?.present(SearchViewController(), animated: true)
            }
        case .some(let error):
            zeroScreen = ZeroScreenViewController(zeroState: .emptyCollection, error: error) { [weak self] in
                guard let self = self else { return }
                self.fetchFavorites(replaceExisting: false)
            }
        }
        setContent(zeroScreen)
    }
    
    private func handleError(error: TheMovieDBError) {
        switch error {
        case .apiError(let apiError) where apiError.isReasonToSighOut:
            rootDelegate?.presentationRootController(self, didRequestUpdateFor: .locked)
        default:
            setZeroScreen(for: error)
        }
    }
}

// MARK: - MoviesDelegate

extension FavoritesContainerViewController: MoviesDelegate {
    
    func moviesCollectionViewRequestedReload(_ moviesCollectionView: MoviesCollectionViewController) {
        updateLoadedPages(to: 0)
        fetchFavorites(replaceExisting: true)
    }
    
    func moviesCollectionViewRequestedNextPage(_ moviesCollectionView: MoviesCollectionViewController) {
        fetchFavorites(replaceExisting: false)
    }
    
    func moviesCollectionView(
        _ moviesCollectionView: MoviesCollectionViewController,
        userTappedOnMovie movie: FullMovieDetails) {
        
        let movieDetailsViewController = MovieDetailsViewController(fullMovieDetails: movie, isFavorite: true)
        movieDetailsViewController.moviesCollectionDelegate = self
        containerDelegate?.containerViewController(self, requestedNavigationAppearanceFor: movieDetailsViewController)
    }
    
    func moviesViewController(
        _ moviesViewController: UIViewController,
        userAddedMovieToFavorites movie: FullMovieDetails) {
        
        setMovieFavorite(movie, isNowFavorite: true, in: favoritesContentViewController)
    }
    
    func moviesViewController(
        _ moviesViewController: UIViewController,
        userRemovedMovieFromFavorites movie: FullMovieDetails) {
        
        setMovieFavorite(movie, isNowFavorite: false, in: favoritesContentViewController)
    }
}

// MARK: - AppearanceDelegate

extension FavoritesContainerViewController: AppearanceDelegate {
    
    func viewControllerToggleAppearance(_ viewController: ViewController) {
        favoritesContentViewController.setAppearance(favoritesContentViewController.appearance == .grid ? .list : .grid)
    }
}

// MARK: - FavoritesOuterUpdateDelegate

extension FavoritesContainerViewController: FavoritesOuterUpdateDelegate {
    
    func favoritesListDeletedMovie(_ movie: FullMovieDetails) {
        favoritesContentViewController.removeMovie(movieData: movie)
    }
    
    func favoritesListAddedMovie(_ movie: FullMovieDetails) {
        favoritesContentViewController.updateMovies(moviesData: [movie])
    }
}
