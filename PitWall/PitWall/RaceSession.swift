import Foundation

struct RaceSession: Codable, Identifiable {
    var id: Int { sessionKey }
    let sessionKey: Int
    let sessionType: String
    let sessionName: String
    let dateStart: String
    let circuitShortName: String
    let countryName: String
    let location: String
    let year: Int
    
    enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
        case sessionType = "session_type"
        case sessionName = "session_name"
        case dateStart = "date_start"
        case circuitShortName = "circuit_short_name"
        case countryName = "country_name"
        case location
        case year
    }
}
