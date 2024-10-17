#if os(iOS)
import XCTest
@testable import DeeplinkRouter

class DeeplinkRouterTests: XCTestCase {

    var router: DeeplinkRouter!
    var mockNavigator: MockNavigator!

    override func setUp() {
        super.setUp()
        mockNavigator = MockNavigator()
        router = DeeplinkRouter(isActive: false, navigator: mockNavigator)
    }

    func testLastDeeplinkIsStoredWhenInactive() async {
        // Given
        let deeplink = URL(string: "myapp://profile/123")!

        // When
        await router.handle(deeplink: deeplink)

        // Then
        XCTAssertEqual(router.lastDeeplink, deeplink, "lastDeeplink should store the deeplink when isActive is false.")
    }

    func testHandleLastDeeplinkWhenActive() async {
        // Given
        let deeplink = URL(string: "myapp://profile/123")!
        router.isActive = false
        await router.handle(deeplink: deeplink)

        // When
        router.isActive = true
        await router.handleLastDeeplink()

        // Then
        XCTAssertNil(router.lastDeeplink, "lastDeeplink should be nil after it has been handled.")
    }

    func testLoadingIndicator() async {
        // Arrange
        let mockNavigator = MockNavigator()
        let router = DeeplinkRouter(isActive: true, navigator: mockNavigator, deeplinkTypes: [MockDeeplink.self])
        let testDeeplink = URL(string: "myapp://mock")!

        // Act
        await router.handle(deeplink: testDeeplink)

        // Assert
        XCTAssertEqual(mockNavigator.loadingCalls, [true, false], "Loading indicator should be turned on and then off.")
    }

    func testDeeplinkRouting() async {
        // Arrange
        let mockNavigator = MockNavigator()
        let router = DeeplinkRouter(isActive: true, navigator: mockNavigator, deeplinkTypes: [MockDeeplink.self])
        let testDeeplink = URL(string: "myapp://mock")!

        // Act
        await router.handle(deeplink: testDeeplink)

        // Assert
        // Проверяем, что диплинк был обработан
        XCTAssertTrue(MockDeeplink.handled, "MockDeeplink should handle the deeplink.")
    }

    func testRegisterSingleDeeplink() {
        // Given
        let mockDeeplinkType: AnyDeeplink.Type = MockDeeplink.self

        // When
        router.register(deeplinks: [mockDeeplinkType])

        // Then
        XCTAssertEqual(router.deeplinkTypes.count, 1)
        XCTAssertTrue(router.deeplinkTypes.contains { $0 == MockDeeplink.self })
    }

    func testRegisterMultipleDeeplinks() {
        // Given
        let mockDeeplinkType1: AnyDeeplink.Type = MockDeeplink.self
        let mockDeeplinkType2: AnyDeeplink.Type = AnotherMockDeeplink.self

        // When
        router.register(deeplinks: [mockDeeplinkType1, mockDeeplinkType2])

        // Then
        XCTAssertEqual(router.deeplinkTypes.count, 2)
        XCTAssertTrue(router.deeplinkTypes.contains { $0 == MockDeeplink.self })
        XCTAssertTrue(router.deeplinkTypes.contains { $0 == AnotherMockDeeplink.self })
    }

    func testRegisterDeeplinksTwice() {
        // Given
        let mockDeeplinkType1: AnyDeeplink.Type = MockDeeplink.self
        let mockDeeplinkType2: AnyDeeplink.Type = AnotherMockDeeplink.self

        // When
        router.register(deeplinks: [mockDeeplinkType1])
        router.register(deeplinks: [mockDeeplinkType2])

        // Then
        XCTAssertEqual(router.deeplinkTypes.count, 2)
        XCTAssertTrue(router.deeplinkTypes.contains { $0 == MockDeeplink.self })
        XCTAssertTrue(router.deeplinkTypes.contains { $0 == AnotherMockDeeplink.self })
    }
}
#endif
