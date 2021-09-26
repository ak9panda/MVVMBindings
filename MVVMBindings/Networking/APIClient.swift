//
//  APIClient.swift
//  MVVMBindings
//
//  Created by admin on 26/09/2021.
//

import Foundation

public enum APIError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
    case somethingWrong
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .apiError:
            return NSLocalizedString("error from api", comment: "api")
        case .invalidEndpoint:
            return NSLocalizedString("Endpoint is invalid", comment: "endpoint")
        case .invalidResponse:
            return NSLocalizedString("Response is invalid", comment: "response")
        case .noData:
            return NSLocalizedString("there is no data", comment: "nodata")
        case .decodeError:
            return NSLocalizedString("error in decoding", comment: "decode")
        case .somethingWrong:
            return NSLocalizedString("something went wrong", comment: "something wrong")
        }
    }
}

class APIClient {
    
    static let shared = APIClient()
    
    func responseHandler<T : Codable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> (Result<T, APIError>)? {
        let tag = String(describing: T.self)
        if error != nil {
            print("\(tag): failed to fetch data. \(error!.localizedDescription) ")
            return .failure(APIError.apiError)
        }
        
        let response = urlResponse as! HTTPURLResponse
        
        if response.statusCode >= 200 && response.statusCode <= 300 {
            guard let data = data else {
                print("\(tag): empty data.")
                return .failure(APIError.noData)
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return .success(result)
            }catch {
                print("\(tag): failed to parse data.")
                return .failure(APIError.decodeError)
            }
        }else {
            print("\(tag): Network Error - Code: \(response.statusCode)")
            return .failure(APIError.invalidResponse)
        }
    }
}
