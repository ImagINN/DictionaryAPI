//
//  WordServiceTest.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import XCTest
@testable import DictionaryAPI

final class WordServiceTests: XCTestCase {

    private func makeDTOs() -> [WordDto] {
        return [
            WordDto(
                word: "home",
                phonetic: "/hoʊm/",
                phonetics: [Phonetic(text: "/hoʊm/", audio: "https://audio.mp3")],
                meanings: [
                    Meaning(
                        partOfSpeech: "noun",
                        definitions: [Definition(definition: "A place to live", example: "Go home", synonyms: [], antonyms: [])],
                        synonyms: ["house"],
                        antonyms: []
                    )
                ]
            )
        ]
    }

    // MARK: - Success

    func test_fetchWord_success_returnsDTOs() async throws {
        let spy = MockWordController()
        let expected = makeDTOs()
        spy.stubbedResult = .success(expected)

        let customDecoder = JSONDecoder()
        let sut = WordService(client: spy, decoder: customDecoder)

        let result = try await sut.fetchWord(for: "home")

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.word, "home")
        XCTAssertEqual(spy.capturedURL, EndpointURLHandler.word("home").url)
        XCTAssertTrue(spy.capturedDecoder === customDecoder)
    }

    // MARK: - Error

    func test_fetchWord_propagatesError_fromController() async {
        enum DummyError: Error { case boom }
        let spy = MockWordController()
        spy.stubbedResult = .failure(DummyError.boom)

        let sut = WordService(client: spy, decoder: .init())

        do {
            _ = try await sut.fetchWord(for: "fail")
            XCTFail("Hata bekleniyordu")
        } catch {
            XCTAssertTrue(error is DummyError)
        }
    }

    // MARK: - URL doğrulama

    func test_fetchWord_buildsCorrectURL() async throws {
        let spy = MockWordController()
        spy.stubbedResult = .success([])

        let sut = WordService(client: spy, decoder: .init())
        let word = "test-word"

        _ = try await sut.fetchWord(for: word)

        XCTAssertEqual(spy.capturedURL, EndpointURLHandler.word(word).url)
    }
}
