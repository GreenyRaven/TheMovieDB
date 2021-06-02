//
//  FavouritesViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

final class FavouritesViewController: ViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let navigationTitle = "Избранное"
        static let navigationLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var favoritesContainerView: UIView!
    
    // MARK: - Public properties
    
    weak var favoritesOuterUpdateDelegate: FavoritesOuterUpdateDelegate?
    
    // MARK: - Private properties
    
    private weak var favoritesAppearanceDelegate: AppearanceDelegate?
    private let favoritesContainerViewController = FavoritesContainerViewController()
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setDelegates()
        add(childViewController: favoritesContainerViewController, to: favoritesContainerView)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.directionalLayoutMargins = Constants.navigationLayoutMargins
        title = Constants.navigationTitle
        let searchButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "searchBarButton"),
            style: .plain,
            target: self,
            action: #selector(openSearch))
        searchButton.tintColor = .light
        let appearanceButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "gridAppearance"),
            style: .plain,
            target: self,
            action: #selector(toggleAppearance))
        appearanceButton.tintColor = .light
        let rightSpacing = UIBarButtonItem(customView: UIView())
        navigationItem.setRightBarButtonItems([rightSpacing, appearanceButton, searchButton], animated: false)
    }
    
    private func setDelegates() {
        favoritesContainerViewController.rootDelegate = rootDelegate
        favoritesAppearanceDelegate = favoritesContainerViewController
        favoritesContainerViewController.containerDelegate = self
        favoritesOuterUpdateDelegate = favoritesContainerViewController
    }
    
    @objc private func openSearch() {
        let searchController = SearchViewController()
        searchController.modalTransitionStyle = .crossDissolve
        searchController.modalPresentationStyle = .fullScreen
        searchController.favoritesOuterUpdateDelegate = favoritesContainerViewController
        present(NavigationController(rootViewController: searchController), animated: true)
    }
    
    @objc private func toggleAppearance(_ sender: UIBarButtonItem) {
        favoritesAppearanceDelegate?.viewControllerToggleAppearance(self)
        sender.image = sender.image == #imageLiteral(resourceName: "listAppearance") ? #imageLiteral(resourceName: "gridAppearance") : #imageLiteral(resourceName: "listAppearance")
    }
}

// MARK: - ContainerDelegate

extension FavouritesViewController: ContainerDelegate {
    
    func containerViewController(
        _ containerViewController: ContainerViewController,
        requestedNavigationAppearanceFor controller: UIViewController) {
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension FavouritesViewController: UIGestureRecognizerDelegate {}
