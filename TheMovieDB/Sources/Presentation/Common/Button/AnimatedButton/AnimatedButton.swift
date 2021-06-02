//
//  AnimatedButton.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import UIKit

class AnimatedButton: UIButton, NibLoadable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let standardCornerRadius: CGFloat = 5
        static let standardBorderWidth: CGFloat = 1
        static let standardDuration = 0.15
        static let scaleMultiplier: CGFloat = 0.95
        static let alphaMin: CGFloat = 0.7
        static let alphaMax: CGFloat = 1.0
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = Constants.standardBorderWidth
        layer.cornerRadius = Constants.standardCornerRadius
    }
    
    // MARK: - UIButton
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: Constants.standardDuration,
                delay: 0,
                options: [.allowUserInteraction, .curveEaseIn]) {
                self.alpha = self.isHighlighted ? Constants.alphaMin : Constants.alphaMax
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: Constants.scaleMultiplier, y: Constants.scaleMultiplier)
                    : .identity
            }
        }
    }
}
