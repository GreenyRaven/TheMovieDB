//
//  PinsView.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 08.05.2021.
//

import UIKit

final class PinsView: UIView, NibLoadable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var firstPin: UIImageView!
    @IBOutlet private var secondPin: UIImageView!
    @IBOutlet private var thirdPin: UIImageView!
    @IBOutlet private var forthPin: UIImageView!
    
    // MARK: - Private methods
    
    private func setPinsRed() {
        firstPin.image = #imageLiteral(resourceName: "smallEllipse")
        secondPin.image = #imageLiteral(resourceName: "smallEllipse")
        thirdPin.image = #imageLiteral(resourceName: "smallEllipse")
        forthPin.image = #imageLiteral(resourceName: "smallEllipse")
    }
    
    private func showPins(active number: Int) {
        setPinsGrey()
        switch number {
        case 4:
            forthPin.image = #imageLiteral(resourceName: "blueEllipse")
            fallthrough
        case 3:
            thirdPin.image = #imageLiteral(resourceName: "blueEllipse")
            fallthrough
        case 2:
            secondPin.image = #imageLiteral(resourceName: "blueEllipse")
            fallthrough
        case 1:
            firstPin.image = #imageLiteral(resourceName: "blueEllipse")
        default:
            return
        }
    }
    
    private func setPinsGrey() {
        firstPin.image = #imageLiteral(resourceName: "darkEllipse")
        secondPin.image = #imageLiteral(resourceName: "darkEllipse")
        thirdPin.image = #imageLiteral(resourceName: "darkEllipse")
        forthPin.image = #imageLiteral(resourceName: "darkEllipse")
    }
}

// MARK: - PincodeInputPanelStateDelegate

extension PinsView: PincodeInputPanelStateDelegate {
    
    func pincodePanel(_ pincodePanel: PincodeInputPanelViewController, currentlyOnPinPartIndex index: Int) {
        showPins(active: index)
    }
    
    func pincodePanelHasShownError(_ pincodePanel: PincodeInputPanelViewController) {
        setPinsRed()
    }
    
    func pincodePanelHasClearedPin(_ pincodePanel: PincodeInputPanelViewController) {
        setPinsGrey()
    }
}
