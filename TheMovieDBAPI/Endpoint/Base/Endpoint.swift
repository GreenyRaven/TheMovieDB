//
//  Endpoint.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 18.05.2021.
//

import Apexy

extension Endpoint {
    
    // MARK: - Public methods
    
    func getValidatedComponents(from url: URL) -> URLComponents? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: ApiConstants.apiKeyQueryTag, value: ApiConstants.apiKey)
        ]
        return components
    }
    
    func movieWithFilledGenres( from movieDetails: MovieDetails) -> MovieDetails {
        var genres: [Genre] = []
        movieDetails.genreIds?.forEach { id in
            let name = ApiConstants.genresConfiguration?.genres?.first(where: { id == $0.id })?.name
            let genreData = Genre(id: movieDetails.id, name: name)
            genres.append(genreData)
        }
        return MovieDetails(
            runtime: movieDetails.runtime,
            posterPath: movieDetails.posterPath,
            overview: movieDetails.overview,
            releaseDate: movieDetails.releaseDate,
            genreIds: movieDetails.genreIds,
            genres: genres,
            id: movieDetails.id,
            originalTitle: movieDetails.originalTitle,
            title: movieDetails.title,
            voteCount: movieDetails.voteCount,
            voteAverage: movieDetails.voteAverage)
    }
}
