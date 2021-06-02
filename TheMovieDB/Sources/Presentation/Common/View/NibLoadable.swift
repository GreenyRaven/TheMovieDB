//
//  NibLoadable.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

// MARK: - NibLoadable

/// Позволяет загружать `UIVIew` из `xib` с идентичным именем
protocol NibLoadable: AnyObject {
    
    // MARK: - Public properties
    
    static var className: String { get }
    
    static var nib: UINib { get }
    
    // MARK: - Public methods
    
    static func loadFromNib() -> Self
}

// MARK: - NibLoadable Impl

extension NibLoadable where Self: UIView {
    
    // MARK: - Public properties
    
    static var className: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: className, bundle: nil)
    }
    
    // MARK: - Public methods
    
    static func loadFromNib() -> Self {
        let results: [Any] = nib.instantiate(withOwner: self, options: nil)
        for result in results {
            if let view = result as? Self {
                return view
            }
        }
        fatalError("Failed to load \(className) from nib")
    }
}
