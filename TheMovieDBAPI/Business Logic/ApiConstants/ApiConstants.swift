//
//  ApiConstants.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 07.05.2021.
//

import Foundation

enum ApiConstants {
    static let apiKey = "b258b8fbffeaee01618091204af60e26"
    static let apiKeyQueryTag = "api_key"
    static let sessionIDQueryTag = "session_id"
    static let pageTag = "page"
    static let languageTag = "language"
    static let languageISO6391code = "ru-RU"
    static let badRequestCode = 400
    static let wrongSessionIDCode = 3
    static var apiConfiguration: MovieDBConfiguration?
    static var genresConfiguration: GenresConfiguration?
}
