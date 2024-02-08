//
//  Encodable+Dictionary.swift
//  Networking
//
//  Created by Handy Handy on 18/01/24.
//

import Foundation

public extension Encodable {
  func asDictionary() -> [String: Any] {
      do {
          let data = try JSONEncoder().encode(self)
          guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
          }
          return dictionary
      } catch _ {
          print("Failed to convert codable object to dictionary")
          return [:]
      }
  }
}
