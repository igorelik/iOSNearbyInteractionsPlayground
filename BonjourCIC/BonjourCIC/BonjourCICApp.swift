import SwiftUI

@main
struct BonjourCICApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
//                ContentView()
#if os(tvOS)
                PresentationMainView()
#else
                ModeSelectionView()
#endif
            }
        }
    }
}
