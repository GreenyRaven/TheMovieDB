//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 23.05.2021.
//

import TheMovieDBAPI
import UIKit

final class MovieDetailsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageCornerRadius: CGFloat = 8
        static let ratingTreshold = 6.5
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var originalName: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var overviewTextView: UITextView!
    @IBOutlet private var reviewsLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var genresLabel: UILabel!
    @IBOutlet private var favoriteButton: UIBarButtonItem!
    
    // MARK: - Public properties
    
    weak var moviesCollectionDelegate: MoviesDelegate?
    
    // MARK: - Private properties
    
    private let fullMovieDetails: FullMovieDetails
    private var isFavorite: Bool
    
    // MARK: - Initialization
    
    init(fullMovieDetails: FullMovieDetails, isFavorite: Bool) {
        self.fullMovieDetails = fullMovieDetails
        self.isFavorite = isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
        setupNavigationBar()
    }
    
    private func setupFields() {
        posterImageView.layer.cornerRadius = Constants.imageCornerRadius
        if let poster = fullMovieDetails.poster {
            posterImageView.image = UIImage(data: poster.posterImageData) ?? #imageLiteral(resourceName: "noneFound")
        }
        nameLabel.text = fullMovieDetails.details.title
        let releaseYear = fullMovieDetails.details.releaseYear ?? ""
        originalName.text = "\(fullMovieDetails.details.originalTitle ?? "")\(releaseYear)"
        durationLabel.text = "\(fullMovieDetails.details.runtime ?? 0)"
        overviewTextView.text = fullMovieDetails.details.overview
        reviewsLabel.text = "\(fullMovieDetails.details.voteCount ?? 0)"
        ratingLabel.text = "\(fullMovieDetails.details.voteAverage ?? 0.0)"
        ratingLabel.textColor = fullMovieDetails.details.voteAverage ?? 0.0 > Constants.ratingTreshold ? .green : .light
        if let genres = fullMovieDetails.details.genres {
            genresLabel.text = genres
                .compactMap { $0.name }
                .joined(separator: ", ")
        } else {
            genresLabel.text = " "
        }
    }
    
    private func setupNavigationBar() {
        let favoriteButton = UIBarButtonItem(
            image: isFavorite ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "notFavorite"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite))
        favoriteButton.tintColor = .light
        navigationItem.setRightBarButtonItems([favoriteButton], animated: true)
        self.favoriteButton = favoriteButton
        let backButtonWithSpacing = UIBarButtonItem(
            image: #imageLiteral(resourceName: "backButton"),
            style: .plain,
            target: self,
            action: #selector(closeScreen))
        navigationItem.setLeftBarButtonItems([backButtonWithSpacing], animated: true)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func toggleFavorite() {
        isFavorite ?
            moviesCollectionDelegate?.moviesViewController(self, userRemovedMovieFromFavorites: fullMovieDetails) :
            moviesCollectionDelegate?.moviesViewController(self, userAddedMovieToFavorites: fullMovieDetails)
        favoriteButton.image = isFavorite ? #imageLiteral(resourceName: "notFavorite") : #imageLiteral(resourceName: "favorite")
    }
    
    @objc private func closeScreen() {
        navigationController?.popViewController(animated: true)
    }
}
