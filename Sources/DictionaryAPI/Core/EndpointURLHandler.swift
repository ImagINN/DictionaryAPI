//
//  Endpoint.swift
//  DictionaryAPI
//
//  Created by Gokhan on 1.11.2025.
//

import Foundation

public enum EndpointURLHandler {
    
    static let wordBaseUrl = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/")
    static let synonymsWordBaseUrl = URL(string: "https://api.datamuse.com/words?rel_syn=")
    
    case word(_ word: String)
    case synonymsWord(_ word: String)
    
    var url: URL {
        switch self {
        case let .word(word):
            guard let baseUrl = Self.wordBaseUrl else {
                fatalError("Invalid word base URL")
            }
            return baseUrl.appendingPathComponent(word)
            
        case let .synonymsWord(word):
            guard let baseUrl = Self.synonymsWordBaseUrl,
                  let url = URL(string: "\(baseUrl)\(word)") else {
                fatalError("Invalid synonyms base URL")
            }
            return url
        }
    }
}
