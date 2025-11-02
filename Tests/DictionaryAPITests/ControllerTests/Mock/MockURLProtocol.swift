//
//  MockURLProtocol.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation
import Alamofire
import XCTest
@testable import DictionaryAPI

final class MockURLProtocol: URLProtocol {

    enum Mode {
        case success(status: Int, headers: [String:String] = ["Content-Type":"application/json"], data: Data?)
        case fail(error: Error)
    }

    static var mode: Mode = .success(status: 200, data: nil)

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        switch Self.mode {
        case .success(let status, let headers, let data):
            let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: headers)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data { client?.urlProtocol(self, didLoad: data) }
            client?.urlProtocolDidFinishLoading(self)

        case .fail(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

func makeStubbedSession() -> Session {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return Session(configuration: config)
}
