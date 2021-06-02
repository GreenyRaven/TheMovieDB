//
//  LoginScreenViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import TheMovieDBAPI
import UIKit

/// Экран авторизации через логин и пароль
final class LoginScreenViewController: ViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let navigationLayoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        static let navigationTitle = "Добро пожаловать!"
        static let errorFillCredentials = "Заполните поля логина и пароля"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var upperTextView: UITextView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    
    private var authService: AuthenticationService
    private let persistentStore: PersistentStoreService
    
    // MARK: - Initialization
    
    init(
        authService: AuthenticationService = ServiceLayer.shared.authService,
        rootDelegate: PresentationRootDelegate,
        persistentStore: PersistentStoreService = ServiceLayer.shared.persistentStoreService) {
        
        self.authService = authService
        self.persistentStore = persistentStore
        super.init(nibName: nil, bundle: nil)
        self.rootDelegate = rootDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addGestureHideKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        errorLabel.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: - IBActions
    
    @IBAction func login(_ sender: UIButton) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            validate(username, password)
        else {
            errorLabel.text = Constants.errorFillCredentials
            return
        }
        signIn(credentials: UserCredentials(username: username, password: password, requestToken: nil))
    }
    
    @IBAction func inputChanged(_ sender: UITextField) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            validate(username, password)
        else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
    
    @IBAction private func setSecureTextEntryModeOnIconTouch(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        setupNavigationBar()
        loginButton.isEnabled = false
        upperTextView.textContainer.lineFragmentPadding = .zero
        setupPasswordField(passwordTextField, normalIcon: #imageLiteral(resourceName: "eyesLocked"), selectedIcon: #imageLiteral(resourceName: "eyes"))
    }
    
    private func setupPasswordField(
        _ textField: UITextField,
        normalIcon normalImage: UIImage,
        selectedIcon selectedImage: UIImage) {
        
        let button = UIButton()
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.addTarget(self, action: #selector(setSecureTextEntryModeOnIconTouch), for: .touchUpInside)
        textField.rightView = button
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        navigationController?.navigationBar.layoutMargins = Constants.navigationLayoutMargins
    }
    
    private func addGestureHideKeyboard() {
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)))
    }
    
    private func signIn(credentials: UserCredentials) {
        setActivityIndicator(animating: true)
        progress = authService.createToken { [weak self] result in
            switch result {
            case .success(let tokenData):
                let userCredentials = UserCredentials(
                    username: credentials.username,
                    password: credentials.password,
                    requestToken: tokenData.requestToken)
                self?.progress = self?.authService.validateToken(for: userCredentials) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.persistentStore.saveValue(userCredentials.username, of: .username)
                        self.progress = self.authService.createNewSession(via: tokenData.requestToken) { result in
                            switch result {
                            case .success(let sessionData):
                                self.persistentStore.saveValue(sessionData.sessionId, of: .sessionID)
                                self.rootDelegate?.presentationRootController(self, didRequestUpdateFor: .mainScreen)
                            case .failure(let error):
                                self.showErrorLabel(for: error)
                            }
                            self.setActivityIndicator(animating: false)
                        }
                    case .failure(let error):
                        self.showErrorLabel(for: error)
                        self.setActivityIndicator(animating: false)
                    }
                }
            case .failure(let error):
                self?.showErrorLabel(for: error)
                self?.setActivityIndicator(animating: false)
            }
        }
    }
    
    private func showErrorLabel(for error: Error) {
        errorLabel.text = error.localizedDescription
    }
    
    private func setActivityIndicator(animating: Bool) {
        animating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        loginButton.setTitle(animating ? "" : "Войти", for: .normal)
    }
    
    private func validate(_ username: String, _ password: String) -> Bool {
        guard
            !username.isEmpty,
            !username.contains(" "),
            !password.isEmpty,
            !password.contains(" ")
        else {
            return false
        }
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginScreenViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.purpure.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.borderBlue.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
            return true
        }
        textField.resignFirstResponder()
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            validate(username, password)
        else {
            errorLabel.text = Constants.errorFillCredentials
            return true
        }
        signIn(credentials: UserCredentials(username: username, password: password, requestToken: nil))
        return true
    }
}
