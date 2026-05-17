import SwiftUI
import Supabase

struct ContentView: View {
    @Binding var userEmail: String
    @Binding var isAuthenticated: Bool
    @StateObject private var viewModel = RaceViewModel()
    @State private var selectedYear = 2025

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
                            Text(String(selectedYear))
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(20)

                        Button(action: {
                            Task {
                                try? await supabase.auth.signOut()
                                isAuthenticated = false
                                userEmail = ""
                            }
                        }) {
                            Text(userEmail.isEmpty ? "Sign In" : "Sign Out")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Color(white: 0.12))
                                .cornerRadius(20)
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(white: 0.2), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(white: 0.04))

                    HStack {
                        Text("\(String(selectedYear)) Race Calendar — Tap a race for circuit info")
                            .font(.system(size: 11))
                            .foregroundColor(Color(white: 0.35))
                        Spacer()
                        Menu {
                            ForEach([2023, 2024, 2025] as [Int], id: \.self) { yr in
                                Button {
                                    selectedYear = yr
                                    Task { await viewModel.fetchSessions(year: yr) }
                                } label: {
                                    HStack {
                                        Text("\(String(yr)) Season")
                                        if yr == selectedYear {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text("\(String(selectedYear)) Season")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.white)
                                VStack(spacing: 1) {
                                    Text("▲").font(.system(size: 7))
                                    Text("▼").font(.system(size: 7))
                                }
                                .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(white: 0.1))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(white: 0.2), lineWidth: 1)
                            )
                        }
                    }
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
    ContentView(userEmail: .constant(""), isAuthenticated: .constant(true))
}
