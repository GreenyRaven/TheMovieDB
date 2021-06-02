//
//  MovieCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 21.05.2021.
//

import TheMovieDBAPI
import UIKit

protocol MovieCollectionPresentable: UICollectionViewCell {
    
    // MARK: - Public propeties
    
    var movieID: Int? { get set }
    var movieThumbImage: UIImage? { get set }
    var name: String? { get set }
    var originalName: String? { get set }
    var genres: String? { get set }
    var rating: String? { get set }
    var reviewCount: String? { get set }
    var duration: String? { get set }
    
    // MARK: - Public methods
    
    func configure(movieDetails: MovieDetails, moviePoster: MoviePoster?)
}

extension MovieCollectionPresentable {
    
    func configure(movieDetails: MovieDetails, moviePoster: MoviePoster?) {
        if movieID == nil ||
            movieDetails.id != movieID {
            movieID = movieDetails.id
            name = movieDetails.title
            originalName = movieDetails.originalTitle
            rating = "\(movieDetails.voteAverage ?? 0.0)"
            reviewCount = "\(movieDetails.voteCount ?? 0)"
            duration = "\(movieDetails.runtime ?? 0) мин"
            if let genres = movieDetails.genres {
                self.genres = genres
                    .compactMap { $0.name }
                    .joined(separator: ", ")
            } else {
                genres = " "
            }
        }
        guard let poster = moviePoster else {
            movieThumbImage = #imageLiteral(resourceName: "noneFound")
            return
        }
        movieThumbImage = UIImage(data: poster.posterImageData)
    }
}
