//
//  Cell+Identifier.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String { String(describing: type(of: self)).components(separatedBy: ".").first! }
}

extension UITableView {
    
    func register(reusableCell: Reusable.Type) {
        register(
            UINib(nibName: reusableCell.identifier, bundle: nil),
            forCellReuseIdentifier: reusableCell.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell & Reusable>(reusableCell: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Cell \(T.self) did not register")
        }
        return cell
    }
}

extension UICollectionView {
    
    func register(reusableCell: Reusable.Type) {
        register(
            UINib(nibName: reusableCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: reusableCell.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell & Reusable>(reusableCell: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Cell \(T.self) did not register")
        }
        return cell
    }
}
