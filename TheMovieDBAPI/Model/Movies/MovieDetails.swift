//
//  MovieDetails.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 16.05.2021.
//

public struct MovieDetails: Decodable {
    public let runtime: Int?
    public let posterPath: String?
    public let overview: String?
    public let releaseDate: String?
    public let genreIds: [Int]?
    public var genres: [Genre]?
    public let id: Int?
    public let originalTitle: String?
    public let title: String?
    public let voteCount: Int?
    public let voteAverage: Double?
    public var releaseYear: String? {
        guard let dateString = releaseDate else { return nil }
        let year = dateString.prefix(4)
        guard year.count == 4 else { return nil }
        return "(\(year))"
    }
}
