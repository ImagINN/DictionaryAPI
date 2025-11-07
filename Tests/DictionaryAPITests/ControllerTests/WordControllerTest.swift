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
    
    // MARK: - Success

    func test_getWord_success_baArray_decodesAndLogs() async throws {
        MockURLProtocol.mode = .success(status: 200, data: mockFirstWordJSON)
        
        let sut: WordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.word("ba").url
        
        let dtos = try await sut.getWord(url, decoder: JSONDecoder())
        
        XCTAssertEqual(dtos.count, 3)
        XCTAssertTrue(dtos.allSatisfy { $0.word == "ba" })
        XCTAssertFalse(dtos[0].meanings.isEmpty)
        
        print("/ba response (raw):\n\(prettyJSONString(from: mockFirstWordJSON))")
        
        for (i, item) in dtos.enumerated() {
            let defCount = item.meanings.flatMap(\.definitions).count
            
            print("ba[\(i)] word=\(item.word), meanings=\(item.meanings.count), totalDefinitions=\(defCount)")
        }
    }

    func test_getWord_success_homeArray_decodesAndLogs() async throws {
        MockURLProtocol.mode = .success(status: 200, data: mockSecondWordJSON)
        
        let sut: WordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.word("home").url
        
        let dtos = try await sut.getWord(url, decoder: JSONDecoder())
        
        XCTAssertEqual(dtos.count, 1)
        let dto = try XCTUnwrap(dtos.first)
        XCTAssertEqual(dto.word, "home")
        XCTAssertEqual(dto.phonetics.count, 2)
        XCTAssertEqual(dto.meanings.first?.partOfSpeech, "noun")
        XCTAssertNil(dto.phonetics.first?.audioURL)
        XCTAssertNotNil(dto.phonetics.last?.audioURL)
        
        print("/home response (raw):\n\(prettyJSONString(from: mockSecondWordJSON))")
        
        let totalDef = dto.meanings.flatMap(\.definitions).count
        print("home word=\(dto.word), phonetics=\(dto.phonetics.count), totalDefinitions=\(totalDef)")
    }
    
    // MARK: - Error Tests
    
    func test_getWord_noResults_404_mapsToNoResults() async {
        MockURLProtocol.mode = .success(status: 404, data: mockNoDefinitionsFoundJSON)

        let sut: WordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.word("homa").url
        
        print("\n=== Running test_getWord_noResults_404_mapsToNoResults ===")
        print("Request URL:", url.absoluteString)
        print("Mock Status Code: 404")
        print("Mock Body:\n\(prettyJSONString(from: mockNoDefinitionsFoundJSON))")

        do {
            _ = try await sut.getWord(url, decoder: JSONDecoder())
            XCTFail("Hata bekleniyordu")
        } catch let error as AppError {
            switch error {
            case .noResults(let title, let message, let resolution):
                print("Yakalanan AppError.noResults:")
                print("title: \(String(describing: title))")
                print("message: \(message ?? "<nil>")")
                print("resolution: \(resolution ?? "<nil>")")
                
                XCTAssertEqual(title, "No Definitions Found")
                XCTAssertNotNil(message)
                XCTAssertNotNil(resolution)
            default:
                XCTFail("AppError.noResults bekleniyordu, aldık: \(error)")
            }
        } catch {
            XCTFail("AppError bekleniyordu, aldık: \(error)")
        }
    }

    func test_getWord_noResults_200Body_mapsToNoResultsOnDecodingFail() async {
        MockURLProtocol.mode = .success(status: 200, data: mockNoDefinitionsFoundJSON)

        let sut: WordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.word("home").url
        
        print("\n=== Running test_getWord_noResults_200Body_mapsToNoResultsOnDecodingFail ===")
        print("Request URL:", url.absoluteString)
        print("Mock Status Code: 200")
        print("Mock Body:\n\(prettyJSONString(from: mockNoDefinitionsFoundJSON))")

        do {
            _ = try await sut.getWord(url, decoder: JSONDecoder())
            XCTFail("Hata bekleniyordu")
        } catch let error as AppError {
            switch error {
            case .noResults(let title, let message, let resolution):
                print("Yakalanan AppError.noResults:")
                print("title: \(String(describing: title))")
                print("message: \(message ?? "<nil>")")
                print("resolution: \(resolution ?? "<nil>")")
                
                XCTAssertEqual(title, "No Definitions Found")
                XCTAssertNotNil(message)
                XCTAssertNotNil(resolution)
            default:
                XCTFail("AppError.noResults bekleniyordu, aldık: \(error)")
            }
        } catch {
            XCTFail("AppError bekleniyordu, aldık: \(error)")
        }
    }
    
    func test_liveEndpoint_homa_matchesMockSchema() async throws {
        let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/homa")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            XCTFail("Geçersiz HTTP yanıtı")
            return
        }

        print("\nLive endpoint:", url)
        print("Status:", http.statusCode)
        print("Body:\n\(prettyJSONString(from: data))")

        do {
            let _ = try JSONDecoder().decode([WordDto].self, from: data)
            XCTFail("Bu kelime bir veri dödürüyor.")
        } catch {
            do {
                let liveError = try JSONDecoder().decode(ApiErrorDto.self, from: data)
                print("ApiErrorDto yakalandı:")
                print("title:", liveError.title)
                print("message:", liveError.message)
                print("resolution:", liveError.resolution)

                let mockError = try JSONDecoder().decode(ApiErrorDto.self, from: mockNoDefinitionsFoundJSON)
                XCTAssertEqual(liveError, mockError, "Gerçek endpoint mock ile aynı olmalı")
            } catch {
                XCTFail("ApiErrorDto bekleniyordu ama decode edilemedi: \(error)")
            }
        }
    }

    func test_getWord_invalidJSON_mapsToDecoding() async {
        MockURLProtocol.mode = .success(status: 200, data: Data("{ invalid ]".utf8))
        
        let sut: WordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.word("home").url

        do {
            _ = try await sut.getWord(url, decoder: JSONDecoder())
            XCTFail("Decoding hatası bekleniyordu")
        } catch let error as AppError {
            if case .decoding = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("AppError.decoding bekleniyordu, alınan: \(error)")
            }
        } catch {
            XCTFail("AppError.decoding bekleniyordu, alınan: \(error)")
        }
    }

    func test_getWord_noInternet_mapsToNetworkNoInternet() async {
        MockURLProtocol.mode = .fail(error: URLError(.notConnectedToInternet))
        
        let sut: WordControllerProtocol = makeSUT()
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
    
    // MARK: - Helper

    private func makeSUT() -> WordControllerProtocol {
        WordController(session: makeStubbedSession())
    }
}
