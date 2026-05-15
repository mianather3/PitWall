import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RaceViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {

                    // Header
                    HStack(spacing: 10) {
                        Text("🏁")
                            .font(.system(size: 26))
                        Text("PitWall")
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundColor(.white)
                        Text("Your AI Race Strategist")
                            .font(.system(size: 11))
                            .foregroundColor(Color(white: 0.35))
                            .padding(.leading, 2)
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 7, height: 7)
                            Text("2025")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(white: 0.04))

                    Text("2025 Race Calendar — Tap a race for circuit info")
                        .font(.system(size: 11))
                        .foregroundColor(Color(white: 0.35))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)

                    if viewModel.isLoading {
                        Spacer()
                        ProgressView().tint(.red)
                        Text("Loading race calendar...")
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        Text(error).foregroundColor(.red).padding()
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 6) {
                                ForEach(viewModel.sessions) { session in
                                    NavigationLink(destination: RaceInfoView(session: session)) {
                                        RaceCardView(session: session)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .task { await viewModel.fetchSessions() }
        }
    }
}

struct RaceCardView: View {
    let session: RaceSession

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

    var raceMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: session.dateStart) {
            let out = DateFormatter()
            out.dateFormat = "MMM"
            return out.string(from: date).uppercased()
        }
        return String(session.dateStart.prefix(7).suffix(2))
    }

    var raceDay: String {
        String(session.dateStart.prefix(10).suffix(2))
    }

    var body: some View {
        HStack(spacing: 0) {
            // Date column
            VStack(spacing: 2) {
                Text(raceMonth)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.red)
                Text(raceDay)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.white)
            }
            .frame(width: 64)
            .padding(.vertical, 16)

            // Red divider
            Rectangle()
                .fill(Color.red)
                .frame(width: 1.5, height: 44)

            // Race info
            VStack(alignment: .leading, spacing: 4) {
                Text(session.circuitShortName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                HStack(spacing: 5) {
                    Text(countryFlag)
                        .font(.system(size: 13))
                    Text(session.countryName)
                        .font(.system(size: 13))
                        .foregroundColor(Color(white: 0.45))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Color(white: 0.3))
                .font(.system(size: 12))
                .padding(.trailing, 16)
        }
        .background(Color(white: 0.07))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
