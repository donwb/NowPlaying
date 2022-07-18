// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct NowPlayingResult: Codable {
    let nowPlaying: NowPlaying?
    let idle: Bool?
}

// MARK: - NowPlaying
struct NowPlaying: Codable {
    let artist, album, track: String?
    let art: String?
    let totalPlayCount: String?
    let artistRanking, myArtistPlayCount, maxRanks, myTrackPlayCount: Int?
    let myAlbumPlayCount: Int?

    enum CodingKeys: String, CodingKey {
        case artist, album, track, art, totalPlayCount
        case artistRanking = "ArtistRanking"
        case myArtistPlayCount = "MyArtistPlayCount"
        case maxRanks = "MaxRanks"
        case myTrackPlayCount = "MyTrackPlayCount"
        case myAlbumPlayCount = "MyAlbumPlayCount"
    }
}
