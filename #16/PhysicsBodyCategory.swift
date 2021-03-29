//
//  PhysicsBodyCategory.swift
//  #16
//
//  Created by Egor Malyshev on 29.03.2021.
//

import Foundation

struct PhysicsBodyCategory {
    static let none   : UInt32 = 0
    static let all    : UInt32 = UInt32.max
    static let player : UInt32 = 0b1
    static let enemy  : UInt32 = 0b10
    static let ground : UInt32 = 0b100
}
