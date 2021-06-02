//
//  SearchViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 22.05.2021.
//

import UIKit

/// Обработка событий поля поиска
protocol SearchDelegate: AnyObject {
    
    /// Обработка запроса поиска по ключевому слову
    /// - Parameters:
    ///   - searchViewController: Контроллер, на котором располагается поле поиска
    ///   - searchTerm: Ключевая фраза поиска
    func searchViewController(_ searchViewController: SearchViewController, requestedSearchWith searchTerm: String)
}

final class SearchViewController: ViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var searchContainerView: UIView!
    
    // MARK: - Public properties
    
    weak var favoritesOuterUpdateDelegate: FavoritesOuterUpdateDelegate?
    
    // MARK: - Private properties
    
    private let searchContainerViewController = SearchContainerViewController()
    private weak var searchAppearanceDelegate: AppearanceDelegate?
    private weak var searchDelegate: SearchDelegate?
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        add(childViewController: searchContainerViewController, to: searchContainerView)
        searchTextField.becomeFirstResponder()
        addGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func toggleAppearance(_ sender: UIButton) {
        searchAppearanceDelegate?.viewControllerToggleAppearance(self)
        sender.setImage(sender.image(for: .normal) == #imageLiteral(resourceName: "listAppearance") ? #imageLiteral(resourceName: "gridAppearance") : #imageLiteral(resourceName: "listAppearance"), for: .normal)
    }
    
    // MARK: - Private methods
    
    private func setupDelegates() {
        searchContainerViewController.favoritesOuterUpdateDelegate = favoritesOuterUpdateDelegate
        searchContainerViewController.rootDelegate = rootDelegate
        searchAppearanceDelegate = searchContainerViewController
        searchDelegate = searchContainerViewController
        searchContainerViewController.containerDelegate = self
    }
    
    private func addGestures() {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(closeScreen))
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let text = textField.text,
            !text.isEmpty,
            !text.replacingOccurrences(of: " ", with: "").isEmpty,
            text.rangeOfCharacter(from: CharacterSet(charactersIn: "!№%:;()|/§")) == nil
        else {
            return false
        }
        searchDelegate?.searchViewController(self, requestedSearchWith: text)
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch) -> Bool {
        
        gestureRecognizer.view === touch.view
    }
}

// MARK: - ContainerDelegate

extension SearchViewController: ContainerDelegate {
    
    func containerViewController(
        _ containerViewController: ContainerViewController,
        requestedNavigationAppearanceFor controller: UIViewController) {
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
