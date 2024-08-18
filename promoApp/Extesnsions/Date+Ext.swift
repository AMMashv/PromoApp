//
//  Date+Ext.swift
//  promoApp
//
//  Created by Artem Manyshev on 18.08.24.
//

import Foundation

extension Date {
    func dateByAdding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    
    func numberOfDays(to date: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: self, to: date).day
    }
}
