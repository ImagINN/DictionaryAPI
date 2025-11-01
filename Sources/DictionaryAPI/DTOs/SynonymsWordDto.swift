//
//  SynonymsWordDto.swift
//  DictionaryAPI
//
//  Created by Gokhan on 1.11.2025.
//

import Foundation

public struct SynonymWordDto: Decodable, Sendable {
    public let word: String
    public let score: Int?
}
