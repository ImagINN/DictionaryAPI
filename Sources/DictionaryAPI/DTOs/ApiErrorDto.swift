//
//  ApiErrorDto.swift
//  DictionaryAPI
//
//  Created by Gokhan on 7.11.2025.
//

import Foundation

public struct ApiErrorDto: Decodable, Error, Equatable {
    
    public let title: String
    public let message: String
    public let resolution: String
    
    public init(title: String, message: String, resolution: String) {
        self.title = title
        self.message = message
        self.resolution = resolution
    }
}
