//
//  FullTokenData.swift
//  TheMovieDBAPI
//
//  Created by Павел Духовенко on 02.05.2021.
//

public struct FullTokenData: Decodable {
    public let requestToken: String
    public let expiresAt: String
    public let success: Bool
}
