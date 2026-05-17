import Foundation
import Combine

@MainActor
class RaceViewModel: ObservableObject {
    @Published var sessions: [RaceSession] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchSessions(year: Int = 2025) async {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://pitwallapi.azurewebsites.net/api/season?year=\(year)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([RaceSession].self, from: data)
            let unique = Dictionary(grouping: decoded.filter { $0.sessionName == "Race" }, by: { $0.circuitShortName })
                .compactMap { $0.value.first }
                .sorted { $0.dateStart < $1.dateStart }
            sessions = unique
        } catch {
            errorMessage = "Failed to load sessions: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
