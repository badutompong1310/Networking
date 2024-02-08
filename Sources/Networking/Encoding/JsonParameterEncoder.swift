//
//  JsonParameterEncoder.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    /// Similar to the URLParameter encoder but here we encode the parameters
    /// to JSON and add appropriate headers once again.
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}


