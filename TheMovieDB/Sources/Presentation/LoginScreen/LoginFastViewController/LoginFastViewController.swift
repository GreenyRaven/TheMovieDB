//
//  LoginFastViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 08.05.2021.
//

import LocalAuthentication
import TheMovieDBAPI
import UIKit

final class LoginFastViewController: ViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let wrongPincodeError = "Неверный пин-код"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var userIconImageView: UIImageView!
    @IBOutlet private var pincodeView: UIView!
    
    // MARK: - Private properties
    
    private weak var pincodeDelegate: PincodeDelegate?
    private let persistentStore: PersistentStoreService
    private let biometricAuthService: BiometricAuthService
    private let profileData: UserProfileDetails
    private let iconLoaderService: ImagesLoaderService
    
    // MARK: - Initialization
    
    init(
        rootDelegate: PresentationRootDelegate,
        persistentStore: PersistentStoreService = ServiceLayer.shared.persistentStoreService,
        biometricAuthService: BiometricAuthService = ServiceLayer.shared.biometricAuthService,
        profileData: UserProfileDetails,
        iconLoaderService: ImagesLoaderService = ServiceLayer.shared.imagesLoaderService) {
        
        self.persistentStore = persistentStore
        self.biometricAuthService = biometricAuthService
        self.profileData = profileData
        self.iconLoaderService = iconLoaderService
        super.init(nibName: nil, bundle: nil)
        self.rootDelegate = rootDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPincodeInputPanel()
        fillUserData()
        pincodeDelegate?.pincodeEnterStarted(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if biometricAuthService.biometricType() != .none {
            authenticateViaBiometrics()
        }
    }
    
    // MARK: - Private methods
    
    private func addPincodeInputPanel() {
        let pincodeInputViewController = PincodeInputPanelViewController(
            pincodeMode: .existing,
            biometricsType: biometricAuthService.biometricType())
        add(childViewController: pincodeInputViewController, to: pincodeView)
        pincodeInputViewController.pincodeInputDelegate = self
        pincodeDelegate = pincodeInputViewController
    }
    
    private func fillUserData() {
        userIconImageView.layer.cornerRadius = userIconImageView.bounds.width / 2
        userNameLabel.text = profileData.name != nil && profileData.name != "" ? profileData.name : profileData.username
        progress = iconLoaderService.fetchUserIcon(iconHash: profileData.avatar.gravatar.hash) { [weak self] result in
            switch result {
            case .success(let userIcon):
                guard let image = UIImage(data: userIcon.data) else { return }
                self?.userIconImageView.image = image
            case .failure:
                return
            }
        }
    }
    
    private func authenticateViaBiometrics() {
        biometricAuthService.authenticate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.pincodeDelegate?.pincodeBiometricsSucceeded(self)
                self.rootDelegate?.presentationRootController(self, didRequestUpdateFor: .mainScreen)
            case .failure(let error) where (error as? LAError)?.code != .userCancel:
                self.pincodeDelegate?.pincode(self, didFinishWithError: Constants.wrongPincodeError)
                self.showAlert(with: error.localizedDescription)
            default:
                return
            }
        }
    }
}

// MARK: - PincodeInputPanelDelegate

extension LoginFastViewController: PincodeInputPanelDelegate {
    
    func pincodePanel(_ pincodePanel: PincodeInputPanelViewController, collectedPin pincode: String) {
        guard
            let storedPincode = persistentStore.value(for: .pincode),
            storedPincode == pincode
        else {
            pincodeDelegate?.pincode(self, didFinishWithError: Constants.wrongPincodeError)
            return
        }
        rootDelegate?.presentationRootController(self, didRequestUpdateFor: .mainScreen)
    }
    
    func pincodePanelRequestedLogOut(_ pincodePanel: PincodeInputPanelViewController) {
        rootDelegate?.presentationRootController(self, didRequestUpdateFor: .locked)
    }
    
    func pincodePanelRequestedBiometrics(_ pincodePanel: PincodeInputPanelViewController) {
        authenticateViaBiometrics()
    }
}
