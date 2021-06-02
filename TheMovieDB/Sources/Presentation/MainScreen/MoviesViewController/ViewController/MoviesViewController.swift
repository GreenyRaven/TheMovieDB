//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

final class MoviesViewController: ViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let shortDuration: Double = 0.25
        static let longDuration: Double = 0.5
        static let minAlpha: CGFloat = 0.15
        static let longDelay: Double = 0.5
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var mainTitleLabel: UILabel!
    @IBOutlet private var searchField: UITextField!
    
    // MARK: - Public properties
    
    weak var favoritesOuterUpdateDelegate: FavoritesOuterUpdateDelegate?
    
    // MARK: - Private methods
    
    private func animateMainScreenTransition() {
        UIView.animate(
            withDuration: Constants.longDuration,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut]) { [weak self] in
            
            guard let self = self else { return }
            self.searchField.transform = CGAffineTransform(
                translationX: 0,
                y: self.view.frame.minY - self.searchField.frame.maxY)
            self.searchField.alpha = Constants.minAlpha
            self.mainTitleLabel.alpha = Constants.minAlpha
            
        }
    }
    
    private func presentSearchController(_ searchController: SearchViewController) {
        present(NavigationController(rootViewController: searchController), animated: true) { [weak self] in
            UIView.animate(withDuration: Constants.shortDuration, delay: 0, options: .allowUserInteraction) {
                self?.searchField.alpha = 0
                searchController.view.alpha = 1
            }
            self?.restoreMainScreenLooks()
        }
    }
    
    private func restoreMainScreenLooks() {
        UIView.animate(
            withDuration: Constants.shortDuration,
            delay: Constants.longDelay,
            options: [.allowUserInteraction]) { [weak self] in
            
            self?.searchField.transform = .identity
            self?.searchField.alpha = 1
            self?.mainTitleLabel?.alpha = 1
        }
    }
}

// MARK: - UITextFieldDelegate

extension MoviesViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchController = SearchViewController()
        searchController.modalTransitionStyle = .crossDissolve
        searchController.modalPresentationStyle = .fullScreen
        searchController.favoritesOuterUpdateDelegate = favoritesOuterUpdateDelegate
        searchController.view.alpha = 0
        animateMainScreenTransition()
        presentSearchController(searchController)
        return false
    }
}
