//
//  URLDecoder.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation

/// A class for universally decoding `Codable` objects from a URL's query parameters.
public final class URLDecoder: URLDecoderProtocol {

    /// Initializes a new instance of `URLDecoder`.
    public init() {}

    /// Decodes a `Codable` object from the given URL's query parameters.
    /// - Parameters:
    ///   - type: The type conforming to `URLCodable` to decode.
    ///   - url: The URL containing the query parameters.
    ///   - decoder: The `JSONDecoder` used for decoding (defaults to `JSONDecoder`).
    /// - Throws: Throws an error if decoding fails.
    /// - Returns: A decoded instance of the specified type.
    public func decode<T: URLCodable>(
        type: T.Type,
        from url: URL,
        decoder: JSONDecoder
    ) throws -> T {
        guard let queryParams = url.queryParameters else {
            print("No query parameters found in URL")
            throw URLError(.unsupportedURL)
        }
        let convertedParams = convertParameters(queryParams, for: type)
        let jsonData = try JSONSerialization.data(withJSONObject: convertedParams, options: [])
        return try decoder.decode(T.self, from: jsonData)
    }

    /// Converts query parameters to match the structure of the `Codable` type.
    /// - Parameters:
    ///   - parameters: A dictionary of query parameters.
    ///   - type: The `URLCodable` type for which the parameters are being converted.
    /// - Returns: A dictionary with converted parameters.
    private func convertParameters<T: URLCodable>(
        _ parameters: [String: String],
        for type: T.Type
    ) -> [String: Any] {
        var convertedParams: [String: Any] = [:]
        let mirror = Mirror(reflecting: type.template)

        for (key, value) in parameters {
            if let child = mirror.children.first(where: { $0.label == key }) {
                if child.value is Int, let intValue = Int(value) {
                    convertedParams[key] = intValue
                } else if child.value is Double, let doubleValue = Double(value) {
                    convertedParams[key] = doubleValue
                } else if child.value is Bool, let boolValue = Bool(value) {
                    convertedParams[key] = boolValue
                } else {
                    convertedParams[key] = value
                }
            }
        }
        return convertedParams
    }
}

/// An extension of `URL` that adds functionality for parsing query parameters.
extension URL {

    /// A computed property that extracts query parameters from a URL.
    /// - Returns: A dictionary of query parameter names and values, or `nil` if no query parameters exist.
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }

        var params: [String: String] = [:]
        for item in queryItems {
            params[item.name] = item.value
        }
        return params
    }
}
