//
//  SynonymsWordServiceTest.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import XCTest
@testable import DictionaryAPI

final class SynonymsWordServiceTest: XCTestCase {
    
    private func makeDtos() -> [SynonymsWordDto] {
        return [
            SynonymsWordDto(
                word: "base",
                score: 58114
            )
        ]
    }
    
    // MARK: - Success
    
    func test_fetchSynonymsWord_success_returnsDTOs() async throws {
        let spy = MockSynonymsWordController()
        let expected = makeDtos()
        spy.stubbedResult = .success(expected)
        
        let customDecoder = JSONDecoder()
        let sut = SynonymsWordService(client: spy, decoder: customDecoder)
        
        let result = try await sut.fetchSynonyms(for: "home")
        
        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.word, "base")
        XCTAssertEqual(spy.capturedURL, EndpointURLHandler.synonymsWord("home").url)
        XCTAssertTrue(spy.capturedDecoder === customDecoder)
    }
    
    // MARK: - Error

    func test_fetchSynonymsWord_propagatesError_fromController() async {
        enum DummyError: Error { case boom }
        let spy = MockSynonymsWordController()
        spy.stubbedResult = .failure(DummyError.boom)

        let sut = SynonymsWordService(client: spy, decoder: .init())

        do {
            _ = try await sut.fetchSynonyms(for: "fail")
            XCTFail("Hata bekleniyordu")
        } catch {
            XCTAssertTrue(error is DummyError)
        }
    }
    
    // MARK: - URL doğrulama

    func test_fetchSynonymsWord_buildsCorrectURL() async throws {
        let spy = MockSynonymsWordController()
        spy.stubbedResult = .success([])

        let sut = SynonymsWordService(client: spy, decoder: .init())
        let word = "test-word"

        _ = try await sut.fetchSynonyms(for: word)

        XCTAssertEqual(spy.capturedURL, EndpointURLHandler.synonymsWord(word).url)
    }
}
