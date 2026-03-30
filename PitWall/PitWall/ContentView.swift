import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Image(systemName: "flag.checkered")
                            .foregroundColor(.red)
                            .font(.system(size: 28))
                        Text("PitWall")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Your AI Race Strategist")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Status card
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(white: 0.12))
                        .frame(height: 120)
                        .overlay(
                            VStack {
                                Text("No Active Session")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Text("Race data will appear here")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        )
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 60)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
