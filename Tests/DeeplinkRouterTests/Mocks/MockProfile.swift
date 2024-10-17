//
//  MockProfile.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//

import XCTest
@testable import DeeplinkRouter

// Моковая структура, реализующая URLCodable
struct MockProfile: URLCodable, Equatable {
    let name: String
    let age: Int

    static var template: MockProfile {
        return MockProfile(name: "", age: 0)
    }
}
