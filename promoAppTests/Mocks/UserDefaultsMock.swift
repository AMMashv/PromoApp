//
//  UserDefaultsMock.swift
//  promoAppTests
//
//  Created by Artem Manyshev on 17.08.24.
//

@testable import promoApp

final class UserDefaultsMock: UserDefaultsType {
    
    var doubleValues: [String: Double] = [:]
    var objectValues: [String: Any] = [:]
    
    func double(forKey defaultName: String) -> Double {
        return doubleValues[defaultName] ?? 0.0
    }
    
    func object(forKey defaultName: String) -> Any? {
        return objectValues[defaultName]
    }
    
    func set(_ value: Double, forKey defaultName: String) {
        removeObject(forKey: defaultName)
        doubleValues[defaultName] = value
    }
    
    func setValue(_ value: Any?, forKey key: String) {
        removeObject(forKey: key)
        objectValues[key] = value
    }
    
    func removeObject(forKey defaultName: String) {
        doubleValues.removeValue(forKey: defaultName)
        objectValues.removeValue(forKey: defaultName)
    }
}
