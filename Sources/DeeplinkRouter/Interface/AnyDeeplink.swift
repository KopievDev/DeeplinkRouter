//
//  AnyDeeplink.swift
//
//
//  Created by Иван Копиев on 17.10.2024.
//

#if os(iOS)
import UIKit

public protocol AnyDeeplink {
    static func canHandle(deeplink url: URL) -> Self?
    func handle(deeplink: URL, navigator: NavigatorProtocol) async
}
#endif
