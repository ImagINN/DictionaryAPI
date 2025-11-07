//
//  WordController.swift
//  DictionaryAPI
//
//  Created by Gokhan on 1.11.2025.
//

import Foundation
import Alamofire

public protocol WordControllerProtocol {
    
    func getWord(_ url: URL, decoder: JSONDecoder) async throws -> [WordDto]
}

public final class WordController: WordControllerProtocol {

    private let session: Session
    
    public init(session: Session) { self.session = session }

    public init(configuration: URLSessionConfiguration = .af.default) {
        self.session = Session(configuration: configuration)
    }

    public func getWord(_ url: URL, decoder: JSONDecoder) async throws -> [WordDto] {
        try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get)
                .validate()
                .responseDecodable(of: [WordDto].self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let afError):
                        let appError = ErrorHandler.map(
                            error: afError,
                            response: response.response,
                            data: response.data
                        )
                        continuation.resume(throwing: appError)
                    }
                }
        }
    }
}
