//
//  Coordinator.swift
//  promoApp
//
//  Created by Artem Manyshev on 16.08.24.
//

import Foundation

protocol Transitionable: Identifiable {}

protocol Coordinator: AnyObject {
    func perform(transition: any Transitionable)
    func dismiss()
}
