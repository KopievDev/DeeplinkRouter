//
//  MockDeeplink.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//
#if os(iOS)
import Foundation
@testable import DeeplinkRouter

struct MockDeeplink: AnyDeeplink {
    static var handled = false

    static func canHandle(deeplink: URL) -> MockDeeplink? {
        guard deeplink.host == "mock" else { return nil }

        return MockDeeplink()
    }

    func handle(deeplink: URL, navigator: NavigatorProtocol) async {
        await navigator.setLoading(true)
        MockDeeplink.handled = true
        await navigator.setLoading(false)
    }
}

final class AnotherMockDeeplink: AnyDeeplink {
    static func canHandle(deeplink: URL) -> AnotherMockDeeplink? { return nil }
    func handle(deeplink: URL, navigator: NavigatorProtocol) {}
}
#endif
