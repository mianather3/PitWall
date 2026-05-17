import SwiftUI
import Supabase

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    @Binding var userEmail: String

    @State private var mode = "signin"
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    @State private var message = ""
    @State private var loading = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    // Hero section
                    VStack(spacing: 16) {
                        Spacer().frame(height: 60)
                        Text("🏁")
                            .font(.system(size: 64))
                        Text("PitWall")
                            .font(.system(size: 42, weight: .heavy))
                            .foregroundColor(.white)
                        Text("Your AI Race Strategist")
                            .font(.system(size: 16))
                            .foregroundColor(Color(white: 0.45))
                        Spacer().frame(height: 20)

                        // Feature pills
                        VStack(spacing: 10) {
                            featurePill(icon: "🧠", text: "AI-powered pit stop strategy")
                            featurePill(icon: "🏎️", text: "Live 2023–2025 race calendars")
                            featurePill(icon: "👥", text: "Real driver & team data")
                            featurePill(icon: "📋", text: "Personal strategy history")
                        }
                        .padding(.horizontal, 24)

                        Spacer().frame(height: 30)
                    }

                    // Auth card
                    VStack(spacing: 16) {
                        // Mode tabs
                        HStack(spacing: 0) {
                            ForEach(["signin", "signup"], id: \.self) { m in
                                Button(action: {
                                    mode = m
                                    error = ""
                                    message = ""
                                }) {
                                    Text(m == "signin" ? "Sign In" : "Sign Up")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(mode == m ? .white : Color(white: 0.4))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(mode == m ? Color(white: 0.12) : Color.clear)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(4)
                        .background(Color(white: 0.06))
                        .cornerRadius(12)

                        // Email field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("EMAIL")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(white: 0.4))
                                .tracking(0.5)
                            TextField("", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color(white: 0.08))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(white: 0.15), lineWidth: 1))
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("PASSWORD")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(white: 0.4))
                                .tracking(0.5)
                            SecureField("", text: $password)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color(white: 0.08))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(white: 0.15), lineWidth: 1))
                        }

                        if !error.isEmpty {
                            Text(error)
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if !message.isEmpty {
                            Text(message)
                                .font(.system(size: 13))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Auth button
                        Button(action: handleAuth) {
                            HStack {
                                if loading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text(mode == "signin" ? "Sign In" : "Create Account")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.red)
                            .cornerRadius(14)
                        }
                        .disabled(loading)

                        // Continue without account
                        Button(action: { isAuthenticated = true }) {
                            Text("Continue without account")
                                .font(.system(size: 13))
                                .foregroundColor(Color(white: 0.4))
                        }
                        .padding(.top, 4)
                    }
                    .padding(24)
                    .background(Color(white: 0.06))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(white: 0.1), lineWidth: 1))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    func featurePill(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Text(icon).font(.system(size: 18))
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color(white: 0.7))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(white: 0.07))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(white: 0.1), lineWidth: 1))
    }

    func handleAuth() {
        loading = true
        error = ""
        message = ""
        Task {
            do {
                if mode == "signin" {
                    let session = try await supabase.auth.signIn(email: email, password: password)
                    await MainActor.run {
                        userEmail = session.user.email ?? ""
                        isAuthenticated = true
                    }
                } else {
                    try await supabase.auth.signUp(email: email, password: password)
                    await MainActor.run {
                        message = "Check your email to confirm your account, then sign in."
                        mode = "signin"
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                }
            }
            await MainActor.run { loading = false }
        }
    }
}
