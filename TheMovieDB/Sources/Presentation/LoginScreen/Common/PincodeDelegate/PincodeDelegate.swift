//
//  PincodeDelegate.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 09.05.2021.
//

/// Оповещает о видимых для пользователя событиях на экране авторизации через пин-код
protocol PincodeDelegate: AnyObject {
    
    /// Оповещает о неправильном вводе пин-кода
    /// - Parameters:
    ///   - viewController: Контроллер, где вводится пин-код
    ///   - message: Описание ошибки
    func pincode(_ viewController: ViewController, didFinishWithError message: String)
    
    /// Оповещает о начале процесса ввода пин-кода, впервые или повторно
    /// - Parameter viewController: Контроллер, где вводится пин-код
    func pincodeEnterStarted(_ viewController: ViewController)
    
    /// Оповещает об успешной авторизации через биометрию
    /// - Parameter viewController: Контроллер, где вводится пин-код
    func pincodeBiometricsSucceeded(_ viewController: ViewController)
}
