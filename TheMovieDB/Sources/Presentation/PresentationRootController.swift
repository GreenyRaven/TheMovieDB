//
//  PresentationRootController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import TheMovieDBAPI
import UIKit

/// Предоставляет возможность деавторизации в любой части приложения
protocol PresentationRootDelegate: AnyObject {
    
    func presentationRootController(_ viewController: UIViewController, didRequestUpdateFor state: RootContainerState)
}

// MARK: - Root Container State

enum RootContainerState {
    case locked
    case mainScreen
}

final class PresentationRootController: ContainerViewController {
    
    // MARK: - Private properties
    
    private let authService: AuthenticationService
    private let userProfileService: UserProfileService
    private lazy var mainScreenController = MainTabBarRootController(rootDelegate: self)
    private lazy var loginScreenController = NavigationController(
        rootViewController: LoginScreenViewController(rootDelegate: self))
    private let persistentStore: PersistentStoreService
    private let configurationService: ConfigurationLoaderService
    
    // MARK: - Initialization
    
    init(
        authService: AuthenticationService = ServiceLayer.shared.authService,
        userProfileService: UserProfileService = ServiceLayer.shared.userProfileService,
        persistentStore: PersistentStoreService = ServiceLayer.shared.persistentStoreService,
        configurationService: ConfigurationLoaderService = ServiceLayer.shared.configurationLoaderService) {
        
        self.authService = authService
        self.userProfileService = userProfileService
        self.persistentStore = persistentStore
        self.configurationService = configurationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bgBlack
        NavigationController.setupAppearance()
        automaticSignIn()
    }
    
    // MARK: - Private methods
    
    private func automaticSignIn() {
        guard authService.isAuthorized else {
            setContent(loginScreenController)
            return
        }
        signIn(isManual: false)
    }
    
    private func signOut() {
        authService.signOut()
        persistentStore.removeValue(of: .pincode)
        mainScreenController = MainTabBarRootController(rootDelegate: self)
        loginScreenController = NavigationController(
            rootViewController: LoginScreenViewController(rootDelegate: self))
        setContent(loginScreenController)
    }
    
    private func signIn(isManual: Bool) {
        progress = userProfileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userDetails):
                self.persistentStore.saveValue("\(userDetails.id)", of: .accountID)
                self.progress = self.configurationService.fetchConfiguration { _ in
                    self.progress = self.configurationService.fetchGenres { _ in }
                }
                guard self.persistentStore.value(for: .pincode) != nil else {
                    self.setContent(CreatePinViewController(rootDelegate: self))
                    return
                }
                isManual ?
                    self.setContent(self.mainScreenController) :
                    self.setContent(LoginFastViewController(rootDelegate: self, profileData: userDetails))
            case .failure(let error):
                guard let error = error as? TheMovieDBError else { return }
                switch error {
                case .apiError(let apiError) where apiError.isReasonToSighOut:
                    self.signOut()
                default:
                    self.setContent(self.loginScreenController)
                    self.showAlert(with: error.description)
                }
            }
        }
    }
}

// MARK: - PresentationRootDelegate

extension PresentationRootController: PresentationRootDelegate {
    
    func presentationRootController(_ viewController: UIViewController, didRequestUpdateFor state: RootContainerState) {
        switch state {
        case .locked:
            signOut()
        case .mainScreen:
            signIn(isManual: true)
        }
    }
}
