//
//  InstallationDaysManager.swift
//  promoApp
//
//  Created by Artem Manyshev on 17.08.24.
//

import Foundation
import Combine

protocol InstallationDaysProviderable {
    var value: AnyPublisher<Int, Error> { get }
    var isLastDayWarning: AnyPublisher<Bool, Error> { get }
}

protocol InstallationDaysManagerable: InstallationDaysProviderable {
    func increaseValue() throws
    func clearValue()
}

final class InstallationDaysManager: InstallationDaysManagerable {
    private enum Constants {
        static let daysStorageKey = "installation_days"
        static let maxInstallationDays = 3
    }
    
    enum InstallationDaysError: Error {
        case storedDateNotFound
        case unexpectedStoredDate(Date)
    }
    
    private let storage: StorageManagerable
    
    private let valueInternal = CurrentValueSubject<Int, Error>(0)
    
    var value: AnyPublisher<Int, Error> {
        return valueInternal
            .eraseToAnyPublisher()
    }
    
    var isLastDayWarning: AnyPublisher<Bool, Error> {
        valueInternal
            .map { $0 >= Constants.maxInstallationDays }
            .eraseToAnyPublisher()
    }
    
    init(with storage: StorageManagerable) {
        self.storage = storage
        configure()
    }
    
    func increaseValue() throws {
        guard let storedDate else {
            throw InstallationDaysError.storedDateNotFound
        }
        
        guard let newDate = storedDate.dateByAdding(days: -1) else {
            throw InstallationDaysError.unexpectedStoredDate(storedDate)
        }
        
        valueInternal.send(valueInternal.value + 1)
        storage.save(value: newDate.timeIntervalSince1970, for: Constants.daysStorageKey)
    }
    
    func clearValue() {
        valueInternal.send(0)
        saveCurrentDate()
    }
}

private extension InstallationDaysManager {
    var storedDate: Date? {
        guard let value: Double = storage.value(for: Constants.daysStorageKey), value > 0.0 else {
            return nil
        }
        
        return .init(timeIntervalSince1970: value)
    }
    
    func configure() {
        guard let storedDate else {
            return saveCurrentDate()
        }
        
        let numberOfDays = storedDate.numberOfDays(to: Date()) ?? 0
        valueInternal.send(numberOfDays)
    }
    
    func saveCurrentDate() {
        storage.save(value: Date().timeIntervalSince1970, for: Constants.daysStorageKey)
    }
}
