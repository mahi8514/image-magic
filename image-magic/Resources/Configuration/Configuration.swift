//
//  Configuration.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import Foundation

struct Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String, bundle: Bundle = .main) throws -> T where T: LosslessStringConvertible {
        guard let object = bundle.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}


/// Access values stored in config.xcconfig.
enum APIConfig {
    static var baseUrl: String {
        return try! Configuration.value(for: "BASE_URL")
    }
}

enum APIKeys {
    static var imgurClientId: String {
        return try! Configuration.value(for: "IMGUR_CLIENT_ID")
    }
}
