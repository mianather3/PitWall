import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RaceViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Image(systemName: "flag.checkered")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("PitWall")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            Text("Your AI Race Strategist")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        // Live indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                            Text("2025")
                                .font(.caption.bold())
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(20)
                    }
                    .padding()
                    
                    Text("2025 Race Calendar — Tap a race for circuit info")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    
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
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.sessions) { session in
                                    NavigationLink(destination: RaceInfoView(session: session)) {
                                        RaceCardView(session: session)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .task {
                await viewModel.fetchSessions()
            }
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
            "Brazil": "🇧🇷", "United Arab Emirates": "🇦🇪",
            "Qatar": "🇶🇦", "USA": "🇺🇸"
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
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 60)
            .padding(.vertical, 16)
            .background(Color(white: 0.08))
            
            // Divider
            Rectangle()
                .fill(Color.red)
                .frame(width: 2)
            
            // Race info
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.circuitShortName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    HStack(spacing: 6) {
                        Text(countryFlag)
                            .font(.system(size: 14))
                        Text(session.countryName)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    .padding(.trailing, 16)
            }
            .background(Color(white: 0.1))
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(white: 0.15), lineWidth: 1)
        )
    }
}

#Preview {
    ContentView()
}
