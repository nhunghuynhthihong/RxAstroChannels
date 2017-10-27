//
//  Serialization.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation
import Foundation

typealias Serialization = [String: Any]
enum Method: String {
    case GET = "GET"
}

protocol SerializationKey {
    var stringValue: String {get}
}

extension RawRepresentable where RawValue == String {
    var stringValue: String {
        return rawValue
    }
}

protocol SerializationValue {
    
}

extension Bool: SerializationValue {}
extension String: SerializationValue {}
extension Int: SerializationValue {}
extension Dictionary: SerializationValue {}
extension Array: SerializationValue {}
extension Date: SerializationValue {}
extension Double: SerializationValue {}

extension Dictionary where Key == String, Value: Any {
    func value<V: SerializationValue>(forKey key: SerializationKey) -> V? {
        return self[key.stringValue] as? V
    }
}
