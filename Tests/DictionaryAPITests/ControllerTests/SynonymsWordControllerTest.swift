//
//  SynonymsWordControllerTest.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import XCTest
import Alamofire
@testable import DictionaryAPI

final class SynonymsWordControllerTest: XCTestCase {
    
    // MARK: - Success
    
    func test_getSynonymsWord_baArray_decodesAndLogs() async throws {
        MockURLProtocol.mode = .success(status: 200, data: mockFirstSynonymsWordJSON)
        
        let sut: SynonymsWordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.synonymsWord("ba").url
        
        let dtos = try await sut.getSynonymsWord(url, decoder: JSONDecoder())
        
        XCTAssertEqual(dtos.count, 4)
        XCTAssertFalse(dtos[0].word.isEmpty)
        XCTAssertFalse(dtos.contains { $0.score == nil })
        
        print("/ba response (raw):\n\(prettyJSONString(from: mockFirstSynonymsWordJSON))")
        
        for (i, item) in dtos.enumerated() {
            print("ba[\(i)] word=\(item.word), score=\(String(describing: item.score))")
        }
    }
    
    func test_getSysnonymsWord_success_homeArray_decodesAndLogs() async throws {
        MockURLProtocol.mode = .success(status: 200, data: mockSecondSynonymsWordJSON)
        
        let sut: SynonymsWordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.synonymsWord("home").url
        
        let dtos = try await sut.getSynonymsWord(url, decoder: JSONDecoder())
        
        XCTAssertEqual(dtos.count, 5)
        let dto = try XCTUnwrap(dtos.first)
        XCTAssertEqual(dto.word, "base")
        XCTAssertEqual(dto.score, 58114)
        
        print("/home response (raw):\n\(prettyJSONString(from: mockSecondSynonymsWordJSON))")
        print("home word=\(dto.word), score=\(String(describing: dto.score))")
        
        // MARK: - Error Tests
        
        func test_getSynonymsWord_serverError_mapsToAppErrorServer() async {
            let body = #"{"message":"Not Found"}"#.data(using: .utf8)!
            MockURLProtocol.mode = .success(status: 404, data: body)
            
            let sut: SynonymsWordControllerProtocol = makeSUT()
            let url = EndpointURLHandler.synonymsWord("unknown").url
            
            do {
                _ = try await sut.getSynonymsWord(url, decoder: JSONDecoder())
                XCTFail("Hata bekleniyordu")
            } catch let error as AppError {
                switch error {
                case .server(let status, let message):
                    XCTAssertEqual(status, 404)
                    XCTAssertEqual(message, "Not Found")
                default:
                    XCTFail("AppError.server bekleniyordu, alınan: \(error)")
                }
            } catch {
                XCTFail("AppError bekleniyordu, alınan: \(error)")
            }
        }
    }
    
    func test_getSynonymsWord_invalidJSON_mapsToDecoding() async {
        MockURLProtocol.mode = .success(status: 200, data: Data("{ invalid ]".utf8))
        
        let sut: SynonymsWordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.synonymsWord("home").url
        
        do {
            _ = try await sut.getSynonymsWord(url, decoder: JSONDecoder())
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
    
    func test_getSynonymsWord_noInternet_mapsToNetworkNoInternet() async {
        MockURLProtocol.mode = .fail(error: URLError(.notConnectedToInternet))
        
        let sut: SynonymsWordControllerProtocol = makeSUT()
        let url = EndpointURLHandler.synonymsWord("home").url
        
        do {
            _ = try await sut.getSynonymsWord(url, decoder: JSONDecoder())
            XCTFail("Hata bekleniyordu")
        } catch let error as AppError {
            if case .networkNoInternet = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("AppError.networkNoInternet bekleniyordu, alınan: \(error)")
            }
        } catch {
            XCTFail("AppError bekleniyordu, alınan: \(error)")
        }
    }
    
    // MARK: - Helper
    
    private func makeSUT() -> SynonymsWordControllerProtocol {
        SynonymsWordController(session: makeStubbedSession())
    }
}
