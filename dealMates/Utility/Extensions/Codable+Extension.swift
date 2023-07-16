//
//  Codable+Extension.swift
//  dealMates
//
//  Created by Stanislav on 10.06.2023.
//

import Foundation

extension Encodable {
    
    func encodeToJSON() throws -> String? {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }

    func encodeToData() throws -> Data {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }

    func asDictionary() throws -> [String: Any] {
        
        let data = try JSONEncoder().encode(self)

        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    var dictionary: [String: Any]? {
        
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }

    var dictionaryWithISO8601Date: [String: Any]? {
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Decodable {
    
    static func decode(data: Data) throws -> Self {
        
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}
