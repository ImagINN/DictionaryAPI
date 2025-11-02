//
//  MockWordController.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation
@testable import DictionaryAPI

final class MockWordController: WordControllerProtocol {

    private(set) var capturedURL: URL?
    private(set) var capturedDecoder: JSONDecoder?

    var stubbedResult: Result<[WordDto], Error> = .success([])

    func getWord(_ url: URL, decoder: JSONDecoder) async throws -> [WordDto] {
        capturedURL = url
        capturedDecoder = decoder
        
        switch stubbedResult {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
