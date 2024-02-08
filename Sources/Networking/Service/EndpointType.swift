//
//  EndpointType.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

/// This protocol will contain all the information to configure an EndPoint. What is an
/// EndPoint? Well, essentially it is a URLRequest with all its comprising components
/// such as headers, query parameters, and body parameters. The EndPointType protocol is
/// the cornerstone of our network layers implementation.
public protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
