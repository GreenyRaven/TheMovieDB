//
//  MoviesCollectionViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 16.05.2021.
//

import PaginationUIManager
import TheMovieDBAPI
import UIKit

/// Обработка нажатий кнопки смены режима отображения контента `MoviesCollectionViewController`
protocol AppearanceDelegate: AnyObject {
    
    /// Обработка нажатия на кнопку смены вида отображения контента
    /// - Parameter viewController: Контроллер, на котором располагается кнопка смена режима отображения
    func viewControllerToggleAppearance(_ viewController: ViewController)
}

/// Позволяет обрабатывать взаимодействия пользователя с отображенными на экране фильмами
protocol MoviesDelegate: AnyObject {
    
    /// Обработка нажатия на ячейку с фильмом
    /// - Parameters:
    ///   - moviesCollectionView: Контроллер отображения фильмов
    ///   - movie: Фильм, на который нажал пользователь
    func moviesCollectionView(
        _ moviesCollectionView: MoviesCollectionViewController,
        userTappedOnMovie movie: FullMovieDetails)
    
    /// Обработка добавления фильма в избранное
    /// - Parameters:
    ///   - moviesViewController: Контроллер, отображающий фильм(ы)
    ///   - movie: Фильм, который был добавлен в избxранное
    func moviesViewController(
        _ moviesViewController: UIViewController,
        userAddedMovieToFavorites movie: FullMovieDetails)
    
    /// Обработка удаления фильма из избранного
    /// - Parameters:
    ///   - moviesViewController: Контроллер, отображающий фильм(ы)
    ///   - movie: Фильм, который был удален из избранного
    func moviesViewController(
        _ moviesViewController: UIViewController,
        userRemovedMovieFromFavorites movie: FullMovieDetails)
    
    /// Обработка запроса на обновление страницы (скролл вверх выше края)
    /// - Parameter moviesCollectionView: Контроллер отображения фильмов
    func moviesCollectionViewRequestedReload(_ moviesCollectionView: MoviesCollectionViewController)
    
    /// Обработка запроса на загрузку следующей страницы (скролл вниз ниже края)
    /// - Parameter moviesCollectionView: Контроллер отображения фильмов
    func moviesCollectionViewRequestedNextPage(_ moviesCollectionView: MoviesCollectionViewController)
}

final class MoviesCollectionViewController: UICollectionViewController {
    
    // MARK: - Types
    
    /// Режим отображения контента в виде сетки или списка
    enum CollectionAppearance {
        case grid
        case list
    }
    
    /// Настройка контекстных меню в зависимости от наполнения контроллера
    enum MovieCollectionPurpose {
        case search
        case favorites
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let horizontalWidthMultiplier = 1
        static let verticalWidthMultiplier = 2
        static let cellSpacing = 12
        static let horizontalItemHeight = 96
        static let verticalItemHeight = 320
        static let interLineSpacing: CGFloat = 24
        static let contentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: - Public properties
    
    weak var moviesCollectionDelegate: MoviesDelegate?
    var appearance: CollectionAppearance = .grid
    private(set) var collectionPurpose: MovieCollectionPurpose
    
    // MARK: - Private properties
    
    private var loadedMovies: [FullMovieDetails] = []
    private var paginationManager: PaginationUIManager?
    
    // MARK: - Initialization
    
    init(collectionPurpose: MovieCollectionPurpose) {
        self.collectionPurpose = collectionPurpose
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        registerCells()
        setupPagination()
        paginationManager?.load {}
    }
    
    // MARK: - Public methods
    
    func setAppearance(_ appearance: CollectionAppearance) {
        self.appearance = appearance
        collectionView.reloadData()
    }
    
    func updateMovies(moviesData: [FullMovieDetails]) {
        loadedMovies.append(contentsOf: moviesData)
        collectionView.reloadData()
    }
    
    func updateMovie(movieData: FullMovieDetails) {
        guard let itemIndex = loadedMovies.firstIndex(where: { movieData.details.id == $0.details.id }) else { return }
        loadedMovies[itemIndex] = movieData
        collectionView.reloadItems(at: [IndexPath(item: itemIndex, section: 0)])
    }
    
    func removeMovie(movieData: FullMovieDetails) {
        guard let itemIndex = loadedMovies.firstIndex(where: { movieData.details.id == $0.details.id }) else { return }
        loadedMovies.remove(at: itemIndex)
        collectionView.deleteItems(at: [IndexPath(item: itemIndex, section: 0)])
    }
    
    func replaceMovies(moviesData: [FullMovieDetails]) {
        loadedMovies = moviesData
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        collectionView.contentInset = Constants.contentInsets
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.bgBlack
    }
    
    private func registerCells() {
        collectionView.register(reusableCell: HorizontalCollectionViewCell.self)
        collectionView.register(reusableCell: VerticalCollectionViewCell.self)
    }
    
    private func setupPagination() {
        paginationManager = PaginationUIManager(scrollView: collectionView, pullToRefreshType: .basic)
        paginationManager?.delegate = self
        collectionView.alwaysBounceVertical = true
    }
    
    private func executeWithDelay(_ delay: Double, execute action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: action)
    }
}

// MARK: - UICollectionViewDataSource

extension MoviesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        loadedMovies.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieCollectionPresentable = appearance == .grid
            ? collectionView.dequeueReusableCell(reusableCell: VerticalCollectionViewCell.self, indexPath: indexPath)
            : collectionView.dequeueReusableCell(reusableCell: HorizontalCollectionViewCell.self, indexPath: indexPath)
        cell.configure(
            movieDetails: loadedMovies[indexPath.row].details,
            moviePoster: loadedMovies[indexPath.row].poster)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MoviesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moviesCollectionDelegate?.moviesCollectionView(self, userTappedOnMovie: loadedMovies[indexPath.row])
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ -> UIMenu? in
            guard let self = self else { return nil }
            switch self.collectionPurpose {
            case .favorites:
                let deleteAction = UIAction(title: "Удалить из избранного", attributes: .destructive, state: .off) {_ in
                    self.moviesCollectionDelegate?.moviesViewController(
                        self,
                        userRemovedMovieFromFavorites: self.loadedMovies[indexPath.row])
                }
                return UIMenu(title: "", children: [deleteAction])
            case .search:
                let favoritesAction = UIAction(title: "Добавить в избранное", state: .off) { _ in
                    self.moviesCollectionDelegate?.moviesViewController(
                        self,
                        userAddedMovieToFavorites: self.loadedMovies[indexPath.row])
                }
                return UIMenu(title: "", children: [favoritesAction])
            }
        }
        return config
    }
}

// MARK: - UICollectionViewFlowLayoutDelegate

extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = collectionView.frame.size.width
        switch appearance {
        case .grid:
            let itemWidth = (Int(collectionWidth) / Constants.verticalWidthMultiplier) - Constants.cellSpacing
            return CGSize(width: itemWidth, height: Constants.verticalItemHeight)
        case .list:
            return CGSize(width: Int(collectionView.frame.size.width), height: Constants.horizontalItemHeight)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Constants.interLineSpacing
    }
}

// MARK: - PaginationUIManagerDelegate

extension MoviesCollectionViewController: PaginationUIManagerDelegate {
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        moviesCollectionDelegate?.moviesCollectionViewRequestedReload(self)
        executeWithDelay(1) { completion(true) }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        moviesCollectionDelegate?.moviesCollectionViewRequestedNextPage(self)
        executeWithDelay(1) { completion(true) }
    }
}
