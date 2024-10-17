//
//  DeeplinkRouterProtocol.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//

#if os(iOS)
import Foundation

/// A protocol for managing and routing deep links within an application.
public protocol DeeplinkRouterProtocol {

    /// Indicates whether the deep link router is currently active.
    var isActive: Bool { get set }

    /// A navigator responsible for managing navigation between view controllers.
    var navigator: NavigatorProtocol { get set }

    /// Handles the specified deep link asynchronously.
    /// - Parameter deeplink: The URL to be handled.
    func handle(deeplink: URL) async

    /// Handles the last unprocessed deep link, if available, asynchronously.
    func handleLastDeeplink() async

    /// Registers a list of deep link types to be handled by the router.
    /// - Parameter deeplinks: An array of `AnyDeeplink.Type` conforming types.
    func register(deeplinks: [AnyDeeplink.Type])
}
#endif
