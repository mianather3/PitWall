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

    init(session: RaceSession, prefilledDriver: Driver? = nil) {
        self.session = session
        self._driverName = State(initialValue: prefilledDriver?.fullName ?? "Max Verstappen")
        self._driverNumber = State(initialValue: prefilledDriver.map { "\($0.driverNumber)" } ?? "1")
    }
    
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
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Circuit header
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [Color.red.opacity(0.25), Color.black],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 100)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.circuitShortName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                Text("\(driverName) · #\(driverNumber)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(session.countryName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("STRATEGY")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.red)
                                    .tracking(1)
                            }
                        }
                        .padding()
                    }
                    
                    // Input fields
                    Group {
                        inputField("Driver Name", text: $driverName)
                        inputField("Driver Number", text: $driverNumber)
                        inputField("Position", text: $position)
                        inputField("Tire Age (laps)", text: $tireAge)
                        inputField("Gap Ahead (sec)", text: $gapAhead)
                        inputField("Gap Behind (sec)", text: $gapBehind)
                        stepperField("Current Lap", value: $currentLap, range: 1...100)
                        stepperField("Total Laps", value: $totalLaps, range: 1...100)
                    }
                    
                    // Weather selector
                    WeatherSelector(selected: $weatherCondition)
                    
                    // Tire selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tire Compound")
                            .font(.caption)
                            .foregroundColor(.gray)
                        HStack {
                            ForEach(tireOptions, id: \.self) { tire in
                                Button(tire) {
                                    tireCompound = tire
                                }
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(tireCompound == tire ? tireColor(tire) : Color(white: 0.2))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color(white: 0.1))
                    .cornerRadius(12)
                    
                    // Analyze button
                    Button(action: fetchStrategy) {
                        HStack(spacing: 10) {
                            if isLoading {
                                ProgressView().tint(.white)
                                Text("Analyzing race data...")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 18))
                                Text("Get AI Strategy")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            isLoading ?
                            LinearGradient(colors: [Color.gray, Color.gray.opacity(0.7)], startPoint: .leading, endPoint: .trailing) :
                            LinearGradient(colors: [Color.red, Color(red: 0.8, green: 0, blue: 0)], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: Color.red.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isLoading)
                    
                    // Strategy result
                    if !strategyResult.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                    .foregroundColor(.red)
                                Text("STRATEGY CALL")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.red)
                                    .tracking(2)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 16))
                            }
                            Divider()
                                .background(Color.red.opacity(0.3))
                            Text(strategyResult)
                                .foregroundColor(.white)
                                .font(.system(size: 14, design: .monospaced))
                                .lineSpacing(4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(white: 0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.red.opacity(0.6), Color.red.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Strategy")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func inputField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("", text: text)
                .foregroundColor(.white)
                .padding(10)
                .background(Color(white: 0.15))
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    func stepperField(_ label: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            HStack {
                Button(action: { if value.wrappedValue > range.lowerBound { value.wrappedValue -= 1 } }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                }
                Spacer()
                Text("\(value.wrappedValue)")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button(action: { if value.wrappedValue < range.upperBound { value.wrappedValue += 1 } }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                }
            }
            .padding(10)
            .background(Color(white: 0.15))
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    func tireColor(_ tire: String) -> Color {
        switch tire {
        case "Soft": return .red
        case "Medium": return .yellow
        case "Hard": return .white.opacity(0.8)
        case "Intermediate": return .green
        case "Wet": return .blue
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
