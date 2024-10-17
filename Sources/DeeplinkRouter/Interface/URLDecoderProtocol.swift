//
//  URLDecoderProtocol.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation

/// A protocol for decoding `URLCodable` objects from a URL's query parameters.
public protocol URLDecoderProtocol {

    /// Decodes a `URLCodable` object from the given URL using a provided `JSONDecoder`.
    /// - Parameters:
    ///   - type: The type conforming to `URLCodable` to decode.
    ///   - url: The URL containing the query parameters for decoding.
    ///   - decoder: The `JSONDecoder` used for decoding. Defaults to a new `JSONDecoder` if not provided.
    /// - Returns: A decoded instance of the specified type.
    /// - Throws: An error if decoding fails.
    func decode<T: URLCodable>(
        type: T.Type,
        from url: URL,
        decoder: JSONDecoder
    ) throws -> T
}

public extension URLDecoderProtocol {

    /// Provides a default implementation that uses a `JSONDecoder`.
    func decode<T: URLCodable>(
        type: T.Type,
        from url: URL,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        try self.decode(type: type, from: url, decoder: decoder)
    }
}
