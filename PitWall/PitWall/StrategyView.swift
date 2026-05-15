import SwiftUI

struct StrategyRequest: Codable {
    let circuitName: String
    let countryName: String
    let driverName: String
    let driverNumber: Int
    let currentLap: Int
    let totalLaps: Int
    let position: Int
    let tireCompound: String
    let tireAge: Int
    let gapAhead: Double
    let gapBehind: Double
    let weatherCondition: String
}

struct StrategyResponse: Codable {
    let strategy: String
    let generatedAt: String
}

struct StrategyView: View {
    let session: RaceSession
    var prefilledDriver: Driver? = nil

    @State private var driverName: String
    @State private var driverNumber: String
    @State private var currentLap = 30
    @State private var totalLaps = 57
    @State private var position = "2"
    @State private var tireCompound = "Medium"
    @State private var tireAge = "15"
    @State private var gapAhead = "1.2"
    @State private var gapBehind = "3.5"
    @State private var weatherCondition = "Dry"
    @State private var strategyResult = ""
    @State private var isLoading = false

    let tireOptions = ["Soft", "Medium", "Hard", "Intermediate", "Wet"]

    init(session: RaceSession, prefilledDriver: Driver? = nil) {
        self.session = session
        self.prefilledDriver = prefilledDriver
        self._driverName = State(initialValue: prefilledDriver?.fullName ?? "Max Verstappen")
        self._driverNumber = State(initialValue: prefilledDriver.map { "\($0.driverNumber)" } ?? "1")
        // Auto-fill total laps from circuit database
        let info = circuitDatabase[session.circuitShortName] ?? circuitDatabase[session.location]
        self._totalLaps = State(initialValue: info?.laps ?? 57)
    }

    var teamColor: Color {
        guard let hex = prefilledDriver?.teamColour else { return .red }
        return Color(hex: hex) ?? .red
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Gradient header — matches web exactly
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [Color(red: 0.1, green: 0, blue: 0),
                                         Color(red: 0.18, green: 0, blue: 0),
                                         Color(white: 0.07)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(teamColor.opacity(0.3), lineWidth: 1)
                            )

                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("STRATEGY")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.red)
                                    .tracking(1)
                                Text(session.circuitShortName)
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundColor(.white)
                                Text("\(driverName) #\(driverNumber)")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(white: 0.5))
                            }
                            Spacer()
                            Text(session.countryName)
                                .font(.system(size: 13))
                                .foregroundColor(Color(white: 0.5))
                        }
                        .padding(20)
                    }
                    .padding(.horizontal)

                    // Input fields grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        inputField("Driver Name", text: $driverName)
                        inputField("Driver Number", text: $driverNumber)
                        inputField("Position", text: $position)
                        inputField("Tire Age (laps)", text: $tireAge)
                        inputField("Gap Ahead (sec)", text: $gapAhead)
                        inputField("Gap Behind (sec)", text: $gapBehind)
                    }
                    .padding(.horizontal)

                    // Lap steppers
                    HStack(spacing: 12) {
                        stepperField("Current Lap", value: $currentLap, range: 1...100)
                        stepperField("Total Laps", value: $totalLaps, range: 1...100)
                    }
                    .padding(.horizontal)

                    // Tire compound — ABOVE track conditions (matches web)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("TIRE COMPOUND")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(white: 0.4))
                            .tracking(0.5)
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(tireOptions, id: \.self) { tire in
                                    Button(tire) {
                                        tireCompound = tire
                                    }
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(tireCompound == tire ? tireColor(tire) : Color(white: 0.1))
                                    .foregroundColor(tireCompound == tire && tire == "Hard" ? .black : tireCompound == tire ? .black : .white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(tireCompound == tire ? tireColor(tire) : Color(white: 0.2), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Track conditions — BELOW tire compound (matches web)
                    WeatherSelector(selected: $weatherCondition)
                        .padding(.horizontal)

                    // Get AI Strategy button
                    Button(action: fetchStrategy) {
                        HStack(spacing: 10) {
                            if isLoading {
                                ProgressView().tint(.white)
                                Text("Analyzing...")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("🧠")
                                Text("Get AI Strategy")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: isLoading ? [Color.gray, Color.gray] : [Color.red, Color(red: 0.75, green: 0, blue: 0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: Color.red.opacity(0.4), radius: 10, x: 0, y: 4)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal)

                    // Strategy result card
                    if !strategyResult.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("📡")
                                    .font(.system(size: 14))
                                Text("STRATEGY CALL")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.red)
                                    .tracking(1.5)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 16))
                            }
                            Divider()
                                .background(Color.red.opacity(0.3))
                            // Render each line with markdown-style bold
                            ForEach(strategyResult.components(separatedBy: "\n"), id: \.self) { line in
                                Text(parseMarkdown(line))
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(16)
                        .background(Color(white: 0.07))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.red.opacity(0.25), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Strategy")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Parse **bold** markdown into AttributedString
    func parseMarkdown(_ text: String) -> AttributedString {
        var result = AttributedString()
        let parts = text.components(separatedBy: "**")
        for (i, part) in parts.enumerated() {
            var attr = AttributedString(part)
            if i % 2 == 1 {
                attr.font = .system(size: 14, weight: .bold)
                attr.foregroundColor = .white
            } else {
                attr.font = .system(size: 14)
                attr.foregroundColor = Color(white: 0.8)
            }
            result.append(attr)
        }
        return result
    }

    func inputField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(Color(white: 0.4))
                .tracking(0.5)
            TextField("", text: text)
                .foregroundColor(.white)
                .padding(11)
                .background(Color(white: 0.07))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(white: 0.14), lineWidth: 1)
                )
        }
    }

    func stepperField(_ label: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(Color(white: 0.4))
                .tracking(0.5)
            HStack {
                Button(action: { if value.wrappedValue > range.lowerBound { value.wrappedValue -= 1 } }) {
                    Text("−")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.red)
                        .frame(width: 36, height: 36)
                }
                Spacer()
                Text("\(value.wrappedValue)")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                Button(action: { if value.wrappedValue < range.upperBound { value.wrappedValue += 1 } }) {
                    Text("+")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.red)
                        .frame(width: 36, height: 36)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(Color(white: 0.07))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(white: 0.14), lineWidth: 1)
            )
        }
    }

    func tireColor(_ tire: String) -> Color {
        switch tire {
        case "Soft": return Color(red: 0.91, green: 0, blue: 0.18)
        case "Medium": return Color(red: 1, green: 0.84, blue: 0)
        case "Hard": return .white
        case "Intermediate": return Color(red: 0.22, green: 0.71, blue: 0.29)
        case "Wet": return Color(red: 0, green: 0.4, blue: 1)
        default: return .gray
        }
    }

    func fetchStrategy() {
        isLoading = true
        strategyResult = ""
        guard let url = URL(string: "https://pitwallapi.azurewebsites.net/api/strategy") else { return }
        let requestBody = StrategyRequest(
            circuitName: session.circuitShortName,
            countryName: session.countryName,
            driverName: driverName,
            driverNumber: Int(driverNumber) ?? 1,
            currentLap: currentLap,
            totalLaps: totalLaps,
            position: Int(position) ?? 1,
            tireCompound: tireCompound,
            tireAge: Int(tireAge) ?? 0,
            gapAhead: Double(gapAhead) ?? 0,
            gapBehind: Double(gapBehind) ?? 0,
            weatherCondition: weatherCondition
        )
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data,
                   let response = try? JSONDecoder().decode(StrategyResponse.self, from: data) {
                    strategyResult = response.strategy
                }
            }
        }.resume()
    }
}
