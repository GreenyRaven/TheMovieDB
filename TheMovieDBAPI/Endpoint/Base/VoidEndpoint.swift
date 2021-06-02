//
//  VoidEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 01.05.2021.
//

import Apexy

protocol VoidEndpoint: Endpoint, URLRequestBuildable where Content == Void {}

extension VoidEndpoint {
    
    // MARK: - Public methods
    
    public func validate(_ request: URLRequest?, response: HTTPURLResponse, data: Data?) throws {
        try ResponseValidator.validate(response, with: data)
    }
    
    public func content(from response: URLResponse?, with body: Data) throws {}
}
