//
//  ViewController+Children.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

extension UIViewController {
    
    // MARK: - Public methods
    
    func add(childViewController: UIViewController, activate constraints: @autoclosure () -> [NSLayoutConstraint]) {
        UIView.transition(
            with: self.view,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil)
        addChild(childViewController)
        view.addSubview(childViewController.view, activate: constraints())
        childViewController.didMove(toParent: self)
    }
    
    func add(childViewController: UIViewController, to container: UIView) {
        UIView.transition(
            with: self.view,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil)
        addChild(childViewController)
        view.addSubview(childViewController.view, with: container)
        childViewController.didMove(toParent: self)
    }
    
    func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}
