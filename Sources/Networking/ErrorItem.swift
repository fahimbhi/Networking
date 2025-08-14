//
//  ErrorItem.swift
//  LoveLocal
//
//  Created by Fahim on 22/04/24.
//

import Foundation
import AnyCodable

public struct ErrorItem: Error, Decodable {
    public var uuid: String?
    public var status: Int?
    public var code: ErrorCode?
    public var type: ErrorType?
    public var date: Date?
    public var message: String?
    public var messageСode: String?
    public var cause: String?
    public var explanation: String?
    public var validationErrors: [ValidationErrorItem]?
    public var details: ErrorDetailsItem?
    
    public var text: String {
        if let message = message, !message.isEmpty { return message }
        if let explanation = explanation, !explanation.isEmpty { return explanation }
        return "Base.Error.Error"
    }
    
    public init(code: ErrorCode? = nil, message: String? = nil, details: ErrorDetailsItem? = nil) {
        self.code = code
        self.message = message
        self.details = details
    }
    
    public init(data: Data) {
        do {
            let item = try JSONDecoder().decode(ErrorItem?.self, from: data)
            if let result = item {
                self = result
            } else {
                self.code = .error
            }
        } catch {
            self.code = .error
        }
    }
}

public enum ErrorCode: String, Codable {
    case error = "0"
    case badRequest = "400"
}

public enum ErrorType: String, Codable {
    case error = "ERROR"
    case security = "SECURITY"
    case technical = "TECHNICAL"
    case business = "BUSINESS"
    case validation = "VALIDATION"
}

public struct ValidationErrorItem: Decodable {
    public let code: String?
    public let message: String?
    public let key: String?
}

public struct ErrorDetailsItem: Decodable {
    public let response: String?
    public let statusCode: String?
}

public struct ResponseErrorItem: Decodable {
    public let error: ErrorItem?
}
