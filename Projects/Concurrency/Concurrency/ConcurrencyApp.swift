import SwiftUI

@main
struct ConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            BasicAwaitAsyncView(
                viewModel: BasicAwaitAsyncViewModel()
            )
        }
    }
}
