//
//  BaseNavigatorTests.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

import XCTest
@testable import DeeplinkRouter

final class BaseNavigatorTests: XCTestCase {

    var navigator: BaseNavigator!
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        navigator = BaseNavigator(window: window)
    }

    func testWindowReturnsKeyWindow() {
        // Given
        window.makeKeyAndVisible()

        // When
        let returnedWindow = navigator.window

        // Then
        XCTAssertEqual(returnedWindow, window)
    }

    func testTopVcReturnsCorrectViewController() {
        // Given
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        // When
        let topVc = navigator.topVc

        // Then
        XCTAssertEqual(topVc, rootViewController)
    }

    func testTopNavControllerReturnsCorrectNavigationController() {
        // Given
        let window = UIWindow()
        navigator = BaseNavigator(window: window)
        let navController = UINavigationController()
        window.rootViewController = navController
        window.makeKeyAndVisible()

        // When
        let topNavController = navigator.topNavController

        // Then
        XCTAssertEqual(topNavController, navController)
    }

    func testTabbarReturnsCorrectTabBarController() {
        // Given
        let tabBarController = UITabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        // When
        let tabbar = navigator.tabbar

        // Then
        XCTAssertEqual(tabbar, tabBarController)
    }

    @MainActor 
    func testSetLoadingShowsAndHidesLoader() {
        // Given
        window.makeKeyAndVisible()

        // When
        navigator.setLoading(true)

        // Then
        XCTAssertNotNil(window.viewWithTag(69))

        // When
        navigator.setLoading(false)

        // Then
        XCTAssertNil(window.viewWithTag(69))
    }
}
