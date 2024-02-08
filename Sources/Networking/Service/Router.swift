//
//  Router.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

/// This task is essentially what will do all the work. We keep the variable
/// private as we do not want anyone outside this class modifying our task.
class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    func request(_ apiServer: ApiServer, _ route: EndPoint) -> URLRequest? {
        do {
            return try self.buildRequest(apiServer, from: route)
        } catch {
            return nil
        }
    }
    /// This function is responsible for all the vital work in our network
    /// layer. Essentially converting EndPointType to URLRequest. Once our
    /// EndPoint becomes a request we can pass it to the session. A lot is
    /// being done here so we will look at each method separately.
    fileprivate func buildRequest(_ apiServer: ApiServer, from route: EndPoint) throws -> URLRequest? {
        guard let baseUrl = URL(string: apiServer.baseUrl) else {return nil}
        var url = baseUrl
        url = baseUrl.appendingPathComponent(apiServer.version)
        var request = URLRequest(url: url.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(bodyParameters: let bodyParameters,
                                    urlParameters: let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestParametersAndHeaders(bodyParameters: let bodyParameters,
                                              urlParameters: let urlParameters,
                                              additionalHeader: let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    /// This function is responsible for encoding our parameters.
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request,
                                                with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    /// This function is responsible for adding the additional headers
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
}
