// The Swift Programming Language
// https://docs.swift.org/swift-book

#if os(iOS)
import UIKit

/// A class that manages and routes deep links within the application.
public final class DeeplinkRouter {

    /// Indicates whether the router is currently active and capable of handling deep links.
    public var isActive: Bool = false

    /// The navigator responsible for handling view controller transitions.
    public var navigator: NavigatorProtocol

    /// The last unhandled deep link URL, if available.
    public var lastDeeplink: URL?

    /// A list of types conforming to `AnyDeeplink` that the router can handle.
    public var deeplinkTypes: [AnyDeeplink.Type] = []

    /// Initializes a new `DeeplinkRouter` instance.
    /// - Parameters:
    ///   - isActive: A flag indicating if the router is active (defaults to `false`).
    ///   - navigator: The navigator responsible for navigation (defaults to `BaseNavigator`).
    ///   - deeplinkTypes: An array of deeplink types the router can handle (optional).
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
    public func handle(deeplink: URL) async {
        guard isActive else {
            lastDeeplink = deeplink
            return
        }

        for deeplinkType in deeplinkTypes {
            if let handler = deeplinkType.canHandle(deeplink: deeplink) {
                // Если тип может обработать URL, вызываем метод handle
                await handler.handle(deeplink: deeplink, navigator: navigator)
                lastDeeplink = nil
                return
            }
        }
        lastDeeplink = nil
        print("No handler found for deeplink: \(deeplink)")
    }

    public func handleLastDeeplink() async {
        guard let lastDeeplink, isActive else { return }
        await handle(deeplink: lastDeeplink)
    }

    public func register(deeplinks: [any AnyDeeplink.Type]) {
        deeplinkTypes.append(contentsOf: deeplinks)
    }
}
#endif
