//
//  LogoutButton.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import UIKit

final class LogoutButton: AnimatedButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let standardBorderWidth: CGFloat = 0
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = Constants.standardBorderWidth
    }
}
