//
//  ErrorHandler.swift
//  DictionaryAPI
//
//  Created by Gokhan on 1.11.2025.
//

import Foundation
import Alamofire

public struct APIErrorBody: Decodable {
    public let title: String?
    public let message: String?
}

public enum AppError: Error {
    case networkNoInternet
    case networkTimeout
    case cancelled
    case server(status: Int, message: String?)
    case decoding
    case invalidResponse
    case unknown(Error?)
}

public extension AppError {
    var userMessage: String {
        switch self {
        case .networkNoInternet:
            return "No internet connection. Please check your network and try again."
        case .networkTimeout:
            return "The request timed out. Please try again later."
        case .cancelled:
            return "The request was cancelled."
        case .server(_, let message):
            return message ?? "A server error occurred. Please try again."
        case .decoding:
            return "There was a problem reading the server response."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }
}

public enum ErrorHandler {
    
    public static func map(
        error: Error?,
        response: HTTPURLResponse?,
        data: Data?
    ) -> AppError {
        if let http = response, !(200..<300).contains(http.statusCode) {
            let body = data.flatMap { try? JSONDecoder().decode(APIErrorBody.self, from: $0) }
            let msg = body?.message ?? body?.title
            return .server(status: http.statusCode, message: msg)
        }

        if let error = error {
            if let afError = error as? AFError {
                switch afError {
                case .explicitlyCancelled: return .cancelled
                    
                case .sessionTaskFailed(let underlying as URLError):
                    return mapURLError(underlying)
                    
                case .responseSerializationFailed(let reason):
                    if case .decodingFailed = reason { return .decoding }
                    return .decoding
                    
                default:
                    return .unknown(afError)
                }
            } else if let urlErr = error as? URLError {
                return mapURLError(urlErr)
            } else if error is DecodingError {
                return .decoding
            } else {
                return .unknown(error)
            }
        }

        return .invalidResponse
    }

    private static func mapURLError(_ e: URLError) -> AppError {
        switch e.code {
        case .notConnectedToInternet: return .networkNoInternet
        case .timedOut: return .networkTimeout
        case .cancelled: return .cancelled
        default: return .unknown(e)
        }
    }
}
