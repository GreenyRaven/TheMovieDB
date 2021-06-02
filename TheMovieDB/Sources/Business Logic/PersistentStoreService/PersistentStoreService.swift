//
//  PersistentStoreService.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 16.05.2021.
//

import KeychainAccess

/// Хранение данных в физических хранилищах (`UserDefaults`, `Keychain` etc)
protocol PersistentStoreService {
    
    /// Сохранить данные
    /// - Parameters:
    ///   - value: Данные
    ///   - type: Идентификатор ячейки хранения данных
    func saveValue(_ value: String, of type: ValueType)
    
    /// Удалить данные
    /// - Parameter type: Идентификатор ячейки хранения данных
    func removeValue(of type: ValueType)
    
    /// Получить данные
    /// - Parameter type: Идентификатор ячейки хранения данных
    func value(for type: ValueType) -> String?
}

// MARK: - ValueType

/// Идентификатор-обертка для сохранения данных в заданную `rawValue` ячейку `UserDefaults` или `Keychain`
enum ValueType: String {
    case sessionID = "session_id"
    case username = "user_nickname"
    case pincode = "pincode"
    case accountID = "account_id"
}

final class PersistentStoreServiceImpl: PersistentStoreService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let serviceName = "com.redmadrobot.TheMovieDB"
    }
    
    // MARK: - Private properties
    
    private let keychain = Keychain(service: Constants.serviceName)
    private let userDefaults = UserDefaults()
    
    // MARK: - Public methods
    
    func saveValue(_ value: String, of type: ValueType) {
        do {
            switch type {
            case .sessionID:
                try keychain.set(value, key: type.rawValue)
            case .username:
                userDefaults.setValue(value, forKey: type.rawValue)
            case .pincode:
                try keychain.set(value, key: type.rawValue)
            case .accountID:
                userDefaults.setValue(value, forKey: type.rawValue)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func removeValue(of type: ValueType) {
        do {
            switch type {
            case .sessionID:
                try keychain.remove(type.rawValue)
            case .username:
                userDefaults.removeObject(forKey: type.rawValue)
            case .pincode:
                try keychain.remove(type.rawValue)
            case .accountID:
                userDefaults.removeObject(forKey: type.rawValue)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func value(for type: ValueType) -> String? {
        do {
            switch type {
            case .sessionID:
                return try keychain.get(type.rawValue)
            case .username:
                return userDefaults.string(forKey: type.rawValue)
            case .pincode:
                return try keychain.get(type.rawValue)
            case .accountID:
                return userDefaults.string(forKey: type.rawValue)
            }
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
