//
//  EndPoint.swift
//  LoveLocal
//
//  Created by Fahim on 22/04/24.
//

import Foundation
import Alamofire
import KeychainSwift


public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    
  var baseURL: String {
    return Constants.Network.API.baseUrl
  }
  
  var headers: HTTPHeaders? {

      let accessToken: String = UserDefaults.standard.value(forKey: Key.UserDefaults.accessToken) as? String ?? ""
      let customerID: String = UserDefaults.standard.value(forKey: Key.UserDefaults.userID) as? String ?? ""
      let language: String = UserDefaults.standard.value(forKey: Key.UserDefaults.language) as? String ?? ""
      let token: String = UserDefaults.standard.value(forKey: Key.UserDefaults.token) as? String ?? ""
      
      var result: HTTPHeaders = ["x-access-token": "\(accessToken)",
                 "client-code": "charmander",
                 "source": "ios_b2c_app",
                 "Client-Version": clientVersion,
                 "customer-id": "\(customerID)",
                 "Content-Type" : "application/json",
                 "Accept-Language" : "\(language)",
                 "Authorization" : "Token \(token)"
      ]
    return result
  }
  
    var encoding: ParameterEncoding {
      return JSONEncoding.default
    }
    
  var method: HTTPMethod {
    return .get
  }
  
  var parameters: Parameters? {
    return nil
  }
}

