//
//  ResponseValidator.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 01.05.2021.
//

enum ResponseValidator {
    
    // MARK: - Public methods
    
    static func validate(_ response: URLResponse?, with body: Data?) throws {
        guard let response = response as? HTTPURLResponse else { return }
        try validateAPIResponse(response, with: body ?? Data())
        try validateHTTPStatus(response)
    }
    
    // MARK: - Private methods
    
    private static func validateAPIResponse(_ response: HTTPURLResponse, with body: Data) throws {
        let decoder = JSONDecoder.default
        if let error = try? decoder.decode(APIError.self, from: body) {
            throw TheMovieDBError.apiError(error: error)
        }
    }
    
    private static func validateHTTPStatus(_ response: HTTPURLResponse) throws {
        guard !(200..<300).contains(response.statusCode) else { return }
        let error = HTTPError(statusCode: response.statusCode, url: response.url)
        throw TheMovieDBError.httpError(error: error)
    }
}
