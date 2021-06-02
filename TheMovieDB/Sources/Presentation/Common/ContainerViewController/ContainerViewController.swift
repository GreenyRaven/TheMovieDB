//
//  ContainerViewController.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

/// Позволяет обрабатывать частные случаи показа контента контроллера-контейнера
protocol ContainerDelegate: AnyObject {
    
    /// Обработка запроса на показ контроллера на весь экран с управлением через `navigationBar`
    /// - Parameters:
    ///   - containerViewController: Контейнер, создавший запрос
    ///   - controller: Контроллер для отображения
    func containerViewController(
        _ containerViewController: ContainerViewController,
        requestedNavigationAppearanceFor controller: UIViewController)
}

/// `UIViewController` с возможностью отображения других `UIViewController`во `view`
class ContainerViewController: ViewController {
    
    // MARK: - Public properties
    
    /// `UIView` в который будет встроен `contentViewController`
    var containerView: UIView { view }
    weak var containerDelegate: ContainerDelegate?
    
    // MARK: - Private properties
    
    /// Отображаемый `UIVewController`
    private(set) var contentViewController: UIViewController?
    
    // MARK: - Public methods
    
    /// Отображение заданного контроллера
    /// - Parameter content: Контроллер для отображения
    func setContent(_ content: UIViewController?) {
        guard
            let content = content,
            content != contentViewController
        else {
            return
        }
        if let contentViewController = contentViewController {
            remove(childViewController: contentViewController)
        }
        add(childViewController: content, to: containerView)
        contentViewController = content
    }
}
