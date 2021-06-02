//
//  UserCredentials.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 02.05.2021.
//

public struct UserCredentials: Codable {
    
    // MARK: - Public properties
    
    public var username: String
    public var password: String
    public var requestToken: String?
    
    // MARK: - Initialization
    
    public init(
        username: String,
        password: String,
        requestToken: String?) {
        
        self.username = username
        self.password = password
        self.requestToken = requestToken
    }
}
