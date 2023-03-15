import SwiftUI

@main
struct GPTalkieApp: App {
    @StateObject private var statusItemManager = StatusItemManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(statusItemManager)
        }
    }
}
