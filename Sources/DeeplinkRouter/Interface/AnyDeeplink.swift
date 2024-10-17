//
//  AnyDeeplink.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

#if os(iOS)
import UIKit

/// A protocol that represents a deep link handler in an application.
/// Types conforming to this protocol can identify and handle specific deep links.
public protocol AnyDeeplink {

    /// Determines whether a given URL can be handled by the conforming type.
    /// - Parameter url: The deep link URL to be checked.
    /// - Returns: An optional instance of the conforming type if the URL can be handled, or `nil` if it cannot.
    static func canHandle(deeplink url: URL) -> Self?

    /// Handles the deep link and navigates to the appropriate screen.
    /// - Parameters:
    ///   - deeplink: The URL of the deep link to handle.
    ///   - navigator: An instance of `NavigatorProtocol` used to manage the navigation.
    /// - Note: This function is asynchronous and may involve navigating between screens or handling background tasks.
    func handle(deeplink: URL, navigator: NavigatorProtocol) async
}
#endif
