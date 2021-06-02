//
//  ProfileViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import TheMovieDBAPI
import UIKit

final class ProfileViewController: ViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var profileiconImageView: UIImageView!
    @IBOutlet private var personUsernameLabel: UILabel!
    @IBOutlet private var personNameLabel: UILabel!
    
    // MARK: - Private properties
    
    private let userProfileService: UserProfileService
    private let imagesLoaderService: ImagesLoaderService
    
    // MARK: - Initialization
    
    init(
        userProfileService: UserProfileService = ServiceLayer.shared.userProfileService,
        imagesLoaderService: ImagesLoaderService = ServiceLayer.shared.imagesLoaderService) {
        
        self.userProfileService = userProfileService
        self.imagesLoaderService = imagesLoaderService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserData()
    }
    
    // MARK: - IBActions
    
    @IBAction func logOut(_ sender: UIButton) {
        rootDelegate?.presentationRootController(self, didRequestUpdateFor: .locked)
    }
    
    // MARK: - Private methods
    
    private func fetchUserData() {
        progress = userProfileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                self.loadUserIcon(iconHash: userData.avatar.gravatar.hash)
                guard
                    let name = userData.name,
                    !name.isEmpty
                else {
                    self.personNameLabel.text = userData.username
                    return
                }
                self.personNameLabel.text = name
                self.personUsernameLabel.text = userData.username
            case .failure(let error):
                guard let error = error as? TheMovieDBError else { return }
                switch error {
                case .apiError(let apiError) where apiError.isReasonToSighOut:
                    self.rootDelegate?.presentationRootController(self, didRequestUpdateFor: .locked)
                    fallthrough
                default:
                    self.showAlert(with: error.description)
                }
            }
        }
    }
    
    private func loadUserIcon(iconHash: String) {
        progress = imagesLoaderService.fetchUserIcon(iconHash: iconHash) { [weak self] result in
            switch result {
            case .success(let userIcon):
                self?.profileiconImageView.image = UIImage(data: userIcon.data) ?? #imageLiteral(resourceName: "user")
            case .failure:
                return
            }
        }
    }
}
