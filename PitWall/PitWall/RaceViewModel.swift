import Foundation
import Combine

@MainActor
class RaceViewModel: ObservableObject {
    @Published var sessions: [RaceSession] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "http://localhost:5211/api/session") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([RaceSession].self, from: data)
            sessions = decoded.sorted { $0.dateStart > $1.dateStart }
        } catch {
            errorMessage = "Failed to load sessions: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
