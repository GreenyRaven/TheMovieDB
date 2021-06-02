//
//  PincodeButton.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 08.05.2021.
//

import UIKit

final class PincodeButton: UIButton, NibLoadable {

    // MARK: - Constants
    
    private enum Constants {
        static let standardDuration = 0.2
        static let scaleMultiplier: CGFloat = 0.95
        static let alphaMin: CGFloat = 0
        static let alphaMax: CGFloat = 1.0
    }
            
    // MARK: - Private properties
    
    private var customImageView = UIImageView(image: #imageLiteral(resourceName: "bigOrangeEllipse"))
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupImageView()
    }
    
    private func setupImageView() {
        customImageView.contentMode = .center
        customImageView.backgroundColor = .clear
        customImageView.alpha = Constants.alphaMin
        addSubview(customImageView, with: self)
    }
    
    // MARK: - UIButton
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: Constants.standardDuration,
                delay: 0,
                options: [.allowUserInteraction, .curveEaseIn]) {
                
                self.customImageView.alpha = self.isHighlighted ? Constants.alphaMax : Constants.alphaMin
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: Constants.scaleMultiplier, y: Constants.scaleMultiplier)
                    : .identity
            }
        }
    }
}
