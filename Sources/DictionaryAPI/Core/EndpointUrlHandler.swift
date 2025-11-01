//
//  Endpoint.swift
//  DictionaryAPI
//
//  Created by Gokhan on 1.11.2025.
//

import Foundation

public enum EndpointUrlHandler {
    
    static let wordBaseUrl = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/")
    static let synonymsWordBaseUrl = URL(string: "https://api.datamuse.com/words?rel_syn=")
    
    case word(_ word: String)
    case synonymsWord(_ word: String)
    
    var url: URL? {
        switch self {
        case let .word(word):
            return Self.wordBaseUrl?.appendingPathComponent(word)
        case let .synonymsWord(word):
            return Self.synonymsWordBaseUrl.flatMap { URL(string: "\($0)\(word)") }
        }
    }
}
