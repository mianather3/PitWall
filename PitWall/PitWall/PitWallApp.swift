import SwiftUI
import Supabase

@main
struct PitWallApp: App {
    @State private var isAuthenticated = false
    @State private var userEmail = ""

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView(userEmail: $userEmail, isAuthenticated: $isAuthenticated)
            } else {
                AuthView(isAuthenticated: $isAuthenticated, userEmail: $userEmail)
            }
        }
    }
}
