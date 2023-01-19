import SwiftUI
import Router

struct FullScreenContent: View {
    let name: String
    
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        VStack {
            Text(name)
            Button("Close") {
                navigator.back()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
}
