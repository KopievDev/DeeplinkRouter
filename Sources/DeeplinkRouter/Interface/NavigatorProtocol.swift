//
//  NavigatorProtocol.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

#if os(iOS)
import UIKit

public protocol NavigatorProtocol {
    var window: UIWindow? { get }
    var topVc: UIViewController? { get }
    var topNavController: UINavigationController? { get }
    var tabbar: UITabBarController? { get }

    func findController<T: UIViewController>(type: T.Type) -> T?
    @MainActor
    func setLoading(_ isLoading: Bool)
}
#endif
