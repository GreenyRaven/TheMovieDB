//
//  LoginButton.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

final class LoginButton: AnimatedButton {
    
    override var isEnabled: Bool {
        didSet {
            setTitleColor(isEnabled ? .light : .gray, for: .normal)
            backgroundColor = isEnabled ? .orange : .darkBlue
            layer.borderColor = isEnabled ? UIColor.orange.cgColor : UIColor.darkBlue.cgColor
        }
    }
}
