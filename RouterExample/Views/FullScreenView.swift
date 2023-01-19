import SwiftUI
import Router

struct FullScreenView: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        VStack {
            Button {
                navigator.navigate("/fullscreen/vasa")
            } label: {
                Text("Show Fullscreen")
            }
        }
    }
}
