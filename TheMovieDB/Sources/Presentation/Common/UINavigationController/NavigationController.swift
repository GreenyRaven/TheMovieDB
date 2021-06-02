//
//  NavigationController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

/// Базовый `UINavigationController`
final class NavigationController: UINavigationController {

    // MARK: - Private properties

    private static let largeTitleTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 32, weight: .bold),
        .foregroundColor: UIColor.light
    ]

    private static let titleTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 16),
        .foregroundColor: UIColor.light
    ]

    // MARK: - Public methods

    static func setupAppearance() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()

        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.configureWithTransparentBackground()
        compactAppearance.shadowImage = UIImage()

        [standardAppearance, compactAppearance].forEach {
            $0.setBackIndicatorImage(#imageLiteral(resourceName: "backButton"), transitionMaskImage: #imageLiteral(resourceName: "backButton"))
            $0.largeTitleTextAttributes = largeTitleTextAttributes
            $0.titleTextAttributes = titleTextAttributes
        }

        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().compactAppearance = compactAppearance
        UINavigationBar.appearance().tintColor = .bgBlack
    }
}
