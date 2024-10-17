//
//  BaseNavigator.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

#if os(iOS)
import UIKit
import Combine
import SafariServices

/// A class that implements `NavigatorProtocol` to manage navigation and loading states within the app.
public final class BaseNavigator: NavigatorProtocol {

    /// The main application window.
    public var window: UIWindow?

    /// Returns the top-most view controller in the navigation stack.
    public var topVc: UIViewController? {
        topViewController(rootViewController: window?.rootViewController)
    }

    /// Returns the top-most `UINavigationController` in the navigation stack, if available.
    public var topNavController: UINavigationController? {
        topVc as? UINavigationController ?? topVc?.navigationController
    }

    /// Returns the `UITabBarController` if it is the root or top-most controller.
    public var tabbar: UITabBarController? {
        window?.rootViewController as? UITabBarController ?? topVc as? UITabBarController
    }

    /// Finds a specific view controller type in the view controller hierarchy.
    /// - Parameter type: The type of the view controller to find.
    /// - Returns: The found view controller of the specified type, or `nil` if not found.
    public func findController<T: UIViewController>(type: T.Type) -> T? {
        findController(in: window?.rootViewController, ofType: type)
    }

    /// Displays or hides a loading indicator.
    /// - Parameter isLoading: A flag indicating whether to show or hide the loading indicator.
    public func setLoading(_ isLoading: Bool) {
        isLoading ? showLoader() : hideLoader()
    }

    /// Initializes the navigator, optionally with a specific `UIWindow`.
    /// - Parameter window: The window to associate with the navigator. If not provided, it attempts to use the key window.
    public init(window: UIWindow? = nil) {
        if let window = window {
            self.window = window
        } else {
            self.window = UIApplication.shared.windows.first { $0.isKeyWindow }
            bindUIWindow()
        }
    }

    private var subscriptions: Set<AnyCancellable> = []
}

// MARK: - Helpers
private extension BaseNavigator {

    func bindUIWindow() {
        NotificationCenter.default
            .publisher(for: UIWindow.didBecomeKeyNotification)
            .compactMap { $0.object as? UIWindow }
            .sink { [weak self] window in
                print("Window became key: \(window)")
                self?.window = window
            }.store(in: &subscriptions)
    }

    func showLoader() {
        guard let window = window else { return }

        // Проверяем, нет ли уже активного лоадера
        guard window.viewWithTag(69) == nil else { return }

        // Создаем индикатор активности
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .gray
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        loader.tag = 69
        // Добавляем лоадер на окно
        window.addSubview(loader)
        window.bringSubviewToFront(loader)
        // Центрируем лоадер
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: window.centerYAnchor)
        ])
    }

    // Удаление лоадера с окна
    func hideLoader() {
        guard let window = window, let loader = window.viewWithTag(69), loader is UIActivityIndicatorView else {
            return
        }
        loader.removeFromSuperview()
    }

    // Поиск верхнего контроллера
    func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        guard var vc = rootViewController else { return nil }

        // Если это UITabBarController, используем выбранный контроллер
        if let tabBarController = vc as? UITabBarController, let selectedVC = tabBarController.selectedViewController {
            vc = selectedVC
        }

        // Если это UINavigationController, используем верхний контроллер
        if let navController = vc as? UINavigationController, let topVC = navController.topViewController {
            vc = topVC
        }

        // Рекурсивно ищем presentedViewController
        while let presentedVC = vc.presentedViewController {
            if !(presentedVC is SFSafariViewController) && !(presentedVC is UIAlertController) {
                vc = presentedVC
            } else {
                break
            }

            // Если это UINavigationController внутри presentedViewController, проверяем его верхний контроллер
            if let navController = vc as? UINavigationController, let topVC = navController.topViewController {
                vc = topVC
            }
        }

        return vc
    }

    // Поиск контроллера по типу в иерархии
    private func findController<T: UIViewController>(
        in rootViewController: UIViewController?,
        ofType type: T.Type
    ) -> T? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        // Проверяем текущий контроллер
        if let vc = rootViewController as? T {
            return vc
        }

        // Если это UINavigationController, ищем во всём его стеке
        if let nav = rootViewController as? UINavigationController {
            for viewController in nav.viewControllers {
                if let found = findController(in: viewController, ofType: type) {
                    return found
                }
            }
        }

        // Если это UITabBarController, ищем во всех его вкладках
        if let tab = rootViewController as? UITabBarController {
            for viewController in tab.viewControllers ?? [] {
                if let found = findController(in: viewController, ofType: type) {
                    return found
                }
            }
        }

        // Если это UISplitViewController, ищем во всех его child-вьюконтроллерах
        if let split = rootViewController as? UISplitViewController {
            for viewController in split.viewControllers {
                if let found = findController(in: viewController, ofType: type) {
                    return found
                }
            }
        }

        // Проверяем дочерние контроллеры
        for child in rootViewController.children {
            if let found = findController(in: child, ofType: type) {
                return found
            }
        }

        // Проверяем представленный контроллер
        if let presented = rootViewController.presentedViewController {
            return findController(in: presented, ofType: type)
        }

        return nil
    }
}
#endif
