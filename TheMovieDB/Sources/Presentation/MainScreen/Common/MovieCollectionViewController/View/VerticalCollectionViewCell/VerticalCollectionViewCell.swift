//
//  VerticalCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 16.05.2021.
//

import TheMovieDBAPI
import UIKit

final class VerticalCollectionViewCell: UICollectionViewCell, Reusable, MovieCollectionPresentable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 2
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var movieThumbImageView: UIImageView!
    @IBOutlet private var namePrimaryLabel: UILabel!
    @IBOutlet private var nameSecondaryLabel: UILabel!
    @IBOutlet private var genresLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var reviewsCountLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    
    // MARK: - Public properties
    
    var movieID: Int?
    var movieThumbImage: UIImage? {
        get {
            movieThumbImageView.image
        }
        set {
            movieThumbImageView.image = newValue
        }
    }
    
    var name: String? {
        get {
            namePrimaryLabel.text
        }
        set {
            namePrimaryLabel.text = newValue
        }
    }
    
    var originalName: String? {
        get {
            nameSecondaryLabel.text
        }
        set {
            nameSecondaryLabel.text = newValue
        }
    }
    
    var genres: String? {
        get {
            genresLabel.text
        }
        set {
            genresLabel.text = newValue
        }
    }
    
    var rating: String? {
        get {
            ratingLabel.text
        }
        set {
            ratingLabel.text = newValue
            guard
                let newRatingString = newValue,
                let rating = Double(newRatingString)
            else {
                ratingLabel.textColor = .light
                return
            }
            ratingLabel.textColor = rating > MovieCollectionConstants.ratingTreshold
                ? .green
                : .light
        }
    }
    
    var reviewCount: String? {
        get {
            reviewsCountLabel.text
        }
        set {
            reviewsCountLabel.text = newValue
        }
    }
    
    var duration: String? {
        get {
            durationLabel.text
        }
        set {
            durationLabel.text = newValue
        }
    }
    
    // MARK: - UICollectionView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setImageBorders(radius: Constants.cornerRadius, borderWidth: Constants.borderWidth)
    }
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? scaleIn() : scaleOut()
        }
    }
    
    // MARK: - Private methods
    
    private func setImageBorders(radius: CGFloat, borderWidth: CGFloat) {
        movieThumbImageView.layer.borderWidth = borderWidth
        movieThumbImageView.layer.borderColor = UIColor.bgBlack.cgColor
        movieThumbImageView.layer.cornerRadius = radius
    }
}
