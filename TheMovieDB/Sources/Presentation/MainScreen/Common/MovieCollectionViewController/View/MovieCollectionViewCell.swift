//
//  MovieCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 21.05.2021.
//

import TheMovieDBAPI
import UIKit

protocol MovieCollectionViewCell: UICollectionViewCell, Reusable {
    
    // MARK: - IBOutlets
    
    var movieThumbImageView: UIImageView! { get set }
    var namePrimaryLabel: UILabel! { get set }
    var nameSecondaryLabel: UILabel! { get set }
    var genresLabel: UILabel! { get set }
    var ratingLabel: UILabel! { get set }
    var reviewsCountLabel: UILabel! { get set }
    var durationLabel: UILabel! { get set }
    
    // MARK: - Public propeties
    
    var movieID: Int? { get set }
    
    // MARK: - Public methods
    
    func configure(movieDetails: MovieDetails, moviePoster: MoviePoster?)
    
    func setImageBorders(radius: CGFloat, borderWidth: CGFloat)
}

extension MovieCollectionViewCell {
    
    func configure(movieDetails: MovieDetails, moviePoster: MoviePoster?) {
        setImageBorders()
        if movieID == nil ||
            movieDetails.id != movieID {
            movieID = movieDetails.id
            namePrimaryLabel.text = movieDetails.title
            nameSecondaryLabel.text = movieDetails.originalTitle
            ratingLabel.text = "\(movieDetails.voteAverage ?? 0.0)"
            ratingLabel.textColor = movieDetails.voteAverage ?? 0.0 > 6.5 ? .green : .light
            reviewsCountLabel.text = "\(movieDetails.voteCount ?? 0)"
            durationLabel.text = "\(movieDetails.runtime ?? 0) мин"
            if let genres = movieDetails.genres {
                genresLabel.text = genres.reduce(into: "") { result, element in
                    result?.append("\(element.name ?? "") ")
                }
            } else {
                genresLabel.text = " "
            }
        }
        guard let poster = moviePoster else {
            movieThumbImageView.image = #imageLiteral(resourceName: "noneFound")
            return
        }
        movieThumbImageView.image = UIImage(data: poster.posterImageData)
    }
    
    func setImageBorders(radius: CGFloat = 6, borderWidth: CGFloat = 2) {
        movieThumbImageView.layer.borderWidth = borderWidth
        movieThumbImageView.layer.borderColor = UIColor.bgBlack.cgColor
        movieThumbImageView.layer.cornerRadius = radius
    }
}
