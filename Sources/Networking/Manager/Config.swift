//
//  Config.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

public enum Environment {
    case production
    case development
}

public protocol ApiServer {
    var baseUrl: String { get set }
    var version: String { get set }
}

public protocol ApiServerFactoryProtocol {
    func create() -> ApiServer
}

public protocol EnvironmentFactoryProtocol {
    func create() -> ApiServer
}
