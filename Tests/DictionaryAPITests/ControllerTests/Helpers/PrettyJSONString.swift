//
//  PrettyJSONString.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation

func prettyJSONString(from data: Data) -> String {
    (try? JSONSerialization.jsonObject(with: data))
        .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: [.prettyPrinted]) }
        .flatMap { String(data: $0, encoding: .utf8) } ?? "<invalid json>"
}
