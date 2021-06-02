//
//  Cell+Scaling.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 25.05.2021.
//

import UIKit

extension UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let standardDuration = 0.2
        static let scaleMultiplier: CGFloat = 0.97
    }
    
    // MARK: - Public methods
    
    func scaleIn() {
        UIView.animate(
            withDuration: Constants.standardDuration,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseIn]) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: Constants.scaleMultiplier, y: Constants.scaleMultiplier)
        }
    }
    
    func scaleOut() {
        UIView.animate(
            withDuration: Constants.standardDuration,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut]) { [weak self] in
            self?.transform = .identity
        }
    }
}
