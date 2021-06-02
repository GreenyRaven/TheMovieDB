//
//  GenresConfiguration.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 21.05.2021.
//

public struct GenresConfiguration: Decodable {
    public let genres: [Genre]?
}

public struct Genre: Decodable {
    public let id: Int?
    public let name: String?
}
