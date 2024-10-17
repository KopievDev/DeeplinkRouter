//
//  URLCodable.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation

/// A protocol that extends `Codable` and provides a template instance for URL decoding.
/// Conforming types must provide a static `template` value, which serves as a blueprint for decoding URL query parameters.
public protocol URLCodable: Codable {

    /// A template instance used for decoding URL query parameters.
    /// This instance provides the structure and default values for decoding.
    static var template: Self { get }
}
