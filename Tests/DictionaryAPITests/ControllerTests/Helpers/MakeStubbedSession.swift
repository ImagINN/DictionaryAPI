//
//  Mock.swift
//  DictionaryAPI
//
//  Created by Gokhan on 2.11.2025.
//

import Foundation
import Alamofire

func makeStubbedSession() -> Session {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return Session(configuration: config)
}
