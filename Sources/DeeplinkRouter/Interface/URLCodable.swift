//
//  URLCodable.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation

public protocol URLCodable: Codable {
    static var template: Self { get }
}
