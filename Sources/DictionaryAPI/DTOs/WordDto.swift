//
//  WordDto.swift
//  DictionaryAPI
//
//  Created by Gokhan on 1.11.2025.
//

import Foundation

public struct WordDto: Decodable, Sendable {
    public let word: String
    public let phonetic: String?
    public let phonetics: [Phonetic]
    public let meanings: [Meaning]
}

public struct Phonetic: Decodable, Sendable {
    public let text: String?
    public let audio: String?

    public var audioURL: URL? {
        guard let audio, !audio.isEmpty else { return nil }
        return URL(string: audio)
    }
}

public struct Meaning: Decodable, Sendable {
    public let partOfSpeech: String
    public let definitions: [Definition]
    public let synonyms: [String]
    public let antonyms: [String]
}

public struct Definition: Decodable, Sendable {
    public let definition: String
    public let example: String?
    public let synonyms: [String]
    public let antonyms: [String]
}
