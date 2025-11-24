import SwiftUI

@main
struct TraceApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.light)
        }
    }
}

// App State Manager
class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentDay: Int = 1
    @Published var streak: Int = 0
    @Published var isPremium: Bool = false
    
    init() {
        loadUserPreferences()
    }
    
    func loadUserPreferences() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.currentDay = UserDefaults.standard.integer(forKey: "currentDay")
        self.streak = UserDefaults.standard.integer(forKey: "streak")
        self.isPremium = UserDefaults.standard.bool(forKey: "isPremium")
    }
    
    func saveUserPreferences() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(currentDay, forKey: "currentDay")
        UserDefaults.standard.set(streak, forKey: "streak")
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
    }
}
