//
//  MockNavigator.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//
#if os(iOS)
import XCTest
@testable import DeeplinkRouter

class MockNavigator: NavigatorProtocol {
    var window: UIWindow?
    var topVc: UIViewController?
    var topNavController: UINavigationController?
    var tabbar: UITabBarController?

    private(set) var loadingCalls: [Bool] = []

    func findController<T: UIViewController>(type: T.Type) -> T? {
        return nil
    }

    func setLoading(_ isLoading: Bool) {
        loadingCalls.append(isLoading)
    }
}
#endif
