//
//  UrlParameterEncoder.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    /// The code takes parameters and makes them safe to be passed as
    /// URLparameters. As you should know some characters are forbidden in URLs.
    /// Parameters are also separated by the ‘&’ symbol, so we need to cater for all of
    /// that. We also add appropriate headers for the request if they are not set.
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (var key,value) in parameters {
                // If value of param is a collection
                if let val = value as? [Any]{
                    key += "[]"
                    val.forEach { (data) in
                        let queryItem = URLQueryItem(name: key,value: "\(data)")
                        urlComponents.queryItems?.append(queryItem)
                        urlRequest.url = urlComponents.url
                    }
                    continue
                }
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
                urlRequest.url = urlComponents.url
            }
        }
        if urlRequest.value(forHTTPHeaderField: "Content-type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
