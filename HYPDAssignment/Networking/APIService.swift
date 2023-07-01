//
//  APIService.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 30/06/23.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    
    func get<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(APIConfiguration.baseURL)\(endpoint)"
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func post<T: Codable>(endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnBaQ0k2SWpZME56UmhOemRoTkRCa1pqQXhNVFpqWTJOaE1EVTVOeUlzSW1OMWMzUnZiV1Z5WDJsa0lqb2lOalEzTkdFM04yRTBNR1JtTURFeE5tTmpZMkV3TlRrNElpd2lZMkZ5ZEY5cFpDSTZJalkwTnpSaE56ZGhOREJrWmpBeE1UWmpZMk5oTURVNU9TSXNJblI1Y0dVaU9pSmpkWE4wYjIxbGNpSXNJbkp2YkdVaU9pSjFjMlZ5SWl3aWRYTmxjbDluY205MWNITWlPbTUxYkd3c0ltWjFiR3hmYm1GdFpTSTZJaUlzSW1SdllpSTZJakF3TURFdE1ERXRNREZVTURBNk1EQTZNREJhSWl3aVpXMWhhV3dpT2lKaGVXVXVZbUZpZFdOb1lXdEFhRzkwYldGcGJDNWpiMjBpTENKd2FHOXVaVjl1YnlJNmV5SndjbVZtYVhnaU9pSXJPVEVpTENKdWRXMWlaWElpT2lJNU5UWXdORFl5TlRRMEluMHNJbkJ5YjJacGJHVmZhVzFoWjJVaU9tNTFiR3dzSW5Cb2IyNWxYM1psY21sbWFXVmtJanAwY25WbExDSnBibVpzZFdWdVkyVnlYMmx1Wm04aU9uc2lYMmxrSWpvaU5qUTNOR0U0TWpNME1HUm1NREV4Tm1OalkyRXdOVGxpSWl3aWJtRnRaU0k2SWtOb1lXMXdZV3RzWVd3Z1NtRjVZVzUwYVd4aGJDQkhZV1JoSWl3aWRYTmxjbTVoYldVaU9pSmphR0Z0Y0dGcklpd2liMjVpYjJGeVpHbHVaMTl6ZEdGblpYTWlPbnNpZDJWc1kyOXRaVjl6WTNKbFpXNWZibTkwWDNacFpYZGxaQ0k2Wm1Gc2MyVXNJbk4wYjNKcFpYTmZibTkwWDNacFpYZGxaQ0k2Wm1Gc2MyVXNJbk4wYjNKbFgyNXZkRjlqY21WaGRHVmtJanBtWVd4elpTd2laM1ZwWkdWa1gycHZkWEp1WlhsZmJtOTBYMk52YlhCc1pYUmxaQ0k2ZEhKMVpYMTlMQ0pqY21WaGRHVmtYM1pwWVNJNkltMXZZbWxzWlNKOS5QTnA0cUxHaHA2QmQya0ZzTU5DTjlOTjhLMmYtUzY0b0JnZ1Q5TlVqVlRz",
            "Content-Type": "application/json"
        ]
        
        let url = "\(APIConfiguration.baseURL)\(endpoint)"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
