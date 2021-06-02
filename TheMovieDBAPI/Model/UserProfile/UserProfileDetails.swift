//
//  UserProfileDetails.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 06.05.2021.
//

public struct UserProfileDetails: Decodable {
    
    // MARK: - Public properties
    
    public let avatar: Avatar
    public let id: Int
    public let name: String?
    public let includeAdult: Bool
    public let username: String
    
    public struct Avatar: Codable {
        public let gravatar: Gravatar
    }
    
    public struct Gravatar: Codable {
        public let hash: String
    }
}
