//
//  PincodePanelView.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 08.05.2021.
//

import UIKit

// MARK: - PincodeInputPanelDelegate

/// Содержит набор методов, позволяющих реагировать на ввод пользователя на панели ввода пин-кода
protocol PincodeInputPanelDelegate: AnyObject {
    
    /// Оповещает о завершении набора пин-кода
    /// - Parameters:
    ///   - pincodePanel: Панель, на которой был набран пин-код
    ///   - pin: Набранный пин-код
    func pincodePanel(_ pincodePanel: PincodeInputPanelViewController, collectedPin pincode: String)
    
    /// Оповещает о нажатии кнопки "Выйти"
    /// - Parameter pincodePanel: Панель, на которой была нажата кнопка
    func pincodePanelRequestedLogOut(_ pincodePanel: PincodeInputPanelViewController)
    
    /// Оповещает о нажатии кнопки входа по биометрии
    /// - Parameter pincodePanel: Панель, на которой была нажата кнопка
    func pincodePanelRequestedBiometrics(_ pincodePanel: PincodeInputPanelViewController)
}

extension PincodeInputPanelDelegate {
    
    func pincodePanelRequestedLogOut(_ pincodePanel: PincodeInputPanelViewController) {
        return
    }
    
    func pincodePanelRequestedBiometrics(_ pincodePanel: PincodeInputPanelViewController) {
        return
    }
}

// MARK: - PincodeInputPanelStateDelegate

/// Позволяет обновлять UI на основе текущей стадии набора пин-кода
protocol PincodeInputPanelStateDelegate: AnyObject {
    
    /// Оповещает о вводе пользователем очередной цифры пин-кода
    /// - Parameters:
    ///   - pincodePanel: Панель, на которой набирается пин-код
    ///   - index: Порядковый номер очередной цифры пин-кода
    func pincodePanel(_ pincodePanel: PincodeInputPanelViewController, currentlyOnPinPartIndex index: Int)
    
    /// Оповещает о выводе ошибки ввода пин-кода
    /// - Parameter pincodePanel: Панель, на которой набирается пин-код
    func pincodePanelHasShownError(_ pincodePanel: PincodeInputPanelViewController)
    
    /// Оповещает о начале процесса ввода пин-кода
    /// - Parameter pincodePanel: Панель, на которой набирается пин-код
    func pincodePanelHasClearedPin(_ pincodePanel: PincodeInputPanelViewController)
}

final class PincodeInputPanelViewController: UIViewController {
    
    // MARK: - Types
    
    /// Режим отображения панели ввода: для new скрыта кнопка "Выйти" и возможность входа по биометрии
    public enum PincodeMode {
        case new
        case existing
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let pincodeLength = 4
        static let errorPlaceholder = " "
    }
    
    // MARK: - Public properties
    
    weak var pincodeInputDelegate: PincodeInputPanelDelegate?
    private weak var pincodeStateDelegate: PincodeInputPanelStateDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet private var undoOrBiometricsButton: UIButton!
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var pinsView: UIView!
    
    // MARK: - Private properties
    
    private var pincode = "" {
        didSet {
            let icon: UIImage = (pincode.isEmpty) && (mode == .existing) ? biometricIcon : #imageLiteral(resourceName: "backspace")
            undoOrBiometricsButton.setImage(icon, for: .normal)
        }
    }
    private var biometricIcon: UIImage {
        switch biometricsType {
        case .touchID(let icon):
            return icon
        case .faceID(let icon):
            return icon
        case .none:
            return #imageLiteral(resourceName: "backspace")
        }
    }
    private var mode: PincodeMode = .new
    private var biometricsType: BiometricType = .none
    
    // MARK: - Initialization
    
    init(pincodeMode: PincodeMode, biometricsType: BiometricType) {
        self.mode = pincodeMode
        self.biometricsType = biometricsType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPinsView()
    }
    
    // MARK: - IBActions
    
    @IBAction private func tapOnNumber(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        pincode.append(text)
        errorLabel.text = Constants.errorPlaceholder
        pincodeStateDelegate?.pincodePanel(self, currentlyOnPinPartIndex: pincode.count)
        if pincode.count == Constants.pincodeLength {
            pincodeInputDelegate?.pincodePanel(self, collectedPin: pincode)
        }
    }
    
    @IBAction private func requestLogOut(_ sender: UIButton) {
        pincodeInputDelegate?.pincodePanelRequestedLogOut(self)
    }
    
    @IBAction private func undoOrRequestBiometrics(_ sender: UIButton) {
        if pincode.isEmpty && mode == .existing && biometricsType != .none {
            pincodeInputDelegate?.pincodePanelRequestedBiometrics(self)
        } else {
            if pincode.count != 0 {
                pincode.removeLast()
            }
            pincodeStateDelegate?.pincodePanel(self, currentlyOnPinPartIndex: pincode.count)
        }
    }
    
    // MARK: - Private methods
    
    private func addPinsView() {
        let pinsView = PinsView.loadFromNib()
        self.pinsView.addSubview(pinsView, with: self.pinsView)
        pincodeStateDelegate = pinsView
    }
    
    private func cleanUpForInput() {
        pincode.removeAll()
        errorLabel.text = Constants.errorPlaceholder
        logOutButton.alpha = mode == .existing ? 1 : 0
        logOutButton.isEnabled = mode == .existing ? true : false
        pincodeStateDelegate?.pincodePanelHasClearedPin(self)
    }
}

// MARK: - PincodeDelegate

extension PincodeInputPanelViewController: PincodeDelegate {
    
    func pincode(_ viewController: ViewController, didFinishWithError message: String) {
        pincode.removeAll()
        errorLabel.text = message
        pincodeStateDelegate?.pincodePanelHasShownError(self)
    }
    
    func pincodeEnterStarted(_ viewController: ViewController) {
        cleanUpForInput()
    }
    
    func pincodeBiometricsSucceeded(_ viewController: ViewController) {
        errorLabel.text = Constants.errorPlaceholder
        pincodeStateDelegate?.pincodePanelHasClearedPin(self)
    }
}
