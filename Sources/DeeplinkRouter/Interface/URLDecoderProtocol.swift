//
//  URLDecoderProtocol.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation

public protocol URLDecoderProtocol {
    func decode<T: URLCodable>(
        type: T.Type,
        from url: URL,
        decoder: JSONDecoder
    ) async throws -> T
}
