//
//  UserDefaultsRecordKeys.swift
//  #16
//
//  Created by Egor Malyshev on 29.03.2021.
//

import Foundation

enum UserDefaultsRecordKeys: String {
    case circle = "circleGameRecord"
    case square = "squareGameRecord"
}

enum SceneType {
    case circle
    case square
    case gameOver
}
