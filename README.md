# DeeplinkRouter 
[![Swift](https://github.com/KopievDev/DeeplinkRouter/actions/workflows/swift.yml/badge.svg)](https://github.com/KopievDev/DeeplinkRouter/actions/workflows/swift.yml)

**DeeplinkRouter** is a lightweight, flexible, and easy-to-use framework for managing deep links and navigation within iOS applications. It allows you to register and handle different types of deep links, providing a clear way to navigate to specific parts of your app.

## Features
- Simple deep link registration and routing.
- Works seamlessly with `UINavigationController`, `UITabBarController`, and other standard view controllers.
- Asynchronous handling of deep links.
- Customizable and extendable for any app architecture.

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/KopievDev/DeeplinkRouter", from: "1.0.0")
]
```

Or use the Xcode integration to add **DeeplinkRouter** as a Swift Package Dependency.

## Usage

### 1. Registering Deeplinks

Start by defining your deeplink types. Each deeplink must conform to the `AnyDeeplink` protocol.

```swift
struct ProfileDeeplink: AnyDeeplink {
    let userId: String

    static func canHandle(deeplink: URL) -> ProfileDeeplink? {
        guard let userId = URLComponents(url: deeplink, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == "userId" })?.value else { return nil }

        return ProfileDeeplink(userId: userId)
    }

    func handle(deeplink: URL, navigator: NavigatorProtocol) {
        let profileVC = ProfileViewController(userId: userId)
        navigator.topNavController?.pushViewController(profileVC, animated: true)
    }
}
```

### 2. Initializing `DeeplinkRouter`

To set up the router, you need to register your deeplink types and activate the router:

```swift
let navigator = BaseNavigator()
let router = DeeplinkRouter(
    isActive: true,
    navigator: navigator,
    deeplinkTypes: [ProfileDeeplink.self]
)
```

### 3. Handling Deeplinks

Once registered, handle incoming deeplinks by calling:

```swift
if let url = URL(string: "myapp://profile?userId=123") {
    Task {
        await router.handle(deeplink: url)
    }
}
```

### 4. Handling Saved Deeplinks

If a deep link comes when the app is inactive, you can handle it later:

```swift
router.handleLastDeeplink()
```
