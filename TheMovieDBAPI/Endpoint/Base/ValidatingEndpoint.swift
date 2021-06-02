//
//  ValidatingEndpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 01.05.2021.
//

import Apexy

protocol ValidatingEndpoint: Endpoint, URLRequestBuildable where Content: Decodable {}

extension ValidatingEndpoint {
            
    // MARK: Public methods
    
    public func validate(_ request: URLRequest?, response: HTTPURLResponse, data: Data?) throws {
        try ResponseValidator.validate(response, with: data)
    }
}
