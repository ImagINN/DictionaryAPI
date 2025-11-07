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

    public init(
        client: WordControllerProtocol = WordController(),
        decoder: JSONDecoder = .init()
    ) {
        self.client = client
        self.decoder = decoder
    }

    public func fetchWord(for word: String) async throws -> [WordDto] {
        let (data, response) = try await client.getRawData(from: EndpointURLHandler.word(word).url)
        
        do {
            let dtoArray = try decoder.decode([WordDto].self, from: data)
            return dtoArray
        } catch let decodingError {
            do {
                let apiError = try decoder.decode(ApiErrorDto.self, from: data)
                throw apiError
            } catch {
                throw decodingError
            }
        }
    }
}
