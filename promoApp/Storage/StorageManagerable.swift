//
//  StorageManagerable.swift
//  promoApp
//
//  Created by Artem Manyshev on 17.08.24.
//

import Foundation

protocol StorageManagerable {
    func value<T>(for key: String) -> T?
    func save<T>(value: T, for key: String)
    func removeValue(for key: String)
}
