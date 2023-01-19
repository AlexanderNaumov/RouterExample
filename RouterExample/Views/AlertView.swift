import SwiftUI
import Router

struct AlertView: View {
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        VStack {
            Button {
                navigator.navigate("/alert/new_vasa")
            } label: {
                Text("Show Alert")
            }
        }
    }
}
