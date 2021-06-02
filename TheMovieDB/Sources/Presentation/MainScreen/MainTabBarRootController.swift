//
//  MainScreenRootController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

final class MainTabBarRootController: UITabBarController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let moviesControllerTitle = "Фильмы"
        static let favouritesControllerTitle = "Избранное"
        static let profileControllerTitle = "Профиль"
    }
    
    // MARK: - Initialization
    
    convenience init(rootDelegate: PresentationRootDelegate) {
        self.init()
        
        let favouritesViewController = FavouritesViewController()
        favouritesViewController.rootDelegate = rootDelegate
        let moviesViewController = MoviesViewController()
        moviesViewController.rootDelegate = rootDelegate
        let profileViewController = ProfileViewController()
        profileViewController.rootDelegate = rootDelegate
        
        tabBar.barTintColor = .darkBlue
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .light
        moviesViewController.tabBarItem = UITabBarItem(
            title: Constants.moviesControllerTitle,
            image: #imageLiteral(resourceName: "movies"),
            tag: 0)
        favouritesViewController.tabBarItem = UITabBarItem(
            title: Constants.favouritesControllerTitle,
            image: #imageLiteral(resourceName: "favourite"),
            tag: 1)
        profileViewController.tabBarItem = UITabBarItem(
            title: Constants.profileControllerTitle,
            image: #imageLiteral(resourceName: "account"),
            tag: 2)
        viewControllers = [
            NavigationController(rootViewController: moviesViewController),
            NavigationController(rootViewController: favouritesViewController),
            profileViewController
        ]
        
        moviesViewController.favoritesOuterUpdateDelegate = favouritesViewController.favoritesOuterUpdateDelegate
    }
}
