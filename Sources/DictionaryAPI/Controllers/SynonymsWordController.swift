//
//  SynonymsWordController.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation
import Alamofire

public protocol SynonymsWordControllerProtocol {
    
    func getSynonymsWord(_ url: URL, decoder: JSONDecoder) async throws -> SynonymWordDto
}

public final class SynonymsWordController: SynonymsWordControllerProtocol {
    
    private let session: Session
    
    public init(configuration: URLSessionConfiguration = .af.default) {
        self.session = Session(configuration: configuration)
    }
    
    public func getSynonymsWord(_ url: URL, decoder: JSONDecoder) async throws -> SynonymWordDto {
        
        try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get)
                .validate()
                .responseDecodable(of: SynonymWordDto.self, decoder: decoder) { response in
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
