//
//  DataDownloader.swift
//  RenderingImaged
//
//  Created by Maktumhusen on 08/03/24.
//

import Foundation

// Define a protocol that URLSessionDataTask conforms to
protocol URLSessionDataTaskProtocol {
    func resume()
}

// Extend URLSessionDataTask to conform to URLSessionDataTaskProtocol
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// Define URLSessionProtocol
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

// Implement URLSessionWrapper conforming to URLSessionProtocol
struct URLSessionWrapper: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return URLSession.shared.dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}


class DataDownloader {
    private let url = "https://reqres.in/api/users?page=1"
    
    var page: Int?
    var per_page: Int?
    var total_pages: Int?
    var totalValues: Int?
    
    var users: [User]?
    
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSessionWrapper()) {
        self.urlSession = urlSession
    }
    
    /// Downloads and Parses JSON for the URL
    func getUserData(url: URL, completion: @escaping (Result<[User], Error>) -> Void) {
        var allUsers = [User]()
//        guard let url = URL(string: url) else { return }
        let task = urlSession.dataTask(with: url) {[weak self] (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    self?.page = json?["page"] as? Int
                    self?.per_page = json?["per_page"] as? Int
                    self?.total_pages = json?["total_pages"] as? Int
                    self?.totalValues = json?["total"] as? Int
                    
                    let usersArray = json?["data"] as? [[String: Any?]]
                    usersArray?.forEach({ userData in
                        let user_id = userData["id"] as? Int
                        let user_email = userData["email"] as? String
                        let user_firstName = userData["first_name"] as? String
                        let user_lastName = userData["last_name"] as? String
                        let user_avatar = userData["avatar"] as? String
                        
                        let user = User.init(id: user_id ?? 0, email: user_email ?? "", first_name: user_firstName ?? "", last_name: user_lastName ?? "", avatar_url: user_avatar ?? "")
                        allUsers.append(user)
                    })
                    self?.users = allUsers
                } catch {
                    print(error.localizedDescription)
                }
                completion(.success(allUsers))
            }
        }
        task.resume()
    }
}
