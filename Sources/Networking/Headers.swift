//
//  Headers.swift
//  LoveLocal
//
//  Created by Fahim on 25/04/24.
//

import Foundation

public struct Headers: Encodable {
    public var x_access_token: String?
    public var client_code: String?
    public var source: String?
    public var Client_Version: String?
    public var customer_id: String?
    public var Content_Type: String?
    public var Accept_Language: String?
    public var Authorization: String?

    public init(
        x_access_token: String? = nil,
        client_code: String? = nil,
        source: String? = nil,
        Client_Version: String? = nil,
        customer_id: String? = nil,
        Content_Type: String? = nil,
        Accept_Language: String? = nil,
        Authorization: String? = nil
    ) {
        self.x_access_token = x_access_token
        self.client_code = client_code
        self.source = source
        self.Client_Version = Client_Version
        self.customer_id = customer_id
        self.Content_Type = Content_Type
        self.Accept_Language = Accept_Language
        self.Authorization = Authorization
    }
}
