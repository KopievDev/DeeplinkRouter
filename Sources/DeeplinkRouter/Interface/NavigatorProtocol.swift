//
//  NavigatorProtocol.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

#if os(iOS)
import UIKit

/// A protocol for managing and navigating through the application's view controller hierarchy.
public protocol NavigatorProtocol {

    /// The main application window.
    var window: UIWindow? { get }

    /// The top-most view controller in the current view hierarchy.
    var topVc: UIViewController? { get }

    /// The top-most `UINavigationController` in the current view hierarchy.
    var topNavController: UINavigationController? { get }

    /// The current `UITabBarController`, if present.
    var tabbar: UITabBarController? { get }

    /// Finds a specific view controller type in the view controller hierarchy.
    /// - Parameter type: The type of the view controller to find.
    /// - Returns: An instance of the specified view controller type if found.
    func findController<T: UIViewController>(type: T.Type) -> T?

    /// Displays or hides a loading indicator.
    /// - Parameter isLoading: A boolean indicating whether to show or hide the loading indicator.
    @MainActor
    func setLoading(_ isLoading: Bool)
}
#endif
