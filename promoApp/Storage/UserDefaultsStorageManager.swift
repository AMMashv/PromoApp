//
//  UserDefaultsStorageManager.swift
//  promoApp
//
//  Created by Artem Manyshev on 17.08.24.
//

import Foundation

protocol UserDefaultsType {
    func double(forKey defaultName: String) -> Double
    func object(forKey defaultName: String) -> Any?
    
    func set(_ value: Double, forKey defaultName: String)
    func setValue(_ value: Any?, forKey key: String)
    
    func removeObject(forKey defaultName: String)
}

final class UserDefaultsStorageManager: StorageManagerable {
    
    private let storage: UserDefaultsType
    
    init(storage: UserDefaultsType = UserDefaults.standard) {
        self.storage = storage
    }
    
    func value<T>(for key: String) -> T? {
        guard T.self == Double.self else {
            return storage.object(forKey: key) as? T
        }
        
        return storage.double(forKey: key) as? T
    }
    
    func save<T>(value: T, for key: String) {
        guard let doubleValue = value as? Double else {
            return storage.setValue(value, forKey: key)
        }
        
        storage.set(doubleValue, forKey: key)
    }
    
    func removeValue(for key: String) {
        storage.removeObject(forKey: key)
    }
}

extension UserDefaults: UserDefaultsType {}
