//
//  URLRequestBuildable.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 02.05.2021.
//

import Apexy

extension URLRequestBuildable {

    /// Create HTTP DELETE request.
    ///
    /// - Parameters:
    ///   - url: Request URL.
    ///   - body: Request HTTPBody
    /// - Returns: HTTP DELETE request.
    func delete(_ url: URL, body: HTTPBody?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let body = body {
            request.setValue(body.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = body.data
        }
        return request
    }
}
