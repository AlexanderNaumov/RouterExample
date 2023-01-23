import SwiftUI

private struct AlertModifier: ViewModifier {
    let path: String
    let alert: ([String: String]) -> Alert
    @EnvironmentObject private var navigator: Navigator
    @State private var isPresented = false
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                let params = params(path, path: navigator.path.value)
                return alert(params)
            }
            .onChange(of: isPresented) {
                guard !$0 else { return }
                navigator.back(with: path)
            }
            .onReceive(navigator.path) { _ in
                isPresented = navigator.contains(path)
            }
    }
}

public extension View {
    @ViewBuilder func alert(_ path: String, alert: @escaping ([String: String]) -> Alert) -> some View {
        modifier(AlertModifier(path: path, alert: alert))
    }
    @ViewBuilder func alert(_ path: String, alert: @escaping () -> Alert) -> some View {
        modifier(AlertModifier(path: path) { _ in
            alert()
        })
    }
}
