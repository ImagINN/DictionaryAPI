//
//  SynonymsWordController.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation
import Alamofire

public protocol SynonymsWordControllerProtocol {
    
    func getSynonymsWord(_ url: URL, decoder: JSONDecoder) async throws -> [SynonymWordDto]
}

public final class SynonymsWordController: SynonymsWordControllerProtocol {
    
    private let session: Session
    
    public init(session: Session) { self.session = session }
    
    public init(configuration: URLSessionConfiguration = .af.default) {
        self.session = Session(configuration: configuration)
    }
    
    public func getSynonymsWord(_ url: URL, decoder: JSONDecoder) async throws -> [SynonymWordDto] {
        
        try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get)
                .validate()
                .responseDecodable(of: [SynonymWordDto].self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let value):
                        let filtered = value.filter { $0.score != nil }
                        let sorted = filtered.sorted { ($0.score ?? 0) > ($1.score ?? 0) }
                        let topFive = Array(sorted.prefix(5))
                        continuation.resume(returning: topFive)
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
