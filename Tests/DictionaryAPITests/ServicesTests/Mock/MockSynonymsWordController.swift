//
//  MockSynonymsWordController.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation
@testable import DictionaryAPI

final class MockSynonymsWordController: SynonymsWordControllerProtocol {
    
    private(set) var capturedURL: URL?
    private(set) var capturedDecoder: JSONDecoder?
    
    var stubbedResult: Result<[SynonymsWordDto], Error> = .success([])
    
    func getSynonymsWord(_ url: URL, decoder: JSONDecoder) async throws -> [DictionaryAPI.SynonymsWordDto] {
        capturedURL = url
        capturedDecoder = decoder
        
        switch stubbedResult {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
