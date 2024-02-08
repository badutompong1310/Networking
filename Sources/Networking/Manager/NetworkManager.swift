//
//  NetworkManager.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Combine
import ErrorModel

public struct NetworkManager<E: EndPointType> {
    
    public var apiServer: ApiServer
    
    public init (apiServer: ApiServer) {
        self.apiServer = apiServer
    }
    
    public func request<T: Decodable>(
            type: T.Type,
            endPoint: E
        ) -> AnyPublisher<T, ErrorModel> {
            guard let request = Router<E>().request(apiServer, endPoint)
            else {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { $0.asHTTPError }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
                
        }
}
