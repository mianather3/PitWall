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
                        Text("PitWall")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    
                    Text("2025 Race Calendar — Tap a race for AI Strategy")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView().tint(.red)
                        Text("Loading race data...")
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        Text(error).foregroundColor(.red).padding()
                        Spacer()
                    } else {
                        List(viewModel.sessions) { session in
                            NavigationLink(destination: StrategyView(session: session)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(session.circuitShortName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(session.countryName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(session.dateStart.prefix(10))
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color(white: 0.1))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
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

#Preview {
    ContentView()
}
