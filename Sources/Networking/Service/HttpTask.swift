//
//  HttpTask.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

public typealias HTTPHeaders = [String: String]

/// The HTTPTask is responsible for configuring parameters for a specific endPoint. You
/// can add as many cases as are applicable to your Network Layers requirements.
public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?,
        urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        urlParameters: Parameters?,
        additionalHeader: HTTPHeaders?)
}
