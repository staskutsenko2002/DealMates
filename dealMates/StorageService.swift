//
//  StorageService.swift
//  dealMates
//
//  Created by Stanislav on 10.06.2023.
//

import Foundation
import KeychainSwift

// MARK: - DefaultsKeys
enum DefaultsKeys: String {

    case firstLaunch
    case firstLaunchLogin
    case firstLaunchFeed
    case firstLaunchCompanyNews
    case firstLaunchAlerts
    case firstLaunchInbox
    case accessToken
    case avatar
    case companyAvatar
    case name
    case role
    case userId
    case hasNewNotifications
    case newestNotificationId
}

// MARK: - StorageType
enum StorageType {
    case userDefaults
    case keychain
}

// MARK: - StorageService
class StorageService {
    typealias Key = DefaultsKeys
    typealias Storage = StorageType

    static private let keychain: KeychainSwift = KeychainSwift()

    static func save<T>(_ value: T, for key: Key, storage: Storage = .userDefaults) {
        switch storage {
        case .userDefaults:
            saveToDefaults(value, for: key)
        case .keychain:
            fatalError("Use func save<T: Codable>() function")
        }
    }

    static func save<T: Codable>(_ value: T, for key: Key, storage: Storage = .userDefaults) {
        switch storage {
        case .userDefaults:
            saveToDefaults(value, for: key)
        case .keychain:
            saveToKeychain(value, for: key)
        }
    }

    static func loadValue<T: Codable>(for key: Key, storage: Storage = .userDefaults) -> T? {
        switch storage {
        case .userDefaults:
            return loadValueFromDefaults(for: key)
        case .keychain:
            return loadValueFromKeychain(for: key)
        }
    }

    static func removeValue(for key: Key, storage: Storage = .userDefaults) {
        switch storage {
        case .userDefaults:
            removeValueFromDefaults(for: key)
        case .keychain:
            removeValueFromKeychain(for: key)
        }
    }

    static func removeAllValue(storage: Storage = .userDefaults) {
        switch storage {
        case .userDefaults:
            removeAllValueFromDefaults()
        case .keychain:
            removeAllValueFromKeychain()
        }
    }

    static private func saveToDefaults<T>(_ value: T, for key: Key) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    static private func saveToKeychain<T: Codable>(_ value: T, for key: Key) {
        do {
            let encodedValue = try value.encodeToData()
            keychain.set(encodedValue, forKey: key.rawValue, withAccess: .accessibleAfterFirstUnlock)
        } catch {
            assertionFailure("Fail to encode value \(value) to json")
        }
    }

    static private func loadValueFromDefaults<T>(for key: Key) -> T? {
        guard let value = UserDefaults.standard.value(forKey: key.rawValue) as? T else {
            return nil
        }

        return value
    }

    static private func saveToDefaults<T: Codable>(_ value: T, for key: Key) {
        do {
            let encodedValue = try value.encodeToData()
            UserDefaults.standard.setValue(encodedValue, forKey: key.rawValue)
        } catch {
            assertionFailure("Fail to encode value \(value) to json")
        }
    }

    static private func loadValueFromDefaults<T: Codable>(for key: Key) -> T? {
        guard let data = UserDefaults.standard.value(forKey: key.rawValue) as? Data else {
            return nil
        }

        do {
            let value = try T.decode(data: data)
            return value
        } catch {
            assertionFailure("Fail to decode value \(String(data: data, encoding: .utf8) ?? "")")
        }

        return nil
    }

    static private func loadValueFromKeychain<T: Codable>(for key: Key) -> T? {
        guard let data = keychain.getData(key.rawValue) else {
            return nil
        }

        do {
            let value = try T.decode(data: data)
            return value
        } catch {
//            assertionFailure("Fail to decode value \(String(data: data, encoding: .utf8) ?? "")")
        }

        return nil
    }

    static private func removeValueFromDefaults(for key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    static private func removeValueFromKeychain(for key: Key) {
        keychain.delete(key.rawValue)
    }

    static private func removeAllValueFromDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }

    static private func removeAllValueFromKeychain() {
        keychain.clear()
    }
}
