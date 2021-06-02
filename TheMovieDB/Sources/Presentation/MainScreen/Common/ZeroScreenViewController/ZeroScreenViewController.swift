//
//  ZeroScreenViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import TheMovieDBAPI
import UIKit

// MARK: - ZeroState

enum ZeroState: String {
    case noneFound = "По вашему запросу ничего не найдено :("
    case emptyCollection = "Вы не добавили ни одного фильма"
    
    var stateImage: UIImage {
        switch self {
        case .emptyCollection:
            return #imageLiteral(resourceName: "emptyCollection")
        case .noneFound:
            return #imageLiteral(resourceName: "noneFound")
        }
    }
    var stateActionTitle: String {
        switch self {
        case .emptyCollection:
            return "Найти любимые фильмы"
        case .noneFound:
            return ""
        }
    }
}

final class ZeroScreenViewController: ContainerViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let errorRetryTitle = "Попробовать снова"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var actionButton: UIButton!
    @IBOutlet private var zeroImageView: UIImageView!
    
    // MARK: - Private properties
    
    private let error: TheMovieDBError?
    private let state: ZeroState
    private let retryAction: (() -> Void)?
    
    // MARK: - Initialization
    
    init(zeroState: ZeroState, error: TheMovieDBError?, retryAction: @escaping () -> Void) {
        self.state = zeroState
        self.retryAction = retryAction
        self.error = error
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ContainerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = error != nil ? error?.description : state.rawValue
        actionButton.setTitle(error != nil ? Constants.errorRetryTitle : state.stateActionTitle, for: .normal)
        zeroImageView.image = state.stateImage
    }
    
    // MARK: - IBActions
    
    @IBAction private func retryPushed() {
        retryAction?()
    }
}
