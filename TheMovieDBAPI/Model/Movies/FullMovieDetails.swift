//
//  FullMovieDetails.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 19.05.2021.
//

import UIKit

public struct FullMovieDetails {
    public let details: MovieDetails
    public var poster: MoviePoster?
    
    public init(details: MovieDetails, poster: MoviePoster?) {
        self.details = details
        self.poster = poster
    }
}
