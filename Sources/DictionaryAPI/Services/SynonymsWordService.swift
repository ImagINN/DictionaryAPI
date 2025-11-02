//
//  SynonymsWordService.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation

public protocol SynonymsWordServiceProtocol {
    
    func fetchSynonyms(for word: String) async throws -> [SynonymsWordDto]
}

public final class SynonymsWordService: SynonymsWordServiceProtocol {

    private let client: SynonymsWordControllerProtocol
    private let decoder: JSONDecoder
    
    public init(
        client: SynonymsWordControllerProtocol = SynonymsWordController(),
        decoder: JSONDecoder = .init()
    ) {
        self.client = client
        self.decoder = decoder
    }
    
    public func fetchSynonyms(for word: String) async throws -> [SynonymsWordDto] {
        try await client.getSynonymsWord(
            EndpointURLHandler.synonymsWord(word).url,
            decoder: decoder
        )
    }
}
