//
//  ParametersEncoding.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

public typealias Parameters = [String: Any]

/// A ParameterEncoder performs one function which is to encode parameters. This
/// method can fail so it throws an error and we need to handle.
public protocol ParameterEncoder {
    /// The encode method takes two parameters an inout URLRequest and Parameters. (To
    /// avoid ambiguity from henceforth I will refer to function parameters as
    /// arguments.) INOUT is a Swift keyword that defines an argument as a reference
    /// argument. Usually, variables are passed to functions as value types. By placing
    /// inout in front of the argument we define it as a reference type.
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters)
    throws
}

public enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}


/// By having custom errors you can define your own error message and know exactly where the error came from.
public enum NetworkError: String, Error {
    case parameterNil = "Parameters are nil."
    case encodingFailed = "Parameters encoding failed."
    case missingURL = "URL is nil"
}

public enum ParametersEncoding {
    case url
    case json
}

