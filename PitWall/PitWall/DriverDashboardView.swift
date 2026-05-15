import SwiftUI

struct Driver: Codable, Identifiable {
    var id: Int { driverNumber }
    let driverNumber: Int
    let fullName: String
    let nameAcronym: String
    let teamName: String
    let teamColour: String?
    let position: Int?

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case fullName = "full_name"
        case nameAcronym = "name_acronym"
        case teamName = "team_name"
        case teamColour = "team_colour"
        case position
    }
}

struct DriverDashboardView: View {
    let session: RaceSession
    @State private var drivers: [Driver] = []
    @State private var isLoading = false
    @State private var selectedDriver: Driver?

    var countryFlag: String {
        let flags: [String: String] = [
            "Australia": "🇦🇺", "China": "🇨🇳", "Japan": "🇯🇵",
            "Bahrain": "🇧🇭", "Saudi Arabia": "🇸🇦", "United States": "🇺🇸",
            "Italy": "🇮🇹", "Monaco": "🇲🇨", "Spain": "🇪🇸",
            "Canada": "🇨🇦", "Austria": "🇦🇹", "United Kingdom": "🇬🇧",
            "Belgium": "🇧🇪", "Hungary": "🇭🇺", "Netherlands": "🇳🇱",
            "Azerbaijan": "🇦🇿", "Singapore": "🇸🇬", "Mexico": "🇲🇽",
            "Brazil": "🇧🇷", "United Arab Emirates": "🇦🇪", "Qatar": "🇶🇦"
        ]
        return flags[session.countryName] ?? "🏁"
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {

                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(session.circuitShortName)
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundColor(.white)
                        HStack(spacing: 5) {
                            Text(countryFlag)
                                .font(.system(size: 13))
                            Text(session.countryName)
                                .font(.system(size: 13))
                                .foregroundColor(Color(white: 0.45))
                        }
                    }
                    Spacer()
                    Text("DRIVER STANDINGS")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.red)
                        .tracking(1)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)

                if isLoading {
                    Spacer()
                    ProgressView().tint(.red)
                    Text("Loading drivers...")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else if drivers.isEmpty {
                    Spacer()
                    Text("No driver data available")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(drivers) { driver in
                                DriverCard(driver: driver)
                                    .onTapGesture { selectedDriver = driver }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Driver Standings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedDriver) { driver in
            NavigationView {
                StrategyView(session: session, prefilledDriver: driver)
            }
        }
        .task { await fetchDrivers() }
    }

    func fetchDrivers() async {
        isLoading = true
        guard let url = URL(string: "https://api.openf1.org/v1/drivers?session_key=\(session.sessionKey)") else {
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Driver].self, from: data)
            let unique = Dictionary(grouping: decoded, by: { $0.driverNumber })
                .compactMap { $0.value.first }
                .sorted { ($0.driverNumber) < ($1.driverNumber) }
            drivers = unique
        } catch {
            print("Driver fetch error: \(error)")
        }
        isLoading = false
    }
}

struct DriverCard: View {
    let driver: Driver

    var teamColor: Color {
        guard let hex = driver.teamColour else { return .gray }
        return Color(hex: hex) ?? .gray
    }

    var body: some View {
        HStack(spacing: 14) {
            // Team color bar
            RoundedRectangle(cornerRadius: 2)
                .fill(teamColor)
                .frame(width: 4, height: 48)

            // Acronym badge
            Text(driver.nameAcronym)
                .font(.system(size: 12, weight: .black))
                .foregroundColor(teamColor)
                .frame(width: 44, height: 36)
                .background(teamColor.opacity(0.13))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(teamColor.opacity(0.3), lineWidth: 1)
                )

            // Driver info
            VStack(alignment: .leading, spacing: 3) {
                Text(driver.fullName.split(separator: " ").map { word in
                    word == word.uppercased() ? word.capitalized : String(word)
                }.joined(separator: " "))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(driver.teamName)
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.4))
            }

            Spacer()

            Text("#\(driver.driverNumber)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(teamColor)

            Image(systemName: "chevron.right")
                .foregroundColor(Color(white: 0.3))
                .font(.system(size: 11))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(white: 0.07))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(white: 0.12), lineWidth: 1)
        )
    }
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
