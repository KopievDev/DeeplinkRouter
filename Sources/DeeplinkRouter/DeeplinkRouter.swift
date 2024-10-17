// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public final class DeeplinkRouter {
    public var isActive: Bool = false
    public var navigator: NavigatorProtocol
    public var lastDeeplink: URL?
    public var deeplinkTypes: [AnyDeeplink.Type] = []

    public init(
        isActive: Bool = false,
        navigator: NavigatorProtocol = BaseNavigator(),
        deeplinkTypes: [AnyDeeplink.Type] = []
    ) {
        self.isActive = isActive
        self.navigator = navigator
        self.deeplinkTypes = deeplinkTypes
    }
}

extension DeeplinkRouter: DeeplinkRouterProtocol {
    public func handle(deeplink: URL) {
        guard isActive, UIApplication.shared.applicationState == .active else {
            lastDeeplink = deeplink
            return
        }

        for deeplinkType in deeplinkTypes {
            if let handler = deeplinkType.canHandle(deeplink: deeplink) {
                // Если тип может обработать URL, вызываем метод handle
                Task {
                    await handler.handle(deeplink: deeplink, navigator: navigator)
                }
                return
            }
        }
        print("No handler found for deeplink: \(deeplink)")
    }

    public func handleLastDeeplink() {
        guard let lastDeeplink, isActive, UIApplication.shared.applicationState == .active else { return }
        handle(deeplink: lastDeeplink)
    }

    public func register(deeplinks: [any AnyDeeplink.Type]) {
        deeplinkTypes.append(contentsOf: deeplinks)
    }
}
