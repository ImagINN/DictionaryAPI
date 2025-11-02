//
//  WordControllerTest.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import XCTest
import Alamofire
@testable import DictionaryAPI

final class WordControllerTest: XCTestCase {
    
    // MARK: - Success (Array) + Logging

    func test_getWord_success_baArray_decodesAndLogs() async throws {
        MockURLProtocol.mode = .success(status: 200, data: mockBaArrayJSON)
        let sut = WordController(session: makeStubbedSession())
        let url = EndpointURLHandler.word("ba").url
        
        let dtos = try await sut.getWord(url, decoder: JSONDecoder())
        
        XCTAssertEqual(dtos.count, 3)
        XCTAssertTrue(dtos.allSatisfy { $0.word == "ba" })
        XCTAssertFalse(dtos[0].meanings.isEmpty)
        
        print("/ba response (raw):\n\(prettyJSONString(from: mockBaArrayJSON))")
        for (i, item) in dtos.enumerated() {
            let defCount = item.meanings.flatMap(\.definitions).count
            print("ba[\(i)] word=\(item.word), meanings=\(item.meanings.count), totalDefinitions=\(defCount)")
        }
    }

    func test_getWord_success_homeArray_decodesAndLogs() async throws {
        MockURLProtocol.mode = .success(status: 200, data: mockHomeArrayJSON)
        let sut = WordController(session: makeStubbedSession())
        let url = EndpointURLHandler.word("home").url
        
        let dtos = try await sut.getWord(url, decoder: JSONDecoder())
        
        XCTAssertEqual(dtos.count, 1)
        let dto = try XCTUnwrap(dtos.first)
        XCTAssertEqual(dto.word, "home")
        XCTAssertEqual(dto.phonetics.count, 2)
        XCTAssertEqual(dto.meanings.first?.partOfSpeech, "noun")
        XCTAssertNil(dto.phonetics.first?.audioURL)
        XCTAssertNotNil(dto.phonetics.last?.audioURL)
        
        print("/home response (raw):\n\(prettyJSONString(from: mockHomeArrayJSON))")
        let totalDef = dto.meanings.flatMap(\.definitions).count
        print("home word=\(dto.word), phonetics=\(dto.phonetics.count), totalDefinitions=\(totalDef)")
    }
    
    // MARK: - Error Tests

    func test_getWord_serverError_mapsToAppErrorServer() async {
        let body = #"{"message":"Not Found"}"#.data(using: .utf8)!
        MockURLProtocol.mode = .success(status: 404, data: body)
        let sut = WordController(session: makeStubbedSession())
        let url = EndpointURLHandler.word("unknown").url

        do {
            _ = try await sut.getWord(url, decoder: JSONDecoder())
            XCTFail("Hata bekleniyordu")
        } catch let error as AppError {
            switch error {
            case .server(let status, let message):
                XCTAssertEqual(status, 404)
                XCTAssertEqual(message, "Not Found")
            default:
                XCTFail("AppError.server bekleniyordu, aldık: \(error)")
            }
        } catch {
            XCTFail("AppError bekleniyordu, aldık: \(error)")
        }
    }

    func test_getWord_invalidJSON_mapsToDecoding() async {
        MockURLProtocol.mode = .success(status: 200, data: Data("{ invalid ]".utf8))
        let sut = WordController(session: makeStubbedSession())
        let url = EndpointURLHandler.word("home").url

        do {
            _ = try await sut.getWord(url, decoder: JSONDecoder())
            XCTFail("Decoding hatası bekleniyordu")
        } catch let error as AppError {
            if case .decoding = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("AppError.decoding bekleniyordu, aldık: \(error)")
            }
        } catch {
            XCTFail("AppError.decoding bekleniyordu, aldık: \(error)")
        }
    }

    func test_getWord_noInternet_mapsToNetworkNoInternet() async {
        MockURLProtocol.mode = .fail(error: URLError(.notConnectedToInternet))
        let sut = WordController(session: makeStubbedSession())
        let url = EndpointURLHandler.word("home").url

        do {
            _ = try await sut.getWord(url, decoder: JSONDecoder())
            XCTFail("Hata bekleniyordu")
        } catch let error as AppError {
            if case .networkNoInternet = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("AppError.networkNoInternet bekleniyordu, aldık: \(error)")
            }
        } catch {
            XCTFail("AppError bekleniyordu, aldık: \(error)")
        }
    }
}
