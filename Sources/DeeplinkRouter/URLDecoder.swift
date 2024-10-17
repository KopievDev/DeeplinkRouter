//
//  URLDecoder.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation

// Класс для универсального парсинга URL в Codable объект
final class URLDecoder: URLDecoderProtocol {

    public init() {}

    // Универсальный метод для парсинга объекта Codable из URL query-параметров
    func decode<T: URLCodable>(type: T.Type, from url: URL, decoder: JSONDecoder) throws -> T {
        guard let queryParams = url.queryParameters else {
            print("No query parameters found in URL")
            throw URLError(.unsupportedURL)
        }
        // Преобразуем параметры в соответствующие типы на основе структуры Codable
        let convertedParams = convertParameters(queryParams, for: type)
        // Превращаем query-параметры в Data, подходящие для JSONDecoder
        let jsonData = try JSONSerialization.data(withJSONObject: convertedParams, options: [])
        let object = try decoder.decode(T.self, from: jsonData)
        return object
    }

    // Преобразование query-параметров в соответствующие типы на основе структуры
    private func convertParameters<T: URLCodable>(
        _ parameters: [String: String],
        for type: T.Type
    ) -> [String: Any] {
        var convertedParams: [String: Any] = [:]

        // Используем Mirror для рефлексии структуры
        let mirror = Mirror(reflecting: type.template)

        for (key, value) in parameters {
            if let child = mirror.children.first(where: { $0.label == key }) {
                // Преобразуем строку в нужный тип на основе метаданных
                if child.value is Int, let intValue = Int(value) {
                    convertedParams[key] = intValue
                } else if child.value is Double, let doubleValue = Double(value) {
                    convertedParams[key] = doubleValue
                } else if child.value is Bool, let boolValue = Bool(value) {
                    convertedParams[key] = boolValue
                } else {
                    // Если это строка или неизвестный тип, оставляем как строку
                    convertedParams[key] = value
                }
            }
        }
        return convertedParams
    }
}

// Расширение URL для парсинга query-параметров
extension URL {
    // Извлекаем словарь query-параметров
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
