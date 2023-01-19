import SwiftUI
import Router

struct SheetView: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        VStack {
            Button {
                navigator.navigate("/sheet/vasa")
            } label: {
                Text("Show Sheet")
            }
        }
    }
}
