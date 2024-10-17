//
//  DeeplinkRouterProtocol.swift
//  
//
//  Created by Иван Копиев on 17.10.2024.
//

import Foundation

public protocol DeeplinkRouterProtocol {
    var isActive: Bool { get set }
    var navigator: NavigatorProtocol { get set }
    func handle(deeplink: URL)
    func handleLastDeeplink()
    func register(deeplinks: [AnyDeeplink.Type])
}
