//
//  BiometricAuthService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 09.05.2021.
//

import LocalAuthentication
import UIKit

/// Предоставляет инструменты для биометрической авторизации
protocol BiometricAuthService: AnyObject {
    
    /// Возвращает тип биометрии, поддерживаемый устройством
    func biometricType() -> BiometricType
    
    /// Авторизация с использованием поддерживаемого биометрического датчика
    /// - Parameter completion: Отчет об успехе, или описание возникшей ошибки `LAError`
    func authenticate(completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - BiometricType

enum BiometricType: Equatable {
    case none
    case touchID(_ icon: UIImage)
    case faceID(_ icon: UIImage)
}

final class BiometricAuthServiceImpl: BiometricAuthService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let faceIDReason = "Авторизация через FaceID"
        static let touchIDReason = "Авторизация через TouchID"
    }
    
    // MARK: - Private properties
    
    private let authContext = LAContext()
    
    // MARK: - Public methods
    
    func biometricType() -> BiometricType {
        guard hasBiometrics() == nil else { return .none }
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID(#imageLiteral(resourceName: "touchID"))
        case .faceID:
            return .faceID(#imageLiteral(resourceName: "icon_face id_32"))
        @unknown default:
            return .none
        }
    }
    
    func authenticate(completion: @escaping (Result<Void, Error>) -> Void) {
        if let error = hasBiometrics() {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        var loginReason: String
        switch biometricType() {
        case .faceID:
            loginReason = Constants.faceIDReason
        case .touchID:
            loginReason = Constants.touchIDReason
        case .none:
            return
        }
        authContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: loginReason) { success, error in
            DispatchQueue.main.async {
                guard
                    !success,
                    let error = error
                else {
                    completion(.success(()))
                    return
                }
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func hasBiometrics() -> LAError? {
        var error: NSError?
        authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return error as? LAError
    }
}
