//
//  URLDecoderTests.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation
import XCTest
@testable import DeeplinkRouter

final class URLDecoderTests: XCTestCase {

    var decoder: URLDecoderProtocol!
    var jsonDecoder: JSONDecoder!

    override func setUp() {
        super.setUp()
        decoder = URLDecoder()
        jsonDecoder = JSONDecoder()
    }

    func testDecodingValidURL() throws {
        // Given
        let url = URL(string: "myapp://profile?name=John&age=30")!

        // When
        let profile = try decoder.decode(type: MockProfile.self, from: url, decoder: jsonDecoder)

        // Then
        XCTAssertEqual(profile, MockProfile(name: "John", age: 30))
    }

    func testDecodingInvalidURL() throws {
        // Given
        let url = URL(string: "myapp://profile?name=John&age=invalid_age")!

        // Then
        XCTAssertThrowsError(try decoder.decode(type: MockProfile.self, from: url, decoder: jsonDecoder)) { error in
            // Проверка типа ошибки
            XCTAssertTrue(error is DecodingError)

            // Дополнительно можно проверить тип ошибки
            if case DecodingError.dataCorrupted(let context) = error {
                XCTAssertEqual(context.debugDescription, "Invalid data type for age")
            }
        }
    }

    func testDecodingWithMissingParameters() throws {
        // Given
        let url = URL(string: "myapp://profile?name=John&age=0")!

        // When
        let profile = try decoder.decode(type: MockProfile.self, from: url, decoder: jsonDecoder)

        // Then
        XCTAssertEqual(profile, MockProfile(name: "John", age: 0))  // Default value from template
    }
}
