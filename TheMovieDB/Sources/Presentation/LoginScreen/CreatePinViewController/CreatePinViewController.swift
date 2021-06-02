//
//  CreatePinViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 08.05.2021.
//

import UIKit

final class CreatePinViewController: ViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let fillPincode = "Придумайте пин-код для быстрого входа"
        static let fillAgain = "Повторите ваш пин-код"
        static let pincodeDoesntMatchError = "Пин-коды не совпадают"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var pincodeInputView: UIView!
    
    // MARK: - Private properties
    
    private weak var pincodeDelegate: PincodeDelegate?
    private var persistentStore: PersistentStoreService
    private var repeatedPincode: String?
    
    // MARK: - Initialization
    
    init(
        rootDelegate: PresentationRootDelegate,
        persistentStore: PersistentStoreService = ServiceLayer.shared.persistentStoreService) {
        
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
        
        addPincodeInputPanel()
        pincodeDelegate?.pincodeEnterStarted(self)
    }
    
    // MARK: - Private methods
    
    private func addPincodeInputPanel() {
        let pincodeInputViewController = PincodeInputPanelViewController(pincodeMode: .new, biometricsType: .none)
        add(childViewController: pincodeInputViewController, to: pincodeInputView)
        pincodeInputViewController.pincodeInputDelegate = self
        pincodeDelegate = pincodeInputViewController
    }
}

// MARK: - PincodeInputPanelDelegate

extension CreatePinViewController: PincodeInputPanelDelegate {
    
    func pincodePanelRequestedLogOut(_ pincodePanel: PincodeInputPanelViewController) {
        rootDelegate?.presentationRootController(self, didRequestUpdateFor: .locked)
    }
    
    func pincodePanel(_ pincodePanel: PincodeInputPanelViewController, collectedPin pin: String) {
        guard repeatedPincode != nil else {
            repeatedPincode = pin
            descriptionLabel.text = Constants.fillAgain
            pincodeDelegate?.pincodeEnterStarted(self)
            return
        }
        guard repeatedPincode == pin else {
            pincodeDelegate?.pincode(self, didFinishWithError: Constants.pincodeDoesntMatchError)
            return
        }
        persistentStore.saveValue(pin, of: .pincode)
        rootDelegate?.presentationRootController(self, didRequestUpdateFor: .mainScreen)
    }
}
