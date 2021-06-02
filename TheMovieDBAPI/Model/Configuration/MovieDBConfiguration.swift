//
//  MovieDBConfiguration.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 18.05.2021.
//

import Foundation

public struct MovieDBConfiguration: Decodable {
    public let images: ImagesConfiguration
    public let changeKeys: [String]
    
    public struct ImagesConfiguration: Decodable {
        public let baseUrl: String
        public let secureBaseUrl: String
        public let backdropSizes: [String]
        public let logoSizes: [String]
        public let posterSizes: [String]
        public let profileSizes: [String]
        public let stillSizes: [String]
    }
}
