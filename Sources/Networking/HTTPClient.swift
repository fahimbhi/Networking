
import Foundation
import Alamofire
import SwiftyJSON

public protocol HTTPClient {
    func performRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type,
        showActivity: Bool
    ) async -> Result<T, ErrorItem>
}

public final class ServiceManager: HTTPClient {
    public static let shared = ServiceManager()
    
    private lazy var manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        return Alamofire.Session(configuration: configuration)
    }()
    
    private init() {}
    
    public func performRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type,
        showActivity: Bool = true
    ) async -> Result<T, ErrorItem> {
        
        let urlString = "\(endpoint.baseURL)\(endpoint.path)"
        
        guard let _ = URL(string: urlString) else {
            return .failure(ErrorItem(code: .none, message: "Invalid URL"))
        }
        
        let dataTask = manager.request(
            urlString,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        ).validate().serializingData()
        
        let response = await dataTask.response
        
        guard let statusCode = response.response?.statusCode else {
            return .failure(ErrorItem(code: .none, message: "Invalid status code"))
        }
        
        switch statusCode {
        case 200...299, 428:
            guard let data = response.data else {
                return .failure(ErrorItem(code: .none, message: "Empty response"))
            }
            do {
                let decodedItem = try JSONDecoder().decode(responseModel, from: data)
                return .success(decodedItem)
            } catch {
                return .failure(ErrorItem(code: .none, message: "Decoding error"))
            }
        case 400, 402...427, 429...499:
            guard let data = response.data,
                  let decodedError = try? JSONDecoder().decode(ResponseErrorItem.self, from: data),
                  let errorItem = decodedError.error else {
                return .failure(ErrorItem(code: .none, message: "Client error"))
            }
            return .failure(errorItem)
        default:
            let details = ErrorDetailsItem(statusCode: "\(statusCode)",
                                           response: String(data: response.data ?? Data(), encoding: .utf8))
            if let data = response.data,
               var errorItem = try? JSONDecoder().decode(ResponseErrorItem.self, from: data).error {
                errorItem.details = details
                return .failure(errorItem)
            }
            return .failure(ErrorItem(code: .none, message: "Server error", details: details))
        }
    }
}
