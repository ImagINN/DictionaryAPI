//
//  WordService.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation

public protocol WordServiceProtocol {
    func fetchWord(for word: String) async throws -> [WordDto]
}

public final class WordService: WordServiceProtocol {

    private let client: WordControllerProtocol
    private let decoder: JSONDecoder

    public init(client: WordControllerProtocol = WordController(),
                decoder: JSONDecoder = .init()) {
        self.client = client
        self.decoder = decoder
    }

    public func fetchWord(for word: String) async throws -> [WordDto] {
        try await client.getWord(
            EndpointURLHandler.word(word).url,
            decoder: decoder
        )
    }
}
