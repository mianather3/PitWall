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
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Image(systemName: "flag.checkered")
                        .foregroundColor(.red)
                    Text(session.circuitShortName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(session.countryName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(white: 0.1))
                
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
                                    .onTapGesture {
                                        selectedDriver = driver
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Driver Standings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedDriver) { driver in
            StrategyView(session: session, prefilledDriver: driver)
        }
        .task {
            await fetchDrivers()
        }
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
                .sorted { ($0.position ?? 99) < ($1.position ?? 99) }
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
        HStack(spacing: 16) {
            // Position
            Text(driver.position.map { "P\($0)" } ?? "--")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 36)
            
            // Team color bar
            RoundedRectangle(cornerRadius: 2)
                .fill(teamColor)
                .frame(width: 4, height: 44)
            
            // Driver info
            VStack(alignment: .leading, spacing: 2) {
                Text(driver.fullName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(driver.teamName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Number
            Text("#\(driver.driverNumber)")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(teamColor)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(white: 0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(teamColor.opacity(0.3), lineWidth: 1)
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
