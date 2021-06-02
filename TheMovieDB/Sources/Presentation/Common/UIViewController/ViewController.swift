//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import TheMovieDBAPI
import UIKit

/// Базовый `UIViewController` с поддержкой автоматического завершения запросов к сети
class ViewController: UIViewController {
    
    // MARK: - Public properties
    
    var progress: Progress?
    weak var rootDelegate: PresentationRootDelegate?
    
    // MARK: Initialization
    
    deinit {
        progress?.cancel()
    }
    
    // MARK: - Public methods
    
    func showAlert(with description: String) {
        let alert = UIAlertController(
            title: "Ошибка!",
            message: description,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "Ок",
            style: .cancel,
            handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
